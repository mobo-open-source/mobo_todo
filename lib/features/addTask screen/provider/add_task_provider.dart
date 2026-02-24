import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobo_todo/core/services/odoo_session_manager.dart';
import 'package:mobo_todo/shared/widgets/snackbars/custom_snackbar.dart';
import 'package:mobo_todo/features/dashboard%20screen/provider/dash_board_provider.dart';
import 'package:mobo_todo/features/login%20screen/provider/session_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/tag_provider.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/model/user_model.dart';
import 'package:provider/provider.dart';

class AddTaskProvider with ChangeNotifier {
  int userPage = 0;
  List<UserModel> userList = [];
  List<UserModel> selectedUserItems = [];
  bool isLoggedUserAutomaticallyAdded = false;
  bool isEmpty = false;
  bool isLoading = false;
  String userQuery = "";

  dynamic updateResponse;

  void clearProvider() {
    selectedUserItems.clear();
    userQuery = "";
    bool isLoggedUserAutomaticallyAdded = false;

    notifyListeners();
  }

  void emptytask() {
    isEmpty = true;
    notifyListeners();
  }

  void clearValidation(String value) {
    isEmpty = false;

    notifyListeners();
  }

  List<UserModel> getUsername(String query) {
    return userList
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> searchUser(String query) async {
    userQuery = query;
    notifyListeners();
    fethcUsers();
  }

  void removeSelection(String username) {
    selectedUserItems.removeWhere((item) => item.name == username);
    notifyListeners();
  }

  DateTime getInitialdate(String value) {
    if (value.isEmpty) {
      return DateTime.now();
    }
    return DateTime.parse(value);
  }

  void checkUserItem(UserModel user) {
    final exists = selectedUserItems.any((u) => u.id == user.id);
    if (exists) {
      selectedUserItems.removeWhere((u) => u.id == user.id);
    } else {
      selectedUserItems.add(user);
    }
    notifyListeners();
  }

  Future<void> setInitialUser() async {
    final session = await OdooSessionManager.getCurrentSession();

    final loggedUsername = session!.odooSession.userName ?? "";
    final match = userList.firstWhere(
      (e) => e.name == loggedUsername,
      orElse: () => UserModel(id: 0, name: ""),
    );
    if (match.id != 0 && !selectedUserItems.any((u) => u.id == match.id)) {
      selectedUserItems.add(match);
      isLoggedUserAutomaticallyAdded = true;
      notifyListeners();
    }
  }

  Future<void> fethcUsers() async {
    final session = await OdooSessionManager.getCurrentSession();
    final userId = session!.userId;
    final userResult = await OdooSessionManager.callKwWithCompany({
      'model': 'res.users',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'domain': userQuery.isNotEmpty
            ? [
                ['name', 'ilike', userQuery],
                ['share', '=', false],
                ['active', '=', true],
              ]
            : [
                ['share', '=', false],
                ['active', '=', true],
              ],
        'fields': ['id', 'name', "image_1920"],
      },
    });
    final List<dynamic> users = userResult;
    userList.clear();
    notifyListeners();
    userList = users.map((user) => UserModel.fromJson(user)).toList();
    if (!isLoggedUserAutomaticallyAdded) await setInitialUser();
  }


  int getOdooMajorVersion(String serverVersion) {
    final match = RegExp(r'^(\d+)').firstMatch(serverVersion);
    return match != null ? int.parse(match.group(1)!) : 0;
  }
  String? mapPriority({
    required int selectedIndex,
    required String serverVersion,
  }) {
    // Odoo 17  no priority support
    if (serverVersion == "17") {
      return null;
    }

    // Odoo 18 only "0" or "1"
    if (serverVersion == "18") {
      return selectedIndex >= 1 ? "1" : "0";
    }

    // Odoo 19+  0,1,2 allowed
    return selectedIndex.toString();
  }


Future<bool> addTask(
  BuildContext context, {
  int? id,
  required String name,
  List<int>? userId,
  List<int>? tagId,
  String? description,
  int? priority,
  String? deadline,
}) async {
  isLoading = true;
  notifyListeners();

  try {
    final client = await OdooSessionManager.getClient();
    final serverVersion = client!.sessionId!.serverVersion;
    final odooVersion = getOdooMajorVersion(serverVersion);

    final Map<String, dynamic> data = {
      'name': name,
      'user_ids': [
        [6, 0, userId ?? []],
      ],
      'tag_ids': [
        [6, 0, tagId ?? []],
      ],
      'description': description ?? "",
    };

    final priorityValue = mapPriority(
      selectedIndex: priority ?? 0,
      serverVersion: serverVersion,
    );

    if (priorityValue != null) {
      data['priority'] = priorityValue;
    }

    if (odooVersion == 19 &&
        deadline != null &&
        deadline.isNotEmpty) {
      data['date_deadline'] = deadline; // YYYY-MM-DD
    }

    await OdooSessionManager.callKwWithCompany({
      'model': 'project.task',
      'method': 'create',
      'args': [data],
      'kwargs': {},
    });

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    CustomSnackbar.showSuccess(
      context,
      "New Task added Successfully",
    );

    context.read<TagProvider>().selectedTagItems.clear();

    isLoading = false;
    notifyListeners();
    return true;
  } catch (e) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    CustomSnackbar.showError(context, "Task Added Failed");

    isLoading = false;
    notifyListeners();

    return false;
  }
}

  // Future<bool> addTask(
  //   int? id,
  //   required String name,
  //   List<int>? userId,
  //   List<int>? tagId,
  //   String? description,
  //   int? priority,
  //   String? deadline,

            
  //       'name': name,
  //       'user_ids': [
  //         [6, 0, userId ?? []],
  //       ],
  //       'tag_ids': [
  //         [6, 0, tagId],
  //       ],
        
  //       'description': description ?? "",
  //       'date_deadline': deadline ?? "",

  //       'priority':
  //           mapPriority(
  //             selectedIndex: priority!,
  //             serverVersion: serverversion,
  //           ) ??
  //           "0",
      
  //       'model': 'project.task',
  //       'method': 'create',
  //       'args': [data],
  //       'kwargs': {},








  Future<bool> updateTask(
    BuildContext context, {
    required int id,
    required String name,
    List<int>? userId,
    List<int>? tagId,
    String? description,
    String? priority,
    String? deadline,
  }) async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    try {

      final data = {
        'name': name,
        'user_ids': [
          [6, 0, userId ?? []],
        ],
        'tag_ids': [
          [6, 0, tagId ?? []],
        ],
        'description': description ?? "",
        'date_deadline': deadline ?? false,
        'priority': priority ?? "0",
      };
      final updateTask = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'write',
        'args': [
          [id],
          data,
        ],
        'kwargs': {},
      });
      updateResponse = updateTask;

      context.read<TaskProvider>().fetchTasks();
      Navigator.pop(context);
      CustomSnackbar.showSuccess(context, " Task Updated Successfully");
      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      Navigator.pop(context);
      CustomSnackbar.showError(context, " Task Updated Failed");
      isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<void> deleteTask(int taskId, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'unlink',
        'args': [
          [taskId],
        ],
        'kwargs': {},
      });

      context.read<DashBoardProvider>().selectedScreen = 1;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();

    }
  }
}
