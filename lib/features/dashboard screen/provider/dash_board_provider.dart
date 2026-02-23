import 'dart:convert' show base64Decode;
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobo_todo/core/services/odoo_session_manager.dart';
import 'package:mobo_todo/features/login/pages/server_setup_screen.dart';
import 'package:mobo_todo/core/widget/snackbar.dart';
import 'package:mobo_todo/features/login%20screen/provider/auth_provider.dart';
import 'package:mobo_todo/features/dashboard%20screen/model/recent_task_model.dart';
import 'package:mobo_todo/features/login%20screen/screens/sign_in_server_screen.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';

class DashBoardProvider with ChangeNotifier {
  bool isLoading = false;
  int totalTaskCount = 0;
  int selectedScreen = 0;
  int pendingTaskCount = 0;
  int CompletedTaskCount = 0;
  int lowPriorityTaskCount = 0;
  int mediumPriorityTaskCount = 0;
  int highPriorityTaskCount = 0;
  int urgentPriorityTaskcount = 0;
  int monthTaskCount = 0;
  int weekTaskCount = 0;
  int todayTaskCount = 0;
  String greetings = "";

  String username = "";
  Uint8List? userImage;

  List<RecentTaskModel> recentTasks = [];
  /// Resets all dashboard metrics and cached user profile data.
  void clearProvider() {
    userImage = null;
    username = "";
    mediumPriorityTaskCount = 0;
    CompletedTaskCount = 0;
    pendingTaskCount = 0;
    totalTaskCount = 0;
    highPriorityTaskCount = 0;
    lowPriorityTaskCount = 0;
    monthTaskCount = 0;
    weekTaskCount = 0;
    todayTaskCount = 0;
    userImage = null;
    selectedScreen = 0;
    notifyListeners();
  }

  getUser() async {
    isLoading = true;
    notifyListeners();
    try {
      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;
      final userName = session.odooSession.userName;


      final hour = DateTime.now().hour;
      if (hour >= 0 && hour < 12) {
        greetings = "Good Morning";
      } else if (hour >= 12 && hour < 16) {
        greetings = "Good Afternoon";
      } else {
        greetings = "Good Evening";
      }
      username = userName;
      final response = await OdooSessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', '=', userId],
          ],
          'fields': ['name', 'image_1920'],
          'limit': 1,
        },
      });
      if (response != null && response.isNotEmpty) {
        final userData = response[0];
        final imgString = userData['image_1920'];

        if (imgString != null && imgString != false) {
          final cleanedString = imgString.contains(',')
              ? imgString.split(',').last
              : imgString;

          userImage = base64Decode(cleanedString);
        } else {
          userImage = null;
        }
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;

    }
  }

  void screens(int newIndex) {
    selectedScreen = newIndex;
    notifyListeners();
  }

  int getOdooMajorVersion(String serverVersion) {
    final match = RegExp(r'^(\d+)').firstMatch(serverVersion);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  ///////////////////////////////////////  TASK COUNT SECTION /////////////////////////////////
  /// Fetches counts for various task categories (e.g., My Tasks, High Priority) from Odoo.
  Future<void> fetchAllTaskCount(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    try {

      final session = await OdooSessionManager.getCurrentSession();
      if (session == null) {
        return;
      }
      final userId = session!.userId;

      final response = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_count',
        'args': [
          [
            [
              'user_ids',
              'in',
              [userId],
            ],
            ['project_id', '=', false],
            ['parent_id', '=', false],
            ['display_in_project', '=', true],
          ],
        ],
        'kwargs': {},
      });
      totalTaskCount = response;

      isLoading = false;
      notifyListeners();
    } on OdooException catch (e) {

      isLoading = false;
      notifyListeners();
      // Navigator.pushAndRemoveUntil(
      //   context,

      // CustomSnackbar.showError(
      //   context,
      //   "To-do module is not installed ,please logIn to valid database",
    }
  }

  fetchAllPendingTaskCount() async {
    isLoading = true;
    notifyListeners();

    try {
      final session = await OdooSessionManager.getCurrentSession();
      final client = await OdooSessionManager.getClient();

      final userId = session!.userId;
      final serverVersion = client!.sessionId!.serverVersion;

      final List domain = [
        [
          'user_ids',
          'in',
          [userId],
        ],
        ['project_id', '=', false],
        ['parent_id', '=', false],
        ['display_in_project', '=', true],
      ];

      if (serverVersion == "17") {
        domain.add([
          'state',
          'not in',
          ['1_done', '1_canceled'],
        ]);
      } else {
        domain.add(['is_closed', '!=', true]);
      }

      final pendingCount = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_count',
        'args': [domain],
        'kwargs': {},
      });

      pendingTaskCount = pendingCount;
      isLoading = false;
      notifyListeners();

    } catch (e) {
      isLoading = false;
      notifyListeners();

    }
  }

  //       'model': 'project.task',
  //       'method': 'search_count',
  //       'args': [
  //         [
  //           [
  //             'user_ids',
  //             'in',
  //             [userId],
  //           ],
  //           ["is_closed", "!=", true],
  //           ['project_id', '=', false],
  //           ['parent_id', '=', false],
  //           ['display_in_project', '=', true],
  //         ],
  //       ],
  //       'kwargs': {},




  fetchCompletedTaskCount() async {
    isLoading = true;
    notifyListeners();

    try {
      final session = await OdooSessionManager.getCurrentSession();
      final client = await OdooSessionManager.getClient();

      final userId = session!.userId;
      final serverVersion = client!.sessionId!.serverVersion;

      final List domain = [
        [
          'user_ids',
          'in',
          [userId],
        ],
        ['project_id', '=', false],
        ['parent_id', '=', false],
        ['display_in_project', '=', true],
      ];

      if (serverVersion == "17") {
        domain.add([
          'state',
          'in',
          ['1_done', '1_canceled'],
        ]);
      } else {
        domain.add(['is_closed', '=', true]);
      }
      final completedCount = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_count',
        'args': [domain],
        'kwargs': {},
      });
      CompletedTaskCount = completedCount;
      isLoading = false;
      notifyListeners();

    } catch (e) {
      isLoading = false;
      notifyListeners();

    }
  }


  //       'model': 'project.task',
  //       'method': 'search_count',
  //       'args': [
  //         [
  //           [
  //             'user_ids',
  //             'in',
  //             [userId],
  //           ],

  //           ['project_id', '=', false],
  //           ['parent_id', '=', false],
  //           ['display_in_project', '=', true],
  //           ["is_closed", "=", true],
  //         ],
  //       ],
  //       'kwargs': {},




  fetchLowpriorityTaskCount() async {
    isLoading = true;
    notifyListeners();
    try {
      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;


      final lowPriorityCount = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_count',
        'args': [
          [
            [
              'user_ids',
              'in',
              [userId],
            ],
            ['project_id', '=', false],
            ['parent_id', '=', false],
            ['display_in_project', '=', true],
            ['priority', '=', '0'],
          ],
        ],
        'kwargs': {},
      });
      lowPriorityTaskCount = lowPriorityCount;

      isLoading = false;
      notifyListeners();
    } catch (e) {}
  }

  fetchmediumPriorityTaskCount() async {
    isLoading = true;
    notifyListeners();
    try {

      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;

      final mediumPriorityCount = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_count',
        'args': [
          [
            [
              'user_ids',
              'in',
              [userId],
            ],
            ['project_id', '=', false],
            ['parent_id', '=', false],
            ['display_in_project', '=', true],
            ['priority', '=', '1'],
          ],
        ],
        'kwargs': {},
      });
      mediumPriorityTaskCount = mediumPriorityCount;

      isLoading = false;

      notifyListeners();
    } catch (e) {

    }
  }
 

  fetchHighPriorityCount() async {
    isLoading = true;
    notifyListeners();
    try {
     
      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;

      final highPriorityCount = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_count',
        'args': [
          [
            [
              'user_ids',
              'in',
              [userId],
            ],
            ['project_id', '=', false],
            ['parent_id', '=', false],
            ['display_in_project', '=', true],
            ['priority', '=', '2'],
          ],
        ],
        'kwargs': {},
      });
      highPriorityTaskCount = highPriorityCount;

      isLoading = false;
      notifyListeners();
    } catch (e) {

    }
  }


    
  ////////////////////////////////    TASK OVER VIEW SECTION /////////////////////////

  fetchThisMonthTaskCount() async {
    isLoading = true;
    notifyListeners();
    try {
      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;

      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final monthCount = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_count',
        'args': [
          [
            [
              'user_ids',
              'in',
              [userId],
            ],
            ['project_id', '=', false],
            ['parent_id', '=', false],
            ['display_in_project', '=', true],
            ['create_date', '>=', startOfMonth.toIso8601String()],
            ['create_date', '<=', endOfMonth.toIso8601String()],
          ],
        ],
        'kwargs': {},
      });

      monthTaskCount = monthCount;

      isLoading = false;
      notifyListeners();
    } catch (e) {

    }
  }

  String odooDateTime(DateTime dt) {
    final utc = dt.toUtc();
    return "${utc.year.toString().padLeft(4, '0')}-"
        "${utc.month.toString().padLeft(2, '0')}-"
        "${utc.day.toString().padLeft(2, '0')} "
        "${utc.hour.toString().padLeft(2, '0')}:"
        "${utc.minute.toString().padLeft(2, '0')}:"
        "${utc.second.toString().padLeft(2, '0')}";
  }

  fetchThisWeekTaskCount() async {
    isLoading = true;
    notifyListeners();
    try {

      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;
      final now = DateTime.now();
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 7));
      final weekCount = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_count',
        'args': [
          [
            [
              'user_ids',
              'in',
              [userId],
            ],
            ['project_id', '=', false],
            ['parent_id', '=', false],
            ['display_in_project', '=', true],
            ['create_date', '>=', odooDateTime(startOfWeek)],
            ['create_date', '<', odooDateTime(endOfWeek)],
          ],
        ],
        'kwargs': {},
      });
      weekTaskCount = weekCount;

      isLoading = false;
      notifyListeners();
    } catch (e) {

    }
  }

  fetchTodayTaskCount() async {
    isLoading = true;
    notifyListeners();

    try {

      final session = await OdooSessionManager.getCurrentSession();
      final userId = session!.userId;
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final todayCount = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'search_count',
        'args': [
          [
            [
              'user_ids',
              'in',
              [userId],
            ],
            ['project_id', '=', false],
            ['parent_id', '=', false],
            ['display_in_project', '=', true],
            ['create_date', '>=', startOfDay.toIso8601String()],
            ['create_date', '<', endOfDay.toIso8601String()],
          ],
        ],
        'kwargs': {},
      });

      todayTaskCount = todayCount;

      isLoading = false;
      notifyListeners();
    } catch (e) {

    }
  }
}
