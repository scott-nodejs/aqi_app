import 'package:flutter/cupertino.dart';
import 'package:flutter_aqi/common/common.dart';
import 'package:flutter_aqi/mapScreen/iview/map_iview.dart';
import 'package:flutter_aqi/mapScreen/models/map_model.dart';
import 'package:flutter_aqi/mvp/base_page_presenter.dart';
import 'package:flutter_aqi/net/dio_utils.dart';
import 'package:flutter_aqi/net/http_api.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sprintf/sprintf.dart';


class MapPresenter extends BasePagePresenter<MapIMvpView>{

  @override
  void initState() {
    String phone = SpUtil.getString(Constant.phone);
    WidgetsBinding.instance.addPostFrameCallback((_) {
          asyncRequestNetwork<MapEntity>(Method.get,
          url: sprintf(HttpApi.get_map_aqi,[phone]),
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