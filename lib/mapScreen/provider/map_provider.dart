import 'package:flutter/material.dart';
import 'package:flutter_aqi/account/models/city_entity.dart';
import 'package:flutter_aqi/mapScreen/models/map_model.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';

class MapProvider extends ChangeNotifier {
     MapEntity _entity;
     List<CityEntity> _citys;
     double _lat;
     double _long;
     String _name;
     String _updatetime;
     bool _pinClicked = false;
     MapEntity get entity => _entity;
     double get lat => _lat;
     double get long => _long;
     bool get pinClicked => _pinClicked;

     String get name => _name;
     String get updatetime => _updatetime;
     List<CityEntity> get citys => _citys;

     void setMapEntity(MapEntity entity){
        _entity = entity;
        notifyListeners();
     }

     void setLat(double lat){
       _lat = lat;
       notifyListeners();
     }

     void setName(String name){
       _name = name;
       notifyListeners();
     }

     void setUpdatetime(String updatetime){
       _updatetime = updatetime;
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

     void setSelectCitys(List<CityEntity> citys){
       _citys = citys;
       notifyListeners();
     }
}