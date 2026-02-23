class ActivityTypeModel {
  final int id;
  final String name;
  final String? icon;

  ActivityTypeModel({
    required this.id,
    required this.name,
    this.icon,
  });

  factory ActivityTypeModel.fromMap(Map<String, dynamic> map) {
    return ActivityTypeModel(
      id: map['id'] ?? 0,
      name: map['name']?.toString() ?? 'No types Available',
      icon: map['icon'] != false ? map['icon']?.toString() : null,
    );
  }
  static List<ActivityTypeModel> fromList(List<dynamic> list) {
    return list
        .map((item) =>
            ActivityTypeModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
