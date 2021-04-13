
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aqi/mvp/base_page_presenter.dart';
import 'package:flutter_aqi/net/net.dart';
import 'package:flutter_aqi/statistics/iview/aqi_city_iview.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';
import 'package:flutter_aqi/widgets/state_layout.dart';
import 'package:sprintf/sprintf.dart';


class AqiCityPresenter extends BasePagePresenter<AqiCityIMvpView> {

  String city;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String location = SpUtil.getString("location");
      if(location != null){
        /// get请求参数queryParameters  post请求参数params
        asyncRequestNetwork<AqiEntity>(Method.get,
          url: sprintf(HttpApi.aqi_city_location,['2',location]),
          onSuccess: (data) {
            if (data != null) {
              view.setAqiEntity(data);
            } else {
              /// 加载失败
              // view.provider.setHasMore(false);
              // view.provider.setStateType(StateType.network);
            }
          },
        );
      }else{
        /// get请求参数queryParameters  post请求参数params
        asyncRequestNetwork<AqiEntity>(Method.get,
          url: sprintf(HttpApi.aqicity,['1451','2']),
          onSuccess: (data) {
            if (data != null) {
              view.setAqiEntity(data);
            } else {
              /// 加载失败
              // view.provider.setHasMore(false);
              // view.provider.setStateType(StateType.network);
            }
          },
        );
      }
    });
  }

  void changeCity(String cityId){
    asyncRequestNetwork<AqiEntity>(Method.get,
      url: sprintf(HttpApi.aqicity,[cityId,'2']),
      onSuccess: (data) {
        if (data != null) {
          view.setAqiEntity(data);
        } else {
          /// 加载失败
          // view.provider.setHasMore(false);
          // view.provider.setStateType(StateType.network);
        }
      },
    );
  }
 
}