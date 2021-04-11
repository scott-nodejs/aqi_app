import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';
import 'package:flutter_aqi/generated/json/base/json_filed.dart';

class RankEntity with JsonConvert<RankEntity> {
	List<City> citys;
	List<RankItem> ranks;
}

class City with JsonConvert<City>{
	int uid;
	String city;
}

class RankItem with JsonConvert<RankItem>{
  String name;
  int c;
}
