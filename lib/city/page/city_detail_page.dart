

import 'package:flutter/material.dart';
import 'package:flutter_aqi/city/page/city_detail_list_page.dart';
import 'package:flutter_aqi/city/provider/order_page_provider.dart';
import 'package:flutter_aqi/res/resources.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/utils/image_utils.dart';
import 'package:flutter_aqi/utils/screen_utils.dart';
import 'package:flutter_aqi/utils/theme_utils.dart';
import 'package:flutter_aqi/widgets/load_image.dart';
import 'package:flutter_aqi/widgets/my_card.dart';
import 'package:flutter_aqi/widgets/my_flexible_space_bar.dart';
import 'package:provider/provider.dart';

//import '../order_router.dart';


/// design/3订单/index.html
class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with AutomaticKeepAliveClientMixin<OrderPage>, SingleTickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;
  
  TabController _tabController;
  OrderPageProvider provider = OrderPageProvider();

  int _lastReportedPage = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 预先缓存剩余切换图片
      _preCacheImage();
    });
  }

  void _preCacheImage() {
    precacheImage(ImageUtils.getAssetImage('order/xdd_n'), context);
    precacheImage(ImageUtils.getAssetImage('order/dps_s'), context);
    precacheImage(ImageUtils.getAssetImage('order/dwc_s'), context);
    precacheImage(ImageUtils.getAssetImage('order/ywc_s'), context);
    precacheImage(ImageUtils.getAssetImage('order/yqx_s'), context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    isDark = context.isDark;
    return ChangeNotifierProvider<OrderPageProvider>(
      create: (_) => provider,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            /// 像素对齐问题的临时解决方法
            SafeArea(
              child: SizedBox(
                height: 105,
                width: double.infinity,
                child: isDark ? null : const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF5793FA), Color(0xFF4647FA)]),
                  ),
                ),
              ),
            ),
            NestedScrollView(
              key: const Key('order_list'),
              physics: const ClampingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) => _sliverBuilder(context),
              body: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  /// PageView的onPageChanged是监听ScrollUpdateNotification，会造成滑动中卡顿。这里修改为监听滚动结束再更新、
                  if (notification.depth == 0 && notification is ScrollEndNotification) {
                    final PageMetrics metrics = notification.metrics as PageMetrics;
                    final int currentPage = metrics.page.round();
                    if (currentPage != _lastReportedPage) {
                      _lastReportedPage = currentPage;
                      _onPageChange(currentPage);
                    }
                  }
                  return false;
                },
                child: PageView.builder(
                  key: const Key('pageView'),
                  itemCount: 5,
                  controller: _pageController,
                  itemBuilder: (_, index) => OrderListPage(index: index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context) {
    return <Widget>[
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          leading: Gaps.empty,
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          expandedHeight: 113.0,
          floating: false, // 不随着滑动隐藏标题
          pinned: true, // 固定在顶部
          flexibleSpace: MyFlexibleSpaceBar(
            background: isDark ? Container(height: 113.0, color: Colours.dark_bg_color,) : LoadAssetImage('order/beijing',
              width: context.width,
              height: 113.0,
              fit: BoxFit.fill,
            ),
            centerTitle: true,
            titlePadding: const EdgeInsetsDirectional.only(start: 16.0, bottom: 14.0),
            collapseMode: CollapseMode.pin,
            title: Text(''),
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
                image: ImageUtils.getAssetImage('order/order_bg1'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: MyCard(
                child: Container(
                  height: 180.0,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 19.0),
                          child: Text('北京',style: TextStyle(fontSize: Dimens.font_sp18),),
                        ),
                        Gaps.vGap8,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 19.0),
                          child: Text('简称“京”，是中华人民共和国的首都及直辖市，中国大陆的政治、文化、科技和国际交往中心，是世界人口第三多的城市和人口最多的首都，具有重要的国际影响力[4]。北京位于华北平原的西北边缘，背靠燕山，有永定河流经老城西南，毗邻天津市、河北省，为京津冀城市群的重要组成部分',
                                       maxLines: 3,
                                       style: Theme.of(context).textTheme.subtitle2),
                        ),
                        Gaps.vGap12,
                        TabBar(
                          labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                          controller: _tabController,
                          labelColor: context.isDark ? Colours.dark_text : Colours.text,
                          unselectedLabelColor: context.isDark ? Colours.dark_text_gray : Colours.text,
                          labelStyle: TextStyles.textBold14,
                          unselectedLabelStyle: const TextStyle(
                            fontSize: Dimens.font_sp14,
                          ),
                          indicatorColor: Colors.transparent,
                          tabs: const <Widget>[
                            _TabView(0, '住房'),
                            _TabView(1, '景点'),
                            _TabView(2, '攻略'),
                            _TabView(3, '教育'),
                            _TabView(4, '医院'),
                          ],
                          onTap: (index) {
                            if (!mounted) {
                              return;
                            }
                            _pageController.jumpToPage(index);
                          },
                        ),
                      ],
                  ),
                ),
              ),
            ),
          ), 180.0,
        ),
      ),
    ];
  }

  final PageController _pageController = PageController(initialPage: 0);
  Future<void> _onPageChange(int index) async {
    provider.setIndex(index);
    /// 这里没有指示器，所以缩短过渡动画时间，减少不必要的刷新
    _tabController.animateTo(index, duration: const Duration(milliseconds: 0));
  }
}

List<List<String>> img = [
  ['city/fz', 'city/fz'],
  ['city/fj', 'city/fj'],
  ['city/book', 'city/book'],
  ['city/job', 'city/job'],
  ['city/his', 'city/his']
];

List<List<String>> darkImg = [
  ['order/dark/icon_xdd_s', 'order/dark/icon_xdd_n'],
  ['order/dark/icon_dps_s', 'order/dark/icon_dps_n'],
  ['order/dark/icon_dwc_s', 'order/dark/icon_dwc_n'],
  ['order/dark/icon_ywc_s', 'order/dark/icon_ywc_n'],
  ['order/dark/icon_yqx_s', 'order/dark/icon_yqx_n']
];

class _TabView extends StatelessWidget {

  const _TabView(this.index, this.text);

  final int index;
  final String text;
  
  @override
  Widget build(BuildContext context) {
    final List<List<String>> imgList = context.isDark ? darkImg : img;
    return Stack(
      children: <Widget>[
        Container(
          width: 36.0,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /// 使用context.select替代Consumer
              LoadAssetImage(context.select<OrderPageProvider, int>((value) => value.index) == index ? 
              imgList[index][0] : 
              imgList[index][1], width: 24.0, height: 24.0,),
              Gaps.vGap4,
              Text(text,style: TextStyle(fontSize: Dimens.font_sp14),),
            ],
          ),
        ),
        Positioned(
          right: 0.0,
          child: index < 0 ? DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).errorColor,
              borderRadius: BorderRadius.circular(11.0),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.5, vertical: 2.0),
              child: Text('10', style: TextStyle(color: Colors.white, fontSize: Dimens.font_sp12),),
            ),
          ) : Gaps.empty,
        )
      ],
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