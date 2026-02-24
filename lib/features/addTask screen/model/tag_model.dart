class TaskTag {
  final int id;
  final String name;
  final int color;

  TaskTag({
    required this.id,
    required this.name,
    required this.color,
  });

  factory TaskTag.fromJson(Map<String, dynamic> json) {
    return TaskTag(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      color: json['color'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}
