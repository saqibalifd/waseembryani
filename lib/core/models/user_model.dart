class UserModel {
  final String name;
  final String email;
  final String userid;
  final String profileImage;

  final String adress;
  final bool isAdmin;

  UserModel({
    required this.name,
    required this.email,
    required this.userid,
    required this.profileImage,
    required this.adress,
    this.isAdmin = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userid: json['userid'] ?? '',
      profileImage: json['profileImage']?.toString() ?? '',
      adress: json['adress']?.toString() ?? '',
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'userid': userid,
    'profileImage': profileImage,
    'adress': adress,
    'isAdmin': isAdmin,
  };
}
