class RecentTaskModel {
  final int id;
  final String name;
  final String? description;

  RecentTaskModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory RecentTaskModel.fromJson(Map<String, dynamic> json) {
    return RecentTaskModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
    );
  }
}
