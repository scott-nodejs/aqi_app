import 'package:flutter_aqi/statistics/models/aqi_model.dart';

aqiEntityFromJson(AqiEntity data, Map<String, dynamic> json) {
  if (json['envEntity'] != null) {
    data.envEntity = new EvnEntity().fromJson(json['envEntity']);
  }
  if (json['data'] != null) {
    data.data = new List<AqiItem>();
    (json['data'] as List).forEach((v) {
      data.data.add(new AqiItem().fromJson(v));
    });
  }
  if (json['react'] != null) {
    data.react = new List<AqiHourItem>();
    (json['react'] as List).forEach((v) {
      data.react.add(new AqiHourItem().fromJson(v));
    });
  }
  return data;
}

envEntityFromJson(EvnEntity entity, Map<String, dynamic> json){
  entity.aqi = json['aqi']?.toString();
  entity.pm10 = json['pm10']?.toString();
  entity.so2 = json['so2']?.toString();
  entity.co = json['co']?.toString();
  entity.o3 = json['o3']?.toString();
  return entity;
}

aqiItemFromJson(AqiItem data, Map<String, dynamic> json){
    data.date = json['date']?.toInt();
    data.aqi = json['aqi']?.toInt();
    return data;
}

aqiHourItemFromJson(AqiHourItem data, Map<String, dynamic> json){
  data.hour = json['hour']?.toString();
  data.aqi = json['aqi']?.toInt();
  return data;
}