
import 'package:amap_location/amap_location.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aqi/mvp/base_page_presenter.dart';
import 'package:flutter_aqi/net/net.dart';
import 'package:flutter_aqi/statistics/iview/aqi_city_iview.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';
import 'package:flutter_aqi/utils/toast.dart';
import 'package:flutter_aqi/widgets/state_layout.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';


class AqiCityPresenter extends BasePagePresenter<AqiCityIMvpView> {

  String city;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String location = SpUtil.getString("location");
      if(location.isEmpty){
        checkPersmission();
      }else{
        getCityByLocation(location);
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

  void getCityByLocation(String location){
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
  }

  //检测权限状态
  void checkPersmission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
    // 申请结果
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {
      getLocation();
    } else {
      Toast.show('定位权限申请被拒绝');
      bool isOpened = await PermissionHandler().openAppSettings();//打开应用设置
    }

  }

  getLocation()async{
    AMapLocation d = await AMapLocationClient.getLocation(true);
    var lat = d.latitude;
    var lng = d.longitude;
    print(lng.toString()+','+lat.toString());
    if(lat!=null&&lng!=null){
      String location = lng.toString()+','+lat.toString();
      getCityByLocation(location);
      SpUtil.putString("location", lng.toString()+','+lat.toString());
      SpUtil.putDouble("lat", lat);
      SpUtil.putDouble("lng", lng);
    }else{
      Toast.show('获取位置失败，请检测GPS是否开启！');
    }
  }
 
}
