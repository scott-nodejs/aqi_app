import 'package:fluro/fluro.dart';
import 'package:flutter_aqi/routers/i_router.dart';
import 'package:flutter_aqi/city/page/city_detail_page.dart';

class CityRouter implements IRouterProvider{

  static String cityDetailPage = '/city/detail';
  static String goodsStatisticsPage = '/statistics/goods';
  static String citySelectPage = '/statistics/citySelect';

  @override
  void initRouter(FluroRouter router) {
    // router.define(orderStatisticsPage, handler: Handler(handlerFunc: (_, params) {
    //   final int index = int.parse(params['index']?.first);
    //   return OrderStatisticsPage(index);
    // }));
    router.define(cityDetailPage, handler: Handler(handlerFunc: (_, params){
      final int uid = int.parse(params['uid']?.first);
      return OrderPage(uid: uid);
    }));
    // router.define(citySelectPage, handler: Handler(handlerFunc: (_, __) => CitySelectPage()));
  }

}