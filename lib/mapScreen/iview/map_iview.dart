
import 'package:flutter_aqi/mapScreen/models/map_model.dart';
import 'package:flutter_aqi/mvp/mvps.dart';
import 'package:flutter_aqi/provider/base_list_provider.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';
import 'package:flutter_aqi/statistics/provider/aqi_provider.dart';

abstract class MapIMvpView implements IMvpView {

  void setMapEntity(MapEntity entity);
}

