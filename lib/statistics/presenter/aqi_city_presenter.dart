
import 'package:flutter/material.dart';
import 'package:flutter_aqi/mvp/base_page_presenter.dart';
import 'package:flutter_aqi/net/net.dart';
import 'package:flutter_aqi/statistics/iview/aqi_city_iview.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';
import 'package:flutter_aqi/widgets/state_layout.dart';


class AqiCityPresenter extends BasePagePresenter<AqiCityIMvpView> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// get请求参数queryParameters  post请求参数params
      asyncRequestNetwork<AqiEntity>(Method.get,
        url: HttpApi.aqicity,
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
    });
  }
 
}