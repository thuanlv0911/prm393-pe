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
    return this;
  }
}
