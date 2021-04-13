import 'package:flutter_aqi/shop/models/rank_entity.dart';

rankEntityFromJson(RankEntity data, Map<String, dynamic> json) {
	data.type = json['type']?.toInt();
	if (json['citys'] != null) {
		data.citys = new List<City>();
		(json['citys'] as List).forEach((v) {
			data.citys.add(new City().fromJson(v));
		});
	}

	if (json['ranks'] != null) {
		data.ranks = new List<RankItem>();
		(json['ranks'] as List).forEach((v) {
			data.ranks.add(new RankItem().fromJson(v));
		});
	}
	return data;
}

cityFromJson(City data, Map<String, dynamic> json){
	data.city = json['city']?.toString();
	data.uid = json['uid']?.toInt();
	data.province = json['province']?.toString();
	data.feature = json['feature']?.toString();
	return data;
}

rankItemFromJson(RankItem item, Map<String, dynamic> json){
	item.name = json['name']?.toString();
	item.c = json["score"]?.toInt();
	return item;
}

Map<String, dynamic> rankEntityToJson(RankEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['citys'] = entity.citys;
	data['ranks'] = entity.ranks;
	return data;
}