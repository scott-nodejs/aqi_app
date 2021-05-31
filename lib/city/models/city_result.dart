import 'package:flutter_aqi/city/models/city_item_entity.dart';
import 'package:flutter_aqi/city/models/goods_item_entity.dart';
import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';

class CityResult with JsonConvert<CityResult>{

  CityResult({this.citys});

  List<CityItemEntity> citys;
}