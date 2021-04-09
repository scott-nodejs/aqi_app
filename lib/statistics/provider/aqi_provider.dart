import 'package:flutter/material.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';

class AqiProvider extends ChangeNotifier {
     AqiEntity _entity;
     AqiEntity get entity => _entity;

     void setAqiEntity(AqiEntity entity){
        _entity = entity;
        notifyListeners();
     }
}