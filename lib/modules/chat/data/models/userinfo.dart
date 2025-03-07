class UserInfo {
  final String username;
  final String email;
  final String phone;
  final String uid;
  final String profileImage;

  UserInfo({
    required this.profileImage,
    required this.username,
    required this.email,
    required this.phone,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'profileImage': profileImage,
      'username': username,
      'email': email,
      'phone': phone,
      'uid': uid,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      uid: map['uid'],
      profileImage: map['profileImage'],
    );
  }
}
