import 'package:flutter/cupertino.dart';
import 'package:organiser_app/src/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  User user;
  bool isLoggedIn = false;

  void setUserData({
    int id,
    String userName,
    String token,
  }) {
    this.user = User(
      id: id,
      userName: userName,
      token: token,
    );
    notifyListeners();
  }
}
