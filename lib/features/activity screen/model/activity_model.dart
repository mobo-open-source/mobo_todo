class ActivityModel {
  final int id;
  final List<dynamic> activityTypeId;
  final String summary;
  final String resName;
  final String note;
  final String dateDeadline;
  final List<dynamic> userId;
  final String state;
  final String createDate;
  final String writeDate;

  ActivityModel( {
    required this.resName,
    required this.id,
    required this.activityTypeId,
    required this.summary,
    required this.note,
    required this.dateDeadline,
    required this.userId,
    required this.state,
    required this.createDate,
    required this.writeDate,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    // Helper function to handle false/null values from Odoo
    String _normalizeString(dynamic value) {
      if (value == null || value == false || value.toString() == 'false' || value.toString() == 'null') {
        return '';
      }
      return value.toString();
    }
    
    return ActivityModel(
      id: json['id'] as int? ?? 0,
      activityTypeId: json['activity_type_id'] as List<dynamic>? ?? [],
      summary: _normalizeString(json['summary']),
      resName: json[ 'res_name'] ?.toString() ?? "",
      note: _normalizeString(json['note']),
      
      dateDeadline: json['date_deadline']?.toString() ?? '',
      userId: json['user_id'] as List<dynamic>? ?? [],
      state: json['state']?.toString() ?? '',
      createDate: json['create_date']?.toString() ?? '',
      writeDate: json['write_date']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity_type_id': activityTypeId,
      'summary': summary,
      'note': note,
      'date_deadline': dateDeadline,
      'user_id': userId,
      'state': state,
      'create_date': createDate,
      'write_date': writeDate,
    };
  }
}

class ActivityType {
  final int id;
  final String name;

  ActivityType({
    required this.id,
    required this.name,
  });
  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
    );
  }

  @override
  String toString() => name;
}

class OdooActivity {
  final int id;
  final String type;
  final String user;

  final int? activityUserId;
  final String deadline;

  OdooActivity({
    required this.id,
    required this.type,
    required this.user,
    required this.activityUserId,
    required this.deadline,
  });

  factory OdooActivity.fromJson(Map<String, dynamic> json) {
    return OdooActivity(
      id: json['id'] ?? 0,
      type: json['activity_type_id']?[1] ?? 'Unknown',
      user: json['user_id']?[1] ?? 'Unassigned',
      activityUserId:
          json['activity_user_id'] == false ? null : json['user_id']?[0],
      deadline: json['date_deadline'] ?? '',
    );
  }
}

class MailActivityGroup {
  final int id;
  final String name;
  final String model;
  final String icon;
  final int totalCount;
  final int todayCount;
  final int overdueCount;
  final int plannedCount;

  MailActivityGroup({
    required this.id,
    required this.name,
    required this.model,
    required this.icon,
    required this.totalCount,
    required this.todayCount,
    required this.overdueCount,
    required this.plannedCount,
  });

  factory MailActivityGroup.fromJson(Map<String, dynamic> json) {
    return MailActivityGroup(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      model: json['model'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      totalCount: json['total_count'] as int? ?? 0,
      todayCount: json['today_count'] as int? ?? 0,
      overdueCount: json['overdue_count'] as int? ?? 0,
      plannedCount: json['planned_count'] as int? ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'icon': icon,
      'total_count': totalCount,
      'today_count': todayCount,
      'overdue_count': overdueCount,
      'planned_count': plannedCount,
    };
  }
}