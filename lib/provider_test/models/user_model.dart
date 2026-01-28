import 'package:flutter/foundation.dart';

/// 用户信息模型 - 展示只读状态
class UserModel extends ChangeNotifier {
  String _name = 'Guest';
  int _level = 1;

  String get name => _name;
  int get level => _level;

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void levelUp() {
    _level++;
    notifyListeners();
  }
}
