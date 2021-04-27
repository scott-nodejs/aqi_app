import 'package:flutter_aqi/city/models/city_helper.dart';
import 'package:flutter_aqi/city/models/raiders_entity.dart';
import 'package:flutter_aqi/city/models/trade_entity.dart';
import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';

class CityqDetailEntity with JsonConvert{
  CityqWapper<TradeEntity> trades;
  CityqWapper<RaidersEntity> raiders;
}

class CityqWapper<T> with JsonConvert{
  int maxpage;
  List<T> cityQWapper;

  cityqMapperfromJson(CityqWapper<T> data, Map<String, dynamic> json){
    data.maxpage = json['maxPage']?.toInt();
    switch(T){
      case TradeEntity:
        if (json['cityMapper'] != null) {
          data.cityQWapper = new List<T>();
          (json['cityMapper'] as List).forEach((v) {
            TradeEntity entity = new TradeEntity().fromJson(v);
            data.cityQWapper.add(entity as T);
          });
        }
        return data;
      case RaidersEntity:
        if (json['cityMapper'] != null) {
          data.cityQWapper = new List<T>();
          (json['cityMapper'] as List).forEach((v) {
            RaidersEntity entity = new RaidersEntity().fromJson(v);
            data.cityQWapper.add(entity as T);
          });
        }
        return data;
    }
  }
}