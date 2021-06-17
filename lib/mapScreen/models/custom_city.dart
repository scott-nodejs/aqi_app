import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';

class CustomCitys extends JsonConvert<CustomCitys>{
  int code;
  List<Map<String,dynamic>> data;
}

class CustomCity extends JsonConvert<CustomCity>{
  String name;
  double lat;
  double lon;
}