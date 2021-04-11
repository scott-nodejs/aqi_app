
import 'package:flutter_aqi/mvp/mvps.dart';
import 'package:flutter_aqi/shop/models/rank_entity.dart';

abstract class ShopIMvpView implements IMvpView {

  void setRank(RankEntity user);
  
  bool get isAccessibilityTest;
}
