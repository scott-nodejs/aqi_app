import 'package:flutter/material.dart';
import 'package:flutter_aqi/mapScreen/models/map_model.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';

class MapProvider extends ChangeNotifier {
     MapEntity _entity;
     MapEntity get entity => _entity;

     void setMapEntity(MapEntity entity){
        _entity = entity;
        notifyListeners();
     }
}