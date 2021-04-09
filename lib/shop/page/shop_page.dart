
import 'package:flutter/material.dart';
// import 'package:flutter_aqi/account/account_router.dart';
import 'package:flutter_aqi/mvp/base_page.dart';
import 'package:flutter_aqi/res/resources.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/setting/setting_router.dart';
import 'package:flutter_aqi/shop/models/user_entity.dart';
import 'package:flutter_aqi/shop/iview/shop_iview.dart';
import 'package:flutter_aqi/shop/presenter/shop_presenter.dart';
import 'package:flutter_aqi/shop/provider/user_provider.dart';
import 'package:flutter_aqi/shop/shop_router.dart';
import 'package:flutter_aqi/utils/image_utils.dart';
import 'package:flutter_aqi/utils/theme_utils.dart';
import 'package:flutter_aqi/widgets/chart_flutter/my_react.dart';
import 'package:flutter_aqi/widgets/chart_flutter/my_react_horizon.dart';
import 'package:flutter_aqi/widgets/load_image.dart';
import 'package:flutter_aqi/widgets/my_card.dart';
import 'package:provider/provider.dart';

/// design/6店铺-账户/index.html#artboard0
class ShopPage extends StatefulWidget {

  const ShopPage({
    Key key,
    this.isAccessibilityTest = false,
  }) : super(key : key);

  final bool isAccessibilityTest;
  
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with BasePageMixin<ShopPage, ShopPagePresenter>, AutomaticKeepAliveClientMixin<ShopPage> implements ShopIMvpView {
  
  final List<String> _menuTitle = ['账户流水', '资金管理', '提现账号'];
  final List<String> _menuImage = ['zhls', 'zjgl', 'txzh'];
  final List<String> _menuDarkImage = ['dark_zhls', 'dark_zjgl', 'dark_txzh'];

  UserProvider provider = UserProvider();

  bool _type = false;
  
  @override
  void setUser(UserEntity user) {
    provider.setUser(user);
  }

  @override
  bool get isAccessibilityTest => widget.isAccessibilityTest;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Color _iconColor = ThemeUtils.getIconColor(context);
    final Widget line = Container(
      height: 0.6, 
      width: double.infinity, 
      margin: const EdgeInsets.only(left: 16.0), 
      child: Gaps.line,
    );
    return ChangeNotifierProvider<UserProvider>(
      create: (_) => provider,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              tooltip: '设置',
              onPressed: () {
                NavigatorUtils.push(context, SettingRouter.settingPage);
              },
              icon: LoadAssetImage(
                'shop/setting',
                key: const Key('setting'),
                width: 24.0,
                height: 24.0,
                color: _iconColor,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          key: const Key('goods_statistics_list'),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_type ? '已配货' : '最优每日排行榜', style: TextStyles.textBold24),
                _buildChart(),
                const Text('最优城市排行', style: TextStyles.textBold18),
                ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16.0),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemExtent: 76.0,
                  itemBuilder: (context, index) => _buildItem(index),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  ShopPagePresenter createPresenter() => ShopPagePresenter();

  Widget _buildChart() {
    return AspectRatio(
      aspectRatio: 1.30,
      // 百分比布局
      child: FractionallySizedBox(
        heightFactor: 0.8,
        child: MyReactHorizon(),
      ),
    );
  }

  Widget _buildItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: MyCard(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 16.0),
          child: Row(
            children: <Widget>[
              if (index <= 2) LoadAssetImage('statistic/${index == 0 ? 'champion' : index == 1 ? 'runnerup' : 'thirdplace'}', width: 40.0,) else Container(
                alignment: Alignment.center,
                width: 18.0,
                height: 18.0,
                margin: const EdgeInsets.symmetric(horizontal: 11.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFA9DAF2)
                ),
                child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: Dimens.font_sp12, fontWeight: FontWeight.bold)),
              ),
              Gaps.hGap4,
              Container(
                height: 36.0,
                width: 36.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: const Color(0xFFF7F8FA), width: 0.6),
                  image: DecorationImage(
                    image: ImageUtils.getAssetImage('order/icon_goods'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Gaps.hGap8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('那鲁火多饮料', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.font_sp12)),
                    Text('250ml', style: Theme.of(context).textTheme.subtitle2),
                  ],
                ),
              ),
              Gaps.hGap8,
              Visibility(
                visible: !_type,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('100件', style: Theme.of(context).textTheme.subtitle2),
                    Text('未支付', style: Theme.of(context).textTheme.subtitle2),
                  ],
                ),
              ),
              Gaps.hGap16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: _type ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('400件', style: Theme.of(context).textTheme.subtitle2),
                  Visibility(visible: !_type, child: Text('已支付', style: Theme.of(context).textTheme.subtitle2)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
 
}

