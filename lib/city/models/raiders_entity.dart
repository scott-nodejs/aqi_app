import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';

class RaidersEntity with JsonConvert{
   int id;
   int uid;
   String title;
   String description;
   String thumb;
   int readCount;
   int sourceType;
   String publishTime;
   String cityName;
   String jumbUrl;
   int createTime;
   int updateTime;
}