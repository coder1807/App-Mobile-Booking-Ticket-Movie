import 'package:flutter/foundation.dart';
import 'package:movie_app/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners(); // Thông báo cho các widget đang lắng nghe
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  updateUserInfo(Map<String, Object> updatedUser) {}
}
