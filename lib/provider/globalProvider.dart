import 'package:flutter/material.dart';

//with ChangeNotifier 混入ChangeNotifier的意思是不做权限管理，每个类都可以拿到
class HomeProvider with ChangeNotifier {
  Map socketInfo = {};

  setSocketInfo(Map val) {
    socketInfo = val;
    notifyListeners(); //广播通知
  }
}
