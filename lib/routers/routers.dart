
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aqi/home/home_page.dart';
import 'package:flutter_aqi/home/webview_page.dart';
import 'package:flutter_aqi/login/login_router.dart';
import 'package:flutter_aqi/mapScreen/map_router.dart';
import 'package:flutter_aqi/setting/setting_router.dart';
import 'package:flutter_aqi/shop/shop_router.dart';
import 'package:flutter_aqi/city/city_router.dart';
import 'package:flutter_aqi/statistics/statistics_router.dart';

import 'i_router.dart';
import 'not_found_page.dart';

// ignore: avoid_classes_with_only_static_members
class Routes {

  static String home = '/home';
  static String webViewPage = '/webView';

  static final List<IRouterProvider> _listRouter = [];

  static final FluroRouter router = FluroRouter();

  static void initRoutes() {
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        debugPrint('未找到目标页');
        return NotFoundPage();
      });

    router.define(home, handler: Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) => Home()));
    
    router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
      final String title = params['title']?.first;
      final String url = params['url']?.first;
      return WebViewPage(title: title, url: url);
    }));
    
    _listRouter.clear();
    /// 各自路由由各自模块管理，统一在此添加初始化
    _listRouter.add(ShopRouter());
    _listRouter.add(LoginRouter());
    // _listRouter.add(GoodsRouter());
    // _listRouter.add(OrderRouter());
    _listRouter.add(MapRouter());
    _listRouter.add(CityRouter());
    _listRouter.add(SettingRouter());
    _listRouter.add(StatisticsRouter());
  
    /// 初始化路由
    _listRouter.forEach((routerProvider) {
      routerProvider.initRouter(router);
    });
  }
}
