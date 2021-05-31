import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';
import 'package:flutter_aqi/generated/json/base/json_filed.dart';

class AqiEntity with JsonConvert<AqiEntity>{
  @JSONField(name: 'envEntity')
  String name;
  String loc;
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
  String desc;
  String level;
  int color;
  String aqiState;
  String pm10State;
  String coState;
  String so2State;
  String o3State;
  String source;
  int flag;
}