class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String avatar;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatar,
  });

  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? avatar,
  }) {
    // TODO: Tạo UserModel mới, field nào null thì giữ giá trị hiện tại.
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'avatar': avatar,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
    );
  }
}
