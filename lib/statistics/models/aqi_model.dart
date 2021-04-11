import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';
import 'package:flutter_aqi/generated/json/base/json_filed.dart';

class AqiEntity with JsonConvert<AqiEntity>{
  @JSONField(name: 'envEntity')
  EvnEntity envEntity;
  List<AqiItem> data;
  List<AqiHourItem> react;
}

class AqiItem with JsonConvert<AqiItem>{
  int date;
  int aqi;
}

class AqiHourItem with JsonConvert<AqiHourItem>{
  String hour;
  int aqi;
}

class EvnEntity with JsonConvert<EvnEntity>{
  String aqi;
  String pm10;
  String so2;
  String co;
  String o3;
}