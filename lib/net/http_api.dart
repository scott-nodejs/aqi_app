
class HttpApi{
  static const String users = 'users/simplezhli';
  static const String search = 'search/repositories';
  static const String subscriptions = 'users/simplezhli/subscriptions';
  static const String upload = 'uuc/upload-inco';
  static const String aqicity = 'getAqiByCity/%s/%s';
  static const String aqi_city_location = 'getAqiByCity/%s?location=%s';
  static const String rank = 'getRankByCity?type=%s&page=%s';
  static const String get_map_aqi = 'getMap';
  static const String city_Q_list = 'cityQ/list/%s';
  static const String trade_list = 'cityQ/trade/list/%s?page=%s';
  static const String get_one_city = 'cityQ/getCity/%s';
  static const String get_city = 'getCityByCityName/%s';
  static const String login = 'login';
  static const String sendcode = 'send/code?phone=%s';
  static const String smslogin = 'phone/login';
  static const String getCustomCity = 'get/customCity?phone=%s';
  static const String submitCustomCity = 'custom/city';
  static const String register = 'register';
}