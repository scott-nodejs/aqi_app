import 'dart:async';

import 'package:amap_location/amap_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aqi/account/models/city_entity.dart';
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
import 'package:flutter_aqi/utils/toast.dart';
import 'package:flutter_aqi/widgets/chart_flutter/my_bezier.dart';
import 'package:flutter_aqi/widgets/chart_flutter/my_react.dart';
import 'package:flutter_aqi/widgets/load_image.dart';
import 'package:flutter_aqi/widgets/my_card.dart';
import 'package:flutter_aqi/widgets/my_flexible_space_bar.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';


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
                      return NotificationListener<ScrollNotification>(
                          child: RefreshIndicator(
                              notificationPredicate: (notifation) {
                                return true;
                              },
                              displacement: 100.0,
                              onRefresh:_handleRefresh,
                              color: Colors.blue,
                              child:CustomScrollView(
                                key: const Key('statistic_list'),
                                physics: const ClampingScrollPhysics(),
                                slivers: _sliverBuilder(entity),
                              )
                          )
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
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                presenter.checkPersmission();
              });
            },
            tooltip: '手动定位',
            icon: LoadAssetImage('statistic/location',
              width: 30.0,
              height: 30.0,
              color: ThemeUtils.getIconColor(context),
            ),
          )
        ],
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
          centerTitle: false,
          titlePadding: const EdgeInsetsDirectional.only(start: 16.0, bottom: 14.0),
          collapseMode: CollapseMode.pin,
          title: InkWell(
                  onTap: (){
                    NavigatorUtils.pushResult(context, StatisticsRouter.citySelectPage, (Object result) {
                      setState(() {
                        final CityEntity model = result as CityEntity;
                        provider.setCode(model.cityCode);
                        presenter.changeCity(model.cityCode);
                      });
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        entity==null?"北京":entity?.name,
                        style: TextStyle(color: ThemeUtils.getIconColor(context),fontSize:16),
                      ),
                      Gaps.hGap4,
                      LoadAssetImage('goods/expand', width: 10.0, height: 10.0, color: Color(0xfff1f1f1),),
                      entity == null ? Text(''): entity.loc == null?Text(''): Row(
                        children: [
                          Gaps.hGap10,
                          LoadAssetImage('statistic/location', width: 10.0, height: 10.0),
                          Text(entity == null ? "": entity.loc == null?"":entity?.loc,style: TextStyle(fontSize: Dimens.font_sp8, color: ThemeUtils.getIconColor(context)))
                        ],
                      )
                    ],
                  ),
                ),

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
              height: 130.0,
              child: MyCard(
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                       Row(
                         children: <Widget>[
                           _StatisticsTab('pm2.5', evn==null?'face':evn.aqiState==null?'face':evn.aqiState, evn==null?'-':evn.aqi==null?'-':evn.aqi),
                           _StatisticsTab('pm10', evn==null?'face':evn.pm10State==null?'face':evn.pm10State, evn==null?'-':evn.pm10==null?'-':evn.pm10),
                           _StatisticsTab('臭氧', evn==null?'face':evn.o3State==null?'face':evn.o3State, evn==null?'-':evn.o3==null?'-':evn.o3),
                           _StatisticsTab('一氧化碳', evn==null?'face':evn.coState==null?'face':evn.coState, evn==null?'-':evn.co==null?'-':evn.co),
                           _StatisticsTab('二氧化硫', evn==null?'face':evn?.so2State==null?'face':evn.so2State, evn==null?'-':evn.so2==null?'-':evn.so2),
                         ],
                     ),
                     Gaps.vGap8,
                     Row(
                       children: [
                         Gaps.hGap16,
                         Text(evn==null?'':evn.level, style: TextStyle(fontSize: Dimens.font_sp10,color: Color(evn==null?0:evn.color))),
                         Text(evn==null?'':evn.desc,style: const TextStyle(fontSize: Dimens.font_sp10)),
                         Text(evn==null?'':evn.flag > 0?' 主要污染物: ${evn.source}':'',style: const TextStyle(fontSize: Dimens.font_sp10)),
                       ],
                     )
                   ],
                )
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
              _StatisticsItem('今日AQI分布图', 'jyetj', 2, MyReact(entity?.react)),
              // Gaps.vGap8,
              // _StatisticsItem('商品统计', 'sptj', 3),
            ],
          ),
        ),
      )
    ];
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      String code = provider.code;
      if(code == null){
        presenter.initState();
      }else{
        presenter.changeCity(code);
      }
    });
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