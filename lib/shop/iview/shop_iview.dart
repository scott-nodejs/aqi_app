
import 'package:flutter_aqi/mvp/mvps.dart';
import 'package:flutter_aqi/shop/models/user_entity.dart';

abstract class ShopIMvpView implements IMvpView {

  void setUser(UserEntity user);
  
  bool get isAccessibilityTest;
}
