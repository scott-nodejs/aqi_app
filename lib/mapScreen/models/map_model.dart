import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';
import 'package:flutter_aqi/generated/json/base/json_filed.dart';

class MapEntity with JsonConvert<MapEntity>{
  List<MapItem> items;
}

class MapItem with JsonConvert<MapItem>{
  List<double> g;
  String a;
  String x;
  int color;
  String updatetime;
  String name;
}