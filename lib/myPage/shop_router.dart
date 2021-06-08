
import 'package:fluro/fluro.dart';
import 'package:flutter_aqi/myPage/page/MyPage.dart';
import 'package:flutter_aqi/routers/i_router.dart';

import 'page/myPage.dart';

class ShopRouter implements IRouterProvider{

  static String shopPage = '/shop';
  
  @override
  void initRouter(FluroRouter router) {
    // router.define(shopPage, handler: Handler(handlerFunc: (_, __) => MyPage()));
  }
  
}