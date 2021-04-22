import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';

class CityItemEntity with JsonConvert<CityItemEntity>{
  int id;
  int uid;
  String city;
  double lat;
  double lon;
  String url;
  String province;
  String feature;
  String cityThumb;
  //CityItemEntity(this.id,this.uid,this.city,this.lat,this.lon,this.url,this.province,this.feature);
}