
import 'package:flutter_aqi/mvp/mvps.dart';
import 'package:flutter_aqi/provider/base_list_provider.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';
import 'package:flutter_aqi/statistics/provider/aqi_provider.dart';

abstract class AqiCityIMvpView implements IMvpView {

  void setAqiEntity(AqiEntity entity);
}

