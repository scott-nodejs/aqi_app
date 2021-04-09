
import 'package:flutter/material.dart';
import 'package:flutter_aqi/account/models/city_entity.dart';
import 'package:flutter_aqi/mvp/base_page_presenter.dart';
import 'package:flutter_aqi/net/net.dart';
import 'package:flutter_aqi/shop/models/user_entity.dart';
import 'package:flutter_aqi/shop/iview/shop_iview.dart';
import 'package:flutter_aqi/utils/log_utils.dart';


class ShopPagePresenter extends BasePagePresenter<ShopIMvpView> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (view.isAccessibilityTest) {
        return;
      }
      
      /// 接口请求例子
      /// get请求参数queryParameters  post请求参数params
      asyncRequestNetwork<UserEntity>(Method.get,
        url: HttpApi.users,
        onSuccess: (data) {
          view.setUser(data);
        },
      );
    });
  }
 
  void testListData() {
    /// 测试返回List类型数据解析
    asyncRequestNetwork<List<CityEntity>>(Method.get,
      url: HttpApi.subscriptions,
      onSuccess: (data) {
        data.forEach((element) {
          Log.d(element.name);
        });
      },
    );
  }
}