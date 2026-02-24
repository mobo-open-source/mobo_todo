class UserModel {
  final int id;
  final String name;
  final dynamic image1920;
  final String? mobile;
  final String? phone;
  final String? email;

  UserModel({
    required this.id,
    required this.name,
    this.image1920,
    this.mobile,
    this.phone,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      image1920: json['image_1920'],
      mobile: json['partner_id.mobile'],
      phone: json['partner_id.phone'],
      email: json['partner_id.email'],
    );
  }
}
