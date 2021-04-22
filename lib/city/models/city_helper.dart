import 'package:flutter_aqi/city/models/city_item_entity.dart';
import 'package:flutter_aqi/city/models/city_result.dart';

import 'goods_item_entity.dart';

cityResultfromJson(CityResult data , Map<String, dynamic> json) {
    if (json['citys'] != null) {
      data.citys = new List<CityItemEntity>();
      (json['citys'] as List).forEach((v) {
        CityItemEntity entity = new CityItemEntity().fromJson(v);
        data.citys.add(entity);
      });
    }
    return data;
}

cityItemEntityfromJson(CityItemEntity data, Map<String, dynamic> json){
  data.id = json['id']?.toInt();
  data.uid = json['uid']?.toInt();
  data.city = json['city']?.toString();
  data.lat = json['lat']?.toDouble();
  data.lon = json['lon']?.toDouble();
  data.url = json['url']?.toString();
  data.province = json['province']?.toString();
  data.feature = json['feature'] == null ? json['province']?.toString()+'.' + json['city']?.toString(): json['feature']?.toString();
  data.cityThumb = json['cityThumb'] == null ? 'https://img-pre.ivsky.com/img/tupian/pre/201711/24/tiananmen-003.jpg':json['cityThumb']?.toString();
  return data;
}