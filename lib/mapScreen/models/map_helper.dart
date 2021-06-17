import 'package:flutter_aqi/mapScreen/models/custom_city.dart';

import 'map_model.dart';

mapEntityFromJson(MapEntity data, Map<String, dynamic> json) {
  if (json['items'] != null) {
    data.items = new List<MapItem>();
    (json['items'] as List).forEach((v) {
      data.items.add(new MapItem().fromJson(v));
    });
  }
  return data;
}

mapItemFromJson(MapItem data, Map<String, dynamic> json){
    data.a = json['a']?.toString();
    data.x = json['x']?.toString();
    data.name = json['name']?.toString();
    data.updatetime = json['updateTime']?.toString();
    data.color = json['color']?.toInt();
    if (json['g'] != null) {
      data.g = new List<double>();
      (json['g'] as List).forEach((v) {
        data.g.add(v);
      });
    }
    return data;
}

customCitysFromJson(CustomCitys data, Map<String, dynamic> json) {
  data.code = json['code']?.toInt();
  if (json['data'] != null) {
    data.data = new List<Map<String,dynamic>>();
    (json['data'] as List).forEach((v) {
      data.data.add(v);
    });
  }
  return data;
}
