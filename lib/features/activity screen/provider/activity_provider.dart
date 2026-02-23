import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobo_todo/core/services/odoo_session_manager.dart';
import 'package:mobo_todo/core/widget/snackbar.dart';
import 'package:mobo_todo/features/activity%20screen/model/activity_model.dart';
import 'package:mobo_todo/features/activity%20screen/model/activity_type_model.dart';
import 'package:mobo_todo/features/addTask%20screen/model/user_model.dart';

class ActivityProvider with ChangeNotifier {
  bool isloding = false;

  List<UserModel> activityUser = [];
  List<ActivityModel> activity = [];
  List<ActivityTypeModel> activityType = [];
  ActivityTypeModel? selecteActivity;
  UserModel? selectUser;
  String userQuery = "";
  String activityQuery = "";


  void clearProvider() {
    activityUser.clear();
    activity.clear();
    selecteActivity = null;
    userQuery = "";
    activityQuery = "";
    notifyListeners();
  }

  void focusActivity(FocusNode node) {
    node.addListener(() {
      notifyListeners();
    });
  }

  void onSelecteeUser(UserModel value) {
    selectUser = value;


    notifyListeners();
  }

  void onSelectedtype(ActivityTypeModel value) {
    selecteActivity = value;
    notifyListeners();
  }

  void clearSelectedUser(TextEditingController value) {
    selectUser = null;
    value.clear();
    notifyListeners();
  }

  void clearSelectedActivity(TextEditingController value) {
    selecteActivity = null;
    value.clear();
    notifyListeners();
  }

  Future<void> searchUser(String query) async {
    userQuery = query;
    notifyListeners();
    await fethcActivityUsers();
  }

  Future<void> searchActivity(String Query) async {
    activityQuery = Query;
    
    notifyListeners();
    await fecthActivityType();
  }

  List<UserModel> getUsernames(String query) {
    return activityUser
        .where(
          (element) => element.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  List<ActivityTypeModel> getActivityType(String query) {
    return activityType
        .where(
          (element) => element.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Future<void> cancelActivities(int activityId, BuildContext context) async {
    try {
      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;
      final response = await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'unlink',
        'args': [
          [activityId],
        ],
        'kwargs': {},
      });
      CustomSnackbar.showSuccess(context, "Activity Canceled Successfully");
      await fetchActivities();
      notifyListeners();
    } catch (e) {
      CustomSnackbar.showError(context, "Activity Canceled failed");

    }
  }

  Future<void> doneActivities(int activityId, BuildContext context) async {
    try {
      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;
      final response = await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'action_done',
        'args': [
          [activityId],
        ],
        'kwargs': {},
      });
      CustomSnackbar.showSuccess(context, "Mark as done Successfully");
      await fetchActivities();
      notifyListeners();
    } catch (e) {
      CustomSnackbar.showError(context, "Mark as done failed");

    }
  }

  ////////////// ACTIVITY CREATION //////////
  Future<void> createActivity({
    required int taskId,
    required int activityTypeId,
    required int userId,
    required String summary,
    String? note,
    required String deadline,
    required BuildContext context,
  }) async {
    try {
      final session = await OdooSessionManager.getCurrentSession();
      final modelCheck = await OdooSessionManager.callKwWithCompany({
        'model': 'ir.model',
        'method': 'search_read',
        'args': [
          [
            ['model', '=', 'project.task'],
          ],
        ],
        'kwargs': {
          'fields': ['id', 'model'],
          'limit': 1,
        },
      });

      if (modelCheck.isEmpty) {
        throw Exception('Invalid model: project.task does not exist in Odoo');
      }
      final modelId = (modelCheck[0] as Map<String, dynamic>)['id'] as int;
      final activityData = {
        'res_model': 'project.task',
        'res_model_id': modelId,
        'res_id': taskId,
        'activity_type_id': activityTypeId,
        'summary': summary == '' ? "New Activity" : summary,

        'note': note,
        'user_id': userId,
        'date_deadline': deadline, // Date for non-meeting activities
      };
      // Create the activity
      final response = await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'create',
        'args': [activityData],
        'kwargs': {},
      });

      Navigator.pop(context);
      CustomSnackbar.showSuccess(context, "Activity sheduled Successfully");

      notifyListeners();
    } catch (e) {
      CustomSnackbar.showError(context, "Activity sheduled Failed");


    }
  }

  Future<void> fethcActivityUsers() async {
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
              ]
            : [],

        'fields': ['id', 'name', "image_1920"],
        // 'limit': 8,
      },
    });
    final List<dynamic> users = userResult;
    activityUser.clear();
    activityUser = users.map((user) => UserModel.fromJson(user)).toList();

    notifyListeners();
  }

  Future<void> fetchActivities() async {
    isloding = true;
    notifyListeners();
    try {
      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;

      final data = await Future.any([
        OdooSessionManager.safeCallRPC(
          '/web/session/get_session_info',
          'call',
          {},
        ),
        Future.delayed(const Duration(seconds: 15)).then(
          (_) => throw TimeoutException(
            'Request timed out',
            const Duration(seconds: 15),
          ),
        ),
      ]);

      final isAdmin = data['is_admin'];
      final activities = await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain':
              // [
              //   ['project_id', '=', false],
              //   ['parent_id', '=', false],
              //   ['display_in_project', '=', true],
              //   ['res_model', '=', 'project.task'],
              // ],
              [
                ['res_model', '=', 'project.task'],
                if (!isAdmin) ['user_id', '=', userId],
              ],
          'fields': [
            'summary',
            'note',
            'res_id',
            'res_name',
            'date_deadline',
            'user_id',
            'activity_type_id',
            'state',
          ],
          // 'limit': 20,
          // 'order': 'date_deadline asc',
        },
      });
      activity.clear();
      final activityList = activities as List;
      activity.addAll(activityList.map((e) => ActivityModel.fromJson(e)));
      notifyListeners();


      isloding = false;
      notifyListeners();
    } catch (e) {
      isloding = false;
      notifyListeners();
    }
  }

  Future<void> fecthActivityType() async {
    final session = await OdooSessionManager.getCurrentSession();
    final userId = session!.userId;

    final List<dynamic> domain = [
      '|',
      ['res_model', '=', false],
      ['res_model', '=', 'project.task'],
    ];

    if (activityQuery.isNotEmpty) {
      domain.add(['name', 'ilike', activityQuery]);
    }

    final response = await OdooSessionManager.callKwWithCompany({
      'model': 'mail.activity.type',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'domain': domain,
        'fields': ['id', 'name', 'icon'],
        "limit": 8,
        'order': 'sequence asc',
      },
    });

    activityType
      ..clear()
      ..addAll((response as List).map((e) => ActivityTypeModel.fromMap(e)));

    notifyListeners();
  }
}
