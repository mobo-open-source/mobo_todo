class TaskModel {
  final int id;
  final String name;
  final String? description;
  final String? dateDeadline;

  final List<int> activityIds;
  final List<int> tagIds;
  final List<int> userIds;
  final List<String> userNames;

  final String? priority;

  final int? personalStageId;
  final String? personalStageName;

  TaskModel({
    required this.id,
    required this.name,
    this.description,
    this.dateDeadline,
    required this.activityIds,
    required this.tagIds,
    required this.userIds,
    required this.userNames,
    this.priority,
    this.personalStageId,
    this.personalStageName,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    final personalStage = map['personal_stage_type_id'];

    return TaskModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',

      description:
          (map['description'] != null && map['description'] != false)
              ? map['description'].toString()
              : null,

      dateDeadline:
          (map['date_deadline'] != null &&
                  map['date_deadline'] != false &&
                  map['date_deadline'].toString().isNotEmpty)
              ? map['date_deadline'].toString()
              : null,

      activityIds: map['activity_ids'] != null
          ? List<int>.from(map['activity_ids'])
          : [],

      tagIds: map['tag_ids'] != null
          ? List<int>.from(map['tag_ids'])
          : [],

      userIds: map['user_ids'] != null
          ? List<int>.from(map['user_ids'])
          : [],

      userNames: map['user_names'] != null
          ? List<String>.from(map['user_names'])
          : [],

      priority:
          (map['priority'] != null && map['priority'] != false)
              ? map['priority'].toString()
              : null,

      personalStageId:
          (personalStage is List && personalStage.isNotEmpty)
              ? personalStage[0] as int
              : null,

      personalStageName:
          (personalStage is List && personalStage.length > 1)
              ? personalStage[1] as String
              : null,
    );
  }
}
