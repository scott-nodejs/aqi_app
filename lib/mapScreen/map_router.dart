
import 'package:fluro/fluro.dart';
import 'package:flutter_aqi/mapScreen/page/animated_map_controller.dart';
import 'package:flutter_aqi/routers/i_router.dart';
import 'page/city_multi_select_page.dart';


class MapRouter implements IRouterProvider{
  static String citySelectPage = '/map/citySelect';
  static String mapPage = '/map/screen';
  
  @override
  void initRouter(FluroRouter router) {
    router.define(citySelectPage, handler: Handler(handlerFunc: (_, __) => CityMultiSelectPage()));
    router.define(mapPage, handler: Handler(handlerFunc: (_, __) => AnimatedMapControllerPage()));
  }
  
}