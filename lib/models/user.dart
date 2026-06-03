class UserModel {
  const UserModel({
    required this.id,
    required this.uname,
    required this.phone,
    required this.email,
  });

  final String id;
  final String uname;
  final String phone;
  final String email;

  Map<String, dynamic> toMap() => {
    'id': id,
    'uname': uname,
    'phone': phone,
    'email': email,
  };

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    uname: json['uname'] ?? '',
    phone: json['phone']?.toString() ?? '',
    email: json['email'] ?? '',
  );
}
