
import 'package:fluro/fluro.dart';
import 'package:flutter_aqi/routers/i_router.dart';
import 'page/goods_statistics_page.dart';
import 'page/order_statistics_page.dart';
import 'page/city_select_page.dart';


class StatisticsRouter implements IRouterProvider{

  static String orderStatisticsPage = '/statistics/order';
  static String goodsStatisticsPage = '/statistics/goods';
  static String citySelectPage = '/statistics/citySelect';
  
  @override
  void initRouter(FluroRouter router) {
    router.define(orderStatisticsPage, handler: Handler(handlerFunc: (_, params) {
      final int index = int.parse(params['index']?.first);
      return OrderStatisticsPage(index);
    }));
    router.define(goodsStatisticsPage, handler: Handler(handlerFunc: (_, __) => GoodsStatisticsPage()));
    router.define(citySelectPage, handler: Handler(handlerFunc: (_, __) => CitySelectPage()));
  }
  
}