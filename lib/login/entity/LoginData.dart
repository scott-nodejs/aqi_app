import 'package:flutter_aqi/generated/json/base/json_convert_content.dart';

class LoginData with JsonConvert<LoginData> {
  String state;
  String msg;
  int code;
  String data;
  bool login;
}