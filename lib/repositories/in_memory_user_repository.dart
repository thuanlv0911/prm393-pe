import '../models/user.dart';
import 'user_repository.dart';

class InMemoryUserRepository implements UserRepository {
  final List<UserModel> _users = <UserModel>[
    // TODO: Có thể thêm dữ liệu mẫu để test giao diện ban đầu.
  ];

  @override
  Future<List<UserModel>> getUsers() async {
    // TODO: Trả về bản sao danh sách user trong bộ nhớ.
    return List<UserModel>.from(_users);
  }

  @override
  Future<void> addUser(UserModel user) async {
    // TODO: Thêm user vào _users.
    _users.add(user);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    // TODO: Tìm user cùng id và cập nhật thông tin.
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    // TODO: Xoá user theo id.
    _users.removeWhere((u) => u.id == id);
  }
}
