import 'package:flutter/material.dart';
import 'package:flutter_aqi/mapScreen/models/map_model.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';

class MapProvider extends ChangeNotifier {
     MapEntity _entity;
     double _lat;
     double _long;
     bool _pinClicked = false;
     MapEntity get entity => _entity;
     double get lat => _lat;
     double get long => _long;
     bool get pinClicked => _pinClicked;

     void setMapEntity(MapEntity entity){
        _entity = entity;
        notifyListeners();
     }

     void setLat(double lat){
       _lat = lat;
       notifyListeners();
     }

     void setPinClicked(bool pinClicked){
       _pinClicked = pinClicked;
       notifyListeners();
     }

     void setLong(double long){
       _long = long;
       notifyListeners();
     }
}