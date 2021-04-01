
import 'package:flutter/material.dart';
import 'package:organiser_app/src/models/user_model.dart';


class UserProvider extends ChangeNotifier {
  User user;
  bool isLoggedIn = false;

  void setUserData({
    int id,
    String userName,
    String token,
    String avatar,
  }) {
    this.user = User(
      id: id,
      userName: userName,
      token: token,
      avatar: avatar,
    );
    notifyListeners();
  }

  void setAvatar(String avatar) {
    this.user.avatar = avatar;
    notifyListeners();
  }

}
