import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';
import 'package:flutter_aqi/generated/json/base/json_filed.dart';

class RankEntity with JsonConvert<RankEntity> {
	int type;
	List<City> citys;
	List<RankItem> ranks;
}

class City with JsonConvert<City>{
	int uid;
	String city;
	double lat;
	double lon;
	String province;
	String feature;
}

class RankItem with JsonConvert<RankItem>{
  String name;
  int c;
}
