import 'package:flutter_aqi/city/models/city_item_entity.dart';
import 'package:flutter_aqi/city/models/city_result.dart';
import 'package:flutter_aqi/city/models/cityq_detail_entity.dart';
import 'package:flutter_aqi/city/models/raiders_entity.dart';
import 'package:flutter_aqi/city/models/trade_entity.dart';
import 'package:flutter_aqi/login/entity/LoginData.dart';
import 'package:flutter_aqi/shop/models/rank_entity.dart';

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

cityqDetailentityfromJson(CityqDetailEntity data, Map<String, dynamic> json){
  if (json['trades'] != null) {
    data.trades = new CityqWapper<TradeEntity>();
    new CityqWapper<TradeEntity>().cityqMapperfromJson(data.trades, json['trades']);
  }
  if (json['raiders'] != null) {
    data.raiders = new CityqWapper<RaidersEntity>();
    new CityqWapper<RaidersEntity>().cityqMapperfromJson(data.raiders, json['raiders']);
  }
  return data;
}

tradeEntityfromJson(TradeEntity data, Map<String, dynamic> json){
  data.id = json['id']?.toInt();
  data.uid = json['uid']?.toInt();
  data.tradeThumb = json['tradeThumb']?.toString();
  data.tradeName = json['tradeName']?.toString();
  data.tradeDesc = json['tradeDesc']?.toString();
  data.tradeUrl = json['tradeUrl']?.toString();
  data.tradeRank = json['tradeRank']?.toString();
  data.tradeCommentCount = json['tradeCommentCount']?.toString();
  return data;
}

raidersEntityFormJson(RaidersEntity data, Map<String, dynamic> json){
  data.id = json['id']?.toInt();
  data.uid = json['uid']?.toInt();
  data.title = json['title']?.toString();
  data.description = json['description']?.toString();
  data.readCount = json['readCount']?.toInt();
  data.cityName = json['cityName']?.toString();
  data.jumbUrl = json['jumbUrl']?.toString();
  data.thumb = json['thumb']?.toString();
  return data;
}

loginDataFormJson(LoginData data, Map<String, dynamic> json){
  data.login = json['login'];
  data.data = json['data']?.toString();
  data.msg = json['msg']?.toString();
  data.code = json['code']?.toInt();
  return data;
}