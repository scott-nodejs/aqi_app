
import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';

class TradeEntity with JsonConvert{
  int id;
  int uid;
  String tradeThumb;
  String tradeName;
  String tradeDesc;
  String tradeUrl;
  String tradeRank;
  String tradeCommentCount;
  String tradeStar;
  int createTime;
  int updateTime;
}