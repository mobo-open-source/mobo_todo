class PersonalStage {
  final int id;
  final String name;
  final int sequence;

  PersonalStage({
    required this.id,
    required this.name,
    required this.sequence,
  });

  factory PersonalStage.fromMap(Map<String, dynamic> map) {
    return PersonalStage(
      id: map['id'],
      name: map['name'],
      sequence: map['sequence'] ?? 0,
    );
  }
}