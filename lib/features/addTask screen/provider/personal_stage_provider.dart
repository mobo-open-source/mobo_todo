import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobo_todo/core/services/odoo_session_manager.dart';

import 'package:mobo_todo/core/widget/snackbar.dart';
import 'package:mobo_todo/features/addTask%20screen/model/personal_stages_model.dart';

class PersonalStageProvider with ChangeNotifier {
  List<PersonalStage> personalStages = [];

  int? personalstageId;

  Future<void> PersonalStages() async {
    final session = await OdooSessionManager.getCurrentSession();
    final userId = session!.userId;
    final result = await OdooSessionManager.callKwWithCompany({
      'model': 'project.task.type',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'domain': [
          ['user_id', '=', userId],
        ],
        'fields': ['id', 'name', 'sequence'],
        'order': 'sequence asc',
      },
    });
    personalStages.clear();
    final stages = result as List;
    personalStages.addAll(stages.map((e) => PersonalStage.fromMap(e)));
    notifyListeners();
  }

  void initstage(int? stage) {
    personalstageId = stage;

    notifyListeners();
  }

  Future<void> updatePersonalStage({
    required BuildContext context,
    required int taskId,
    required int personalStageId,
  }) async {
    try {
      final response = await OdooSessionManager.callKwWithCompany({
        'model': 'project.task',
        'method': 'write',
        'args': [
          [taskId],
          {'personal_stage_type_id': personalStageId},
        ],
        'kwargs': {},
      });
      personalstageId = personalStageId;
      await PersonalStages();
      initstage(personalStageId);

      //   backgroundColor: Colors.green,
      // Navigator.pushAndRemoveUntil(
      //   context,
      CustomSnackbar.showSuccess(
        context,
        "Personal stage successfully updated",
      );

      notifyListeners();
    } catch (e) {}
  }
}
