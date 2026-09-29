class UserModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? image;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
    );
  }
}
