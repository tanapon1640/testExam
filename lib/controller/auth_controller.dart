import '../model/user_model.dart';

class AuthController {
  UserModel? _currentUser;

  bool login(String username, String password) {
    final user = UserModel(username: username, password: password);
    bool isAuthenticated = user.authenticate();

    if (isAuthenticated) {
      _currentUser = user;
    }

    return isAuthenticated;
  }

  UserModel? getCurrentUser() {
    return _currentUser;
  }

  String getUserEmail() {
    return _currentUser?.email ?? '';
  }
}
