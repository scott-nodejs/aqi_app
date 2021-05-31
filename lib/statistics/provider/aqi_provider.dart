import 'package:flutter/material.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';

class AqiProvider extends ChangeNotifier {
     AqiEntity _entity;
     AqiEntity get entity => _entity;
     String _code;
     String get code => _code;

     void setAqiEntity(AqiEntity entity){
        _entity = entity;
        notifyListeners();
     }

     void setCode(String code){
       _code = code;
       notifyListeners();
     }
}