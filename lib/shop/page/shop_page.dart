
import 'package:flutter/material.dart';
// import 'package:flutter_aqi/account/account_router.dart';
import 'package:flutter_aqi/mvp/base_page.dart';
import 'package:flutter_aqi/res/resources.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/setting/setting_router.dart';
import 'package:flutter_aqi/shop/models/rank_entity.dart';
import 'package:flutter_aqi/shop/iview/shop_iview.dart';
import 'package:flutter_aqi/shop/widgets/rank_sort_menu.dart';
import 'package:flutter_aqi/shop/presenter/shop_presenter.dart';
import 'package:flutter_aqi/shop/provider/rank_provider.dart';
import 'package:flutter_aqi/shop/shop_router.dart';
import 'package:flutter_aqi/utils/image_utils.dart';
import 'package:flutter_aqi/utils/theme_utils.dart';
import 'package:flutter_aqi/utils/toast.dart';
import 'package:flutter_aqi/widgets/chart_flutter/my_react.dart';
import 'package:flutter_aqi/widgets/chart_flutter/my_react_horizon.dart';
import 'package:flutter_aqi/widgets/load_image.dart';
import 'package:flutter_aqi/widgets/my_card.dart';
import 'package:flutter_aqi/widgets/popup_window.dart';
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

class _ShopPageState extends State<ShopPage> with BasePageMixin<ShopPage, ShopPagePresenter> implements ShopIMvpView {

  final List<String> _sortList = ['最优每日排行榜', '最差每日排行榜'];

  RankProvider provider = RankProvider();

  bool _type = false;

  final GlobalKey _addKey = GlobalKey();
  final GlobalKey _bodyKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();
  
  @override
  void setRank(RankEntity rank) {
    provider.setRank(rank);
  }

  @override
  bool get isAccessibilityTest => widget.isAccessibilityTest;
  
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    final Color _iconColor = ThemeUtils.getIconColor(context);
    final Widget line = Container(
      height: 0.6, 
      width: double.infinity, 
      margin: const EdgeInsets.only(left: 16.0), 
      child: Gaps.line,
    );
    return ChangeNotifierProvider<RankProvider>(
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
            child: Consumer<RankProvider>(
                builder: (_, provider, child) {
                  return Column(
                      key: _bodyKey,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Text(_type ? '已配货' : '最优每日排行榜', style: TextStyles.textBold24),
                        _buildHeader(),
                        _buildChart(),
                        const Text('城市排行', style: TextStyles.textBold18),
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 16.0),
                          shrinkWrap: true,
                          itemCount: 10,
                          itemExtent: 76.0,
                          itemBuilder: (context, index) => _buildItem(index),
                        ),
                      ],
                    );
                }),
          ),
        )
      ),
    );
  }

  @override
  ShopPagePresenter createPresenter() => ShopPagePresenter();

  Widget _buildHeader(){
    final Color _iconColor = ThemeUtils.getIconColor(context);
      return Semantics(
        container: true,
        label: '选择商品类型',
        child: GestureDetector(
          key: _buttonKey,
          /// 使用Selector避免同provider数据变化导致此处不必要的刷新
          child: Selector<RankProvider, int>(
            selector: (_, provider) => provider.sortIndex,
            /// 精准判断刷新条件（provider 4.0新属性）
  //                  shouldRebuild: (previous, next) => previous != next,
            builder: (_, sortIndex, __) {
              // 只会触发sortIndex变化的刷新
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Gaps.hGap16,
                  Text(
                    _sortList[sortIndex],
                    style: TextStyles.textBold24,
                  ),
                  Gaps.hGap8,
                  LoadAssetImage('goods/expand', width: 16.0, height: 16.0, color: _iconColor,)
                ],
              );
            },
          ),
          onTap: () => _showSortMenu(),
        ),
    );
  }

  /// design/4商品/index.html#artboard3
  void _showSortMenu() {
    // 获取点击控件的坐标
    final RenderBox button = _buttonKey.currentContext.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    // 获得控件左下方的坐标
    final Offset a =  button.localToGlobal(Offset(0.0, button.size.height + 12.0), ancestor: overlay);
    // 获得控件右下方的坐标
    final Offset b =  button.localToGlobal(button.size.bottomLeft(const Offset(0, 12.0)), ancestor: overlay);
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(a, b),
      Offset.zero & overlay.size,
    );
    final RenderBox body = _bodyKey.currentContext.findRenderObject() as RenderBox;

    showPopupWindow<void>(
      context: context,
      fullWidth: true,
      position: position,
      elevation: 0.0,
      child: GoodsSortMenu(
        data: _sortList,
        height: body.size.height - button.size.height,
        sortIndex: provider.sortIndex,
        onSelected: (index, name) {
          provider.setSortIndex(index);
          Toast.show('选择分类: $name');
          presenter.select(index);
          NavigatorUtils.goBack(context);
        },
      ),
    );
  }

  Widget _buildChart() {
    List<RankItem> items = provider.rank?.ranks;
    return AspectRatio(
      aspectRatio: 0.80,
      // 百分比布局
      child: FractionallySizedBox(
        heightFactor: 0.93,
        child: MyReactHorizon(items),
      ),
    );
  }

  Widget _buildItem(int index) {
    City city;
    List<City> citys = provider.rank?.citys;
    if(citys != null && citys.length > 0){
      city = citys[index];
    }
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
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: const Color(0xFFF7F8FA), width: 0.6),
                  image: DecorationImage(
                    image: ImageUtils.getAssetImage('order/${provider.rank?.type == 0 ? 'good':'bad'}'),
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
                    Text(city!=null?city.city:'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.font_sp12)),
                    Text(city!=null?city.province:'', style: Theme.of(context).textTheme.subtitle2),
                  ],
                ),
              ),
              // Gaps.hGap8,
              // Visibility(
              //   visible: !_type,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text('100件', style: Theme.of(context).textTheme.subtitle2),
              //       Text('未支付', style: Theme.of(context).textTheme.subtitle2),
              //     ],
              //   ),
              // ),
              Gaps.hGap16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: _type ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Visibility(visible: !_type, child: Text(city!=null?city.feature==null?city.province+city.city:city.feature:'', style: Theme.of(context).textTheme.subtitle2)),
                  Text('城市特色', style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
 
}

