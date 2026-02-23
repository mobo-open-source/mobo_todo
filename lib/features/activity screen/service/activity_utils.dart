import 'dart:developer';

class ActivityUtils {
  /// Extract activity information from a Kanban record
  static Map<String, dynamic> extractActivityInfo(Map<dynamic, dynamic> record) {
    try {
      // Debug logging


      // Extract activity state
      String? activityState = record['activity_state']?.toString();
      
      // Handle activity_state that might be false or null
      if (activityState == 'false' || activityState == null || activityState.isEmpty) {
        activityState = null;
      }

      // Extract activity type
      String? activityType;
      if (record['activity_type_id'] is List && 
          (record['activity_type_id'] as List).length > 1) {
        activityType = record['activity_type_id'][1]?.toString();
      }
      
      // Handle activity_type_id that might be false or null
      if (activityType == 'false' || activityType == null || activityType.isEmpty) {
        activityType = null;
      }
      
      // Extract activity user
      String? activityUser;
      if (record['activity_user_id'] is List && 
          (record['activity_user_id'] as List).length > 1) {
        activityUser = record['activity_user_id'][1]?.toString();
      }
      
      // Handle activity_user_id that might be false or null
      if (activityUser == 'false' || activityUser == null || activityUser.isEmpty) {
        activityUser = null;
      }
      
      // Extract activity deadline
      String? activityDeadline = record['activity_date_deadline']?.toString();
      
      // Handle activity_date_deadline that might be false or null
      if (activityDeadline == 'false' || activityDeadline == null || activityDeadline.isEmpty) {
        activityDeadline = null;
      }
      
      // Extract activity summary
      String? activitySummary = record['activity_summary']?.toString();
      
      // Handle activity_summary that might be false or null
      if (activitySummary == 'false' || activitySummary == null || activitySummary.isEmpty) {
        activitySummary = null;
      }
      
      final result = {
        'state': activityState,
        'type': activityType,
        'user': activityUser,
        'deadline': activityDeadline,
        'summary': activitySummary,
        'hasActivity': activityState != null || activityType != null || activityDeadline != null,
      };

      return result;
    } catch (e) {

      return {
        'state': null,
        'type': null,
        'user': null,
        'deadline': null,
        'summary': null,
        'hasActivity': false,
      };
    }
  }
  
  /// Get activity state color
  static String getActivityStateColor(String? state) {
    switch (state?.toLowerCase()) {
      case 'overdue':
        return '#F44336'; // Red
      case 'today':
        return '#FF9800'; // Orange
      case 'planned':
        return '#4CAF50'; // Green
      default:
        return '#9E9E9E'; // Grey
    }
  }
  
  /// Get activity state icon
  static String getActivityStateIcon(String? state) {
    switch (state?.toLowerCase()) {
      case 'overdue':
        return 'alarm_clock';
      case 'today':
        return 'calendar_today';
      case 'planned':
        return 'schedule';
      default:
        return 'calendar_month';
    }
  }
  
  /// Determine activity state from deadline
  static String? determineActivityState(String? deadline) {
    if (deadline == null || deadline.isEmpty || deadline == 'false') {
      return null;
    }
    
    try {
      final deadlineDate = DateTime.parse(deadline);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final deadlineDay = DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day);
      
      if (deadlineDay.isBefore(today)) {
        return 'overdue';
      } else if (deadlineDay.isAtSameMomentAs(today)) {
        return 'today';
      } else {
        return 'planned';
      }
    } catch (e) {

      return null;
    }
  }
  
  /// Format activity deadline for display
  static String formatActivityDeadline(String? deadline) {
    if (deadline == null || deadline.isEmpty || deadline == 'false') {
      return '';
    }
    
    try {
      final deadlineDate = DateTime.parse(deadline);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final deadlineDay = DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day);
      
      if (deadlineDay.isBefore(today)) {
        final difference = today.difference(deadlineDay).inDays;
        return '$difference day${difference > 1 ? 's' : ''} overdue';
      } else if (deadlineDay.isAtSameMomentAs(today)) {
        return 'Today';
      } else {
        final difference = deadlineDay.difference(today).inDays;
        if (difference == 1) {
          return 'Tomorrow';
        } else {
          return 'In $difference days';
        }
      }
    } catch (e) {

      return deadline;
    }
  }
  
  /// Check if record has any activity
  static bool hasActivity(Map<dynamic, dynamic> record) {
    final activityInfo = extractActivityInfo(record);
    return activityInfo['hasActivity'] as bool;
  }
  
  /// Get record name safely
  static String getRecordName(Map<dynamic, dynamic> record) {
    return record['name']?.toString() ?? 'Unnamed Record';
  }
  
  /// Get record ID safely
  static int getRecordId(Map<dynamic, dynamic> record) {
    return record['id'] as int? ?? 0;
  }
  
  /// Get record model from record type
  static String getRecordModel(Map<dynamic, dynamic> record) {
    final type = record['type']?.toString();
    switch (type) {
      case 'opportunity':
        return 'crm.lead';
      case 'lead':
        return 'crm.lead';
        case 'task':
        return 'project.task';
      default:
        return 'crm.lead'; // Default fallback
    }
  }
}