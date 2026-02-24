import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobo_todo/core/services/odoo_session_manager.dart';
import 'package:mobo_todo/features/addTask%20screen/model/tag_model.dart';
import 'package:mobo_todo/features/addTask%20screen/model/user_model.dart';

class TaskDetailsProvider with ChangeNotifier {
  List<TaskTag> allTags = [];
  List<UserModel> allUSers = [];
  bool isUrgent = false;

  Color deadline(String deadline) {
    if (deadline == "2 days ago" ||
        deadline == "3 days ago" ||
        deadline == "1 days ago" ||
        deadline == "4 days ago" ||
        deadline == "Yesterday") {
      isUrgent = true;
      return Colors.red;
    } else if (deadline == "Today") {
      isUrgent = true;
      return Colors.yellow.shade800;
    } else {
      isUrgent = false;
      return Colors.black;
    }
  }

  String deadlineAgo(String? date) {
    if (date == null || date.isEmpty) return "";

    final deadline = DateTime.tryParse(date);
    if (deadline == null) return "";

    final now = DateTime.now();
    final diff = deadline
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    if (diff == 0) return "Today";
    if (diff == -1) return "Yesterday";
    if (diff == 1) return "Tomorrow";

    if (diff < 0) {
      return "${diff.abs()} days ago";
    } else {
      return "in $diff days";
    }
  }
  Future<void> fetchAllTags() async {
    try {
     
      final tags = await OdooSessionManager.callKwWithCompany({
        'model': 'project.tags',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['id', 'name', 'color'],
          // 'limit': 0,
        },
      });
      final List<dynamic> items = tags;
      allTags.clear();
      allTags.addAll(items.map((tag) => TaskTag.fromJson(tag)).toList());

      notifyListeners();
    } catch (e) {

      notifyListeners();
    }
  }

  Future<void> fetchAllUsers() async {
    final userResult = await OdooSessionManager.callKwWithCompany({
      'model': 'res.users',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'domain': [
          ['share', '=', false],
          ['active', '=', true],
        ],
        'fields': ['id', 'name', "image_1920"],
        // 'limit': 8,

        // 'offset': userPage * 5,
      },
    });
    final List<dynamic> users = userResult;
    allUSers.clear();
    notifyListeners();
    allUSers = users.map((user) => UserModel.fromJson(user)).toList();
  }
}
