import 'package:flutter/cupertino.dart';
import 'package:flutter_aqi/mapScreen/iview/map_iview.dart';
import 'package:flutter_aqi/mapScreen/models/map_model.dart';
import 'package:flutter_aqi/mvp/base_page_presenter.dart';
import 'package:flutter_aqi/net/dio_utils.dart';
import 'package:flutter_aqi/net/http_api.dart';


class MapPresenter extends BasePagePresenter<MapIMvpView>{

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
          asyncRequestNetwork<MapEntity>(Method.get,
          url: HttpApi.get_map_aqi,
          onSuccess: (data)
          {
            if (data != null) {
              view.setMapEntity(data);
            } else {
              /// 加载失败
              // view.provider.setHasMore(false);
              // view.provider.setStateType(StateType.network);
            }
          });
    });
  }
}