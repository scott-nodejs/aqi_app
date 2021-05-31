
import 'package:flutter_aqi/mvp/mvps.dart';
import 'package:flutter_aqi/myPage//models/user_entity.dart';

abstract class MyIMvpView implements IMvpView {

  void setUser(UserEntity user);
  
  bool get isAccessibilityTest;
}
