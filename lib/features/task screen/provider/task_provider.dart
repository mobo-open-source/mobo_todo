import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobo_todo/core/services/odoo_session_manager.dart';
import 'package:mobo_todo/features/task%20screen/model/Task_model.dart';

/// Provider for managing tasks, handling filtering, pagination, and Odoo interaction.
class TaskProvider with ChangeNotifier {
  String odooVersion = '';
  List<TaskModel> todoList = [];
  List<dynamic> filterdomain = [];
  bool isLoading = false;
  int userPage = 0;
  String taskQuery = "";
  String userQuery = "";
  Set<int> userIds = {};
  bool isSelectedpriority = false;
  int selectedFilter = -1;
  int selectedIndex = -1;
  String username = "";
  List<dynamic> selectedFilterItem = [];
  List<String> appliedFilterItem = [];

  List<dynamic> filter = ["All items", "Completed", "Pending"];
  bool alltask = false;
  int get totalCount => _totalCount;
  int _totalCount = 0;
  static const int _pageSize = 40;
  int _currentPage = 0;
  int get pageSize => _pageSize;
  int get currentPage => _currentPage;
  int get startIndex => (_currentPage * _pageSize) + 1;

  bool allItem = false;
  int get endIndex {
    final end = (_currentPage + 1) * _pageSize;
    return end > _totalCount ? _totalCount : end;
  }

  bool get canGoPrevious => _currentPage > 0;
  bool get canGoNext => (_currentPage + 1) * _pageSize < _totalCount;

  int getOdooMajorVersion(String serverVersion) {
    final match = RegExp(r'^(\d+)').firstMatch(serverVersion);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  int getPriorityLength(String serverVersion) {
    final int version = int.parse(serverVersion);


    if (version == 17) return 0; // no priority
    if (version == 18) return 1; // only 0 / 1
    return 3; // Odoo 19+
  }

  Future<void> nextPage(BuildContext context, {String? searchQuery}) async {
    if (!canGoNext) return;
    _currentPage++;
    await fetchTasks();
  }

  Future<void> previousPage(BuildContext context, {String? searchQuery}) async {
    if (!canGoPrevious) return;
    _currentPage--;
    await fetchTasks();
  }

  /// Resets the task list and all associated filter/pagination states.
  void clearProvider() {
    todoList.clear();
    selectedIndex = -1;
    selectedFilterItem.clear();
    filterdomain.clear();
    appliedFilterItem.clear();

    notifyListeners();
  }

  Future<void> filterClear() async {
    selectedFilterItem.clear();
    appliedFilterItem.clear();
    await fetchTasks();
    notifyListeners();
  }

  Future<void> taskFilter(int index) async {
    final item = filter[index];
    if (item == "All items") {
      selectedFilterItem.clear();
      selectedFilterItem.add("All items");
    } else {
      selectedFilterItem.remove("All items");

      if (selectedFilterItem.contains(item)) {
        selectedFilterItem.remove(item);
      } else {
        selectedFilterItem.add(item);
      }

      if (selectedFilterItem.isEmpty) {
        selectedFilterItem.add("All items");
      }
    }
    notifyListeners();
    await fetchTasks();
  }

  void removeSelectedFilter(int index) {
    selectedFilterItem.removeAt(index);
    notifyListeners();
  }

  void searchFocus(FocusNode searchfocus) {
    searchfocus.addListener(() {
      notifyListeners();
    });
  }

  void selectFilter(int index) {
    final value = filter[index];

    if (value == "All items") {
      selectedFilterItem.clear();
      selectedFilterItem.add("All items");
    } else {
      selectedFilterItem.remove("All items");

      if (selectedFilterItem.contains(value)) {
        selectedFilterItem.remove(value);
      } else {
        selectedFilterItem.add(value);
      }

      if (selectedFilterItem.isEmpty) {
        selectedFilterItem.add("All items");
      }
    }

    notifyListeners();
  }

  void userFocus(FocusNode userNode) {
    userNode.addListener(() {
      notifyListeners();
    });
  }

  /// Triggers a task search with the specified [query].
  Future<void> searchTask(String query) async {
    if (query.isEmpty) {
      await fetchTasks();
    }
    _currentPage = 0;
    taskQuery = query;
    await fetchTasks();
  }


  void priority(int index) {

    if (selectedIndex == index) {
      selectedIndex = index - 1;
    } else {
      selectedIndex = index;
    }

    notifyListeners();
  }

  /// Fetches the paginated and filtered list of tasks from Odoo.
  Future<void> fetchTasks() async {
    isLoading = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 2));
    try {
      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;
      final client = await OdooSessionManager.getClient();

      final serverversion = client!.sessionId!.serverVersion;
      final odooversion = getOdooMajorVersion(serverversion);
    odooVersion = odooversion.toString();
     

      final offset = _currentPage * _pageSize;
      final List<dynamic> domain = [
        [
          'user_ids',
          'in',
          [userId],
        ],
        ['project_id', '=', false],
        ['parent_id', '=', false],
        ['display_in_project', '=', true],
      ];

      if (taskQuery.isNotEmpty) {
        domain.add(['name', 'ilike', taskQuery]);

      }

final bool completedSelected = selectedFilterItem.contains("Completed");
final bool pendingSelected = selectedFilterItem.contains("Pending");
final bool allSelected = selectedFilterItem.contains("All items");

if (!allSelected) {
  if (serverversion == "17") {
    if (completedSelected && !pendingSelected) {
      domain.add([
        'state',
        'in',
        ['1_done', '1_canceled']
      ]);
    } else if (!completedSelected && pendingSelected) {
      domain.add([
        'state',
        'not in',
        ['1_done', '1_canceled']
      ]);
    }
  } else {
    if (completedSelected && !pendingSelected) {
      domain.add(['is_closed', '=', true]);
    } else if (!completedSelected && pendingSelected) {
      domain.add(['is_closed', '=', false]);
    }
  }
}



      final tasks = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': domain,
          'fields': [
            'id',
            'name',
            'date_deadline',
            'activity_ids',
            'tag_ids',
            'user_ids',
            'personal_stage_type_id',
            'priority',
            'description',
          ],

          'limit': _pageSize,
          'offset': offset,
        },
      });
      final totalTaskCount = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_count',
        'args': [domain],
        'kwargs': {},
      });
      _totalCount = totalTaskCount;

      notifyListeners();
      final userResult = await OdooSessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['id', 'name'],
        },
      });
      final Map<int, String> userMap = {
        for (var user in userResult) user['id']: user['name'],
      };
      final List<Map<String, dynamic>> finalTasks = [];
      for (var task in tasks) {
        final ids = List<int>.from(task['user_ids']);
        task['user_names'] = ids.map((id) => userMap[id] ?? "").toList();
        finalTasks.add(task);
      }
      todoList = finalTasks.map((e) => TaskModel.fromMap(e)).toList();
      isLoading = false;

      notifyListeners();

    } catch (e) {
      isLoading = false;

      notifyListeners();
    }
  }
}
