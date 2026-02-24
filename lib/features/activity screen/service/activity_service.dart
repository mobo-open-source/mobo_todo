import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobo_todo/core/services/odoo_session_manager.dart';
import 'package:mobo_todo/features/activity%20screen/model/activity_model.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_provider.dart';
import 'package:provider/provider.dart';

class ActivityService {
  /// Fetch activities for a specific record
  Future<List<ActivityModel>> fetchActivities({
    required int resId,
    required String resModel,
  }) async {
    try {

      final result = await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_read',
        'args': [
          [
            ['res_id', '=', resId],
            ['res_model', '=', resModel],
          ],
        ],
        'kwargs': {
          'fields': [
            'id',
            'activity_type_id',
            'summary',
            'note',
            'date_deadline',
            'user_id',
            'state',
            'create_date',
            'write_date',
            'res_name', // Add resource name for better debugging
          ],
          'order': 'date_deadline asc',
        },
      });

      // Log each activity with its type for debugging
      for (var activity in result) {
        final activityTypeInfo = activity['activity_type_id'];
        final activityTypeName =
            activityTypeInfo is List && activityTypeInfo.length > 1
            ? activityTypeInfo[1].toString()
            : 'Unknown';
        final state = activity['state'] ?? 'no_state';

      }

      final activities = (result as List)
          .map((item) => ActivityModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return activities;
    } catch (e) {

      rethrow;
    }
  }

  Future<void> scheduleActivity({
    required int resId,
    required String resModel,
    required int activityTypeId,
   
    required String summary,
    required String noteHtml,
    required int assignedUserId,
    required String dateDeadline,
  }) async {
    final client = await OdooSessionManager.getClient();

    /// CREATE wizard with context
    final wizardId = await client!.callKw({
      'model': 'mail.activity.schedule',
      'method': 'create',
      'args': [
        {
          'res_model': resModel,
          'activity_type_id': activityTypeId,
          'summary': summary,
          'note': noteHtml,
          'activity_user_id': assignedUserId,
          'date_deadline': dateDeadline,
        },
      ],
      'kwargs': {
        'context': {
          'active_model': resModel,
          'active_ids': [resId], // THIS IS THE KEY
          'active_id': resId,
        },
      },
    });

    /// CALL action
    await OdooSessionManager.callKwWithCompany({
      'model': 'mail.activity.schedule',
      'method': 'action_schedule_activities',
      'args': [
        [wizardId],
      ],
      'kwargs': {
        'context': {
          'active_model': resModel,
          'active_ids': [resId],
          'active_id': resId,
        },
      },
    });

  }

  /// Mark activity as done
  Future<void> markActivityDone(int activityId) async {
    try {
      await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'action_done',
        'args': [
          [activityId],
        ],
        'kwargs': {},
      });

    } catch (e) {

      rethrow;
    }
  }

  /// Update an existing activity
  //   required int activityId,
  //   required Map<String, dynamic> updates,
  //       'model': 'mail.activity',
  //       'method': 'write',
  //       'args': [
  //         [activityId],
  //         updates,
  //       ],
  //       'kwargs': {},


  /// Delete an activity
  Future<void> deleteActivity(int activityId) async {
    try {
      await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'unlink',
        'args': [
          [activityId],
        ],
        'kwargs': {},
      });

    } catch (e) {

      rethrow;
    }
  }

  /// Get activity types
  Future<List<Map<String, dynamic>>> getActivityTypes() async {
    try {
      final result = await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity.type',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name', 'icon', 'decoration_type', 'category'],
        },
      });

      for (var activityType in result) {

      }

      return (result as List).cast<Map<String, dynamic>>();
    } catch (e) {

      rethrow;
    }
  }

  /// Get users for assignment
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final result = await OdooSessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name', 'email'],
        },
      });

      return (result as List).cast<Map<String, dynamic>>();
    } catch (e) {

      rethrow;
    }
  }

  /// Get activity count for a record
  Future<int> getActivityCount({
    required int resId,
    required String resModel,
  }) async {
    try {
      final result = await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_count',
        'args': [
          [
            ['res_id', '=', resId],
            ['res_model', '=', resModel],
          ],
        ],
        'kwargs': {},
      });

      return result as int;
    } catch (e) {

      return 0;
    }
  }

  /// Get overdue activities count for a record
  Future<int> getOverdueActivityCount({
    required int resId,
    required String resModel,
  }) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final result = await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_count',
        'args': [
          [
            ['res_id', '=', resId],
            ['res_model', '=', resModel],
            ['date_deadline', '<', today],
          ],
        ],
        'kwargs': {},
      });

      return result as int;
    } catch (e) {

      return 0;
    }
  }

  /// Get today's activities count for a record
  Future<int> getTodayActivityCount({
    required int resId,
    required String resModel,
  }) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final result = await OdooSessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_count',
        'args': [
          [
            ['res_id', '=', resId],
            ['res_model', '=', resModel],
            ['date_deadline', '=', today],
          ],
        ],
        'kwargs': {},
      });

      return result as int;
    } catch (e) {

      return 0;
    }
  }

  /// Get activity summary for a record (counts by state)
  Future<Map<String, int>> getActivitySummary({
    required int resId,
    required String resModel,
  }) async {
    try {
      final activities = await fetchActivities(
        resId: resId,
        resModel: resModel,
      );
      final now = DateTime.now();

      int overdue = 0;
      int today = 0;
      int planned = 0;

      for (final activity in activities) {
        final deadline = DateTime.parse(activity.dateDeadline);

        if (deadline!.isBefore(now)) {
          overdue++;
        } else if (deadline.day == now.day &&
            deadline.month == now.month &&
            deadline.year == now.year) {
          today++;
        } else {
          planned++;
        }
      }

      return {
        'total': activities.length,
        'overdue': overdue,
        'today': today,
        'planned': planned,
      };
    } catch (e) {

      return {'total': 0, 'overdue': 0, 'today': 0, 'planned': 0};
    }
  }

  /// Test method to check for email activities in the system
  Future<void> testEmailActivities() async {
    try {

      // First, get all activity types and look for email-related ones
      final activityTypes = await getActivityTypes();
      final emailActivityTypes = activityTypes.where((type) {
        final name = type['name']?.toString().toLowerCase() ?? '';
        return name.contains('email') || name.contains('mail');
      }).toList();

      for (var emailType in emailActivityTypes) {

      }

      // Now search for any email activities in the system
      if (emailActivityTypes.isNotEmpty) {
        final emailTypeIds = emailActivityTypes
            .map((type) => type['id'])
            .toList();

        final result = await OdooSessionManager.callKwWithCompany({
          'model': 'mail.activity',
          'method': 'search_read',
          'args': [
            [
              ['activity_type_id', 'in', emailTypeIds],
            ],
          ],
          'kwargs': {
            'fields': [
              'id',
              'activity_type_id',
              'summary',
              'res_model',
              'res_id',
              'state',
            ],
            'limit': 10, // Just get a few examples
          },
        });

        for (var activity in result) {
          final activityTypeInfo = activity['activity_type_id'];
          final activityTypeName =
              activityTypeInfo is List && activityTypeInfo.length > 1
              ? activityTypeInfo[1].toString()
              : 'Unknown';

        }
      }
    } catch (e) {

    }
  }
}
