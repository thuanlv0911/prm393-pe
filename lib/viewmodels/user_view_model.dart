import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../repositories/sqlite_user_repository.dart';
import '../repositories/user_repository.dart';

class UserState {
  final List<UserModel> items;
  final bool isLoading;

  const UserState({
    this.items = const <UserModel>[],
    this.isLoading = false,
  });

  UserState copyWith({
    List<UserModel>? items,
    bool? isLoading,
  }) {
    // TODO: Trả về UserState mới, field nào null thì giữ giá trị hiện tại.
    return UserState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserViewModel extends StateNotifier<UserState> {
  UserViewModel(this.repository) : super(const UserState(isLoading: true)) {
    loadUsers();
  }

  final UserRepository repository;

  Future<void> loadUsers() async {
    // TODO: Gọi repository.getUsers(), cập nhật state.items và isLoading=false.
    state = state.copyWith(isLoading: true);
    final users = await repository.getUsers();
    state = UserState(items: users, isLoading: false);
  }

  Future<void> addUser({
    required String fullName,
    required String email,
    required String avatar,
  }) async {
    // TODO:
    // 1. Tính id mới = danh sách rỗng ? 1 : max(id hiện có) + 1.
    // 2. Tạo UserModel mới.
    // 3. Gọi repository.addUser.
    // 4. Cập nhật state để UI render lại.
    final newId = state.items.isEmpty
        ? 1
        : state.items.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;
    
    final newUser = UserModel(
      id: newId,
      fullName: fullName,
      email: email,
      avatar: avatar,
    );

    await repository.addUser(newUser);

    state = state.copyWith(
      items: <UserModel>[...state.items, newUser],
    );
  }

  Future<void> updateUser(UserModel user) async {
    // TODO: Gọi repository.updateUser và cập nhật đúng phần tử theo id trong state.
    await repository.updateUser(user);
    state = state.copyWith(
      items: state.items.map((u) => u.id == user.id ? user : u).toList(),
    );
  }

  Future<void> deleteUser(int id) async {
    // TODO: Gọi repository.deleteUser và xoá đúng phần tử theo id trong state.
    await repository.deleteUser(id);
    state = state.copyWith(
      items: state.items.where((u) => u.id != id).toList(),
    );
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return SqliteUserRepository();
});

final userViewModelProvider =
    StateNotifierProvider<UserViewModel, UserState>((ref) {
  return UserViewModel(ref.watch(userRepositoryProvider));
});
