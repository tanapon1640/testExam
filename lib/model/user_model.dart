class UserModel {
  final String username;
  final String password;
  String email;

  UserModel({required this.username, required this.password, this.email = ''}) {
    if (email.isEmpty) {
      email = username;
    }
  }

  bool authenticate() {
    return username == 'admin' && password == '12345';
  }
}
