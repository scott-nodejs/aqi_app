import 'package:flutter/material.dart';
import 'package:flutter_aqi/mvp/base_page.dart';
import 'package:flutter_aqi/provider/base_list_provider.dart';
import 'package:flutter_aqi/res/resources.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/statistics/iview/aqi_city_iview.dart';
import 'package:flutter_aqi/statistics/models/aqi_model.dart';
import 'package:flutter_aqi/statistics/presenter/aqi_city_presenter.dart';
import 'package:flutter_aqi/statistics/provider/aqi_provider.dart';
import 'package:flutter_aqi/statistics/statistics_router.dart';
import 'package:flutter_aqi/utils/image_utils.dart';
import 'package:flutter_aqi/utils/screen_utils.dart';
import 'package:flutter_aqi/utils/theme_utils.dart';
import 'package:flutter_aqi/widgets/chart_flutter/my_bezier.dart';
import 'package:flutter_aqi/widgets/chart_flutter/my_react.dart';
import 'package:flutter_aqi/widgets/load_image.dart';
import 'package:flutter_aqi/widgets/my_card.dart';
import 'package:flutter_aqi/widgets/my_flexible_space_bar.dart';
import 'package:provider/provider.dart';


/// design/5统计/index.html
class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> with BasePageMixin<StatisticsPage, AqiCityPresenter> implements AqiCityIMvpView{

  AqiProvider provider = new AqiProvider();

  @override
  void setAqiEntity(AqiEntity entity) {
    provider.setAqiEntity(entity);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AqiProvider>(
              create: (_) => provider,
              child: Scaffold(
                body: Consumer<AqiProvider>(
                    builder: (_, provider, __) {
                      AqiEntity entity = provider.entity;
                      return CustomScrollView(
                        key: const Key('statistic_list'),
                        physics: const ClampingScrollPhysics(),
                        slivers: _sliverBuilder(entity),
                      );
                    }
                    ),
              )
    );
  }

  bool isDark = false;
  
  List<Widget> _sliverBuilder(AqiEntity entity) {
    isDark = context.isDark;
    EvnEntity evn = entity?.envEntity;
    return <Widget>[
      SliverAppBar(
        brightness: Brightness.dark,
        leading: Gaps.empty,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        expandedHeight: 100.0,
        pinned: true,
        flexibleSpace: MyFlexibleSpaceBar(
          background: isDark ? Container(height: 115.0, color: Colours.dark_bg_color,) : LoadAssetImage('statistic/statistic_bg',
            width: context.width,
            height: 115.0,
            fit: BoxFit.fill,
          ),
          centerTitle: true,
          titlePadding: const EdgeInsetsDirectional.only(start: 16.0, bottom: 14.0),
          collapseMode: CollapseMode.pin,
          title: Text('模糊笔记', style: TextStyle(color: ThemeUtils.getIconColor(context)),),
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          DecoratedBox(
            decoration: BoxDecoration(
              color: isDark ? Colours.dark_bg_color : null,
              image: isDark ? null : DecorationImage(
                image: ImageUtils.getAssetImage('statistic/statistic_bg1'),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              height: 120.0,
              child: MyCard(
                child: Row(
                  children: <Widget>[
                    _StatisticsTab('pm2.5', 'face', evn==null?'-':evn.aqi),
                    _StatisticsTab('pm10', 'face', evn==null?'-':evn.pm10),
                    _StatisticsTab('臭氧', 'face', evn==null?'-':evn.o3),
                    _StatisticsTab('一氧化碳', 'face', evn==null?'-':evn.co),
                    _StatisticsTab('二氧化硫', 'face', evn==null?'-':evn.so2),
                  ],
                ),
              ),
            ),
          )
          , 120.0,
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Gaps.vGap32,
              Text('数据走势', style: TextStyles.textBold18),
              Gaps.vGap16,
              _StatisticsItem('AQI趋势图', 'sjzs', 1, MyBezier(entity?.data)),
              Gaps.vGap8,
              _StatisticsItem('今日AQI分布图', 'jyetj', 2, MyReact()),
              // Gaps.vGap8,
              // _StatisticsItem('商品统计', 'sptj', 3),
            ],
          ),
        ),
      )
    ];
  }

  @override
  AqiCityPresenter createPresenter() {
    return AqiCityPresenter();
  }
  
}

class _StatisticsItem extends StatelessWidget {


  _StatisticsItem(this.title, this.img, this.index,this.widget, {Key key}): super(key: key);

  String title;
  String img;
  int index;
  Widget widget;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.14,
      child: GestureDetector(
        onTap: () {
          if (index == 1 || index == 2) {
            NavigatorUtils.push(context, '${StatisticsRouter.orderStatisticsPage}?index=$index');
          } else {
            NavigatorUtils.push(context, StatisticsRouter.goodsStatisticsPage);
          }
        },
        child: MyCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(title, style: TextStyles.textBold14),
                      const LoadAssetImage('statistic/icon_selected', height: 16.0, width: 16.0)
                    ],
                  ),
                ),
                // Expanded(child: LoadAssetImage('statistic/$img', fit: BoxFit.fill))
                Expanded(child: widget)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatisticsTab extends StatelessWidget {

  _StatisticsTab(this.title, this.img, this.content);

  String title;
  String img;
  String content;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MergeSemantics(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoadAssetImage('statistic/$img', width: 25.0, height: 25.0),
            Gaps.vGap4,
            Text(title, style: Theme.of(context).textTheme.subtitle2),
            Gaps.vGap8,
            Text(content, style: const TextStyle(fontSize: Dimens.font_sp18)),
          ],
        ),
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {

  SliverAppBarDelegate(this.widget, this.height);

  final Widget widget;
  final double height;

  // minHeight 和 maxHeight 的值设置为相同时，header就不会收缩了
  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return true;
  }
}