import 'package:flutter/material.dart';
import 'package:flutter_aqi/res/resources.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/utils/theme_utils.dart';
import 'package:flutter_aqi/widgets/load_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aqi/city/page/city_list_page.dart';
import 'package:flutter_aqi/city/provider/city_provider.dart';

class CityPage extends StatefulWidget {
  @override
  _CityPageState createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  final List<String> _sortList = ['全部商品', '个人护理', '饮料', '沐浴洗护', '厨房用具', '休闲食品', '生鲜水果', '酒水', '家庭清洁'];
  TabController _tabController;
  final PageController _pageController = PageController(initialPage: 0);

  final GlobalKey _addKey = GlobalKey();
  final GlobalKey _bodyKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  CityProvider provider = CityProvider();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Color _iconColor = ThemeUtils.getIconColor(context);
    return ChangeNotifierProvider<CityProvider>(
      create: (_) => provider,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              tooltip: '搜索商品',
              onPressed: () => NavigatorUtils.push(context, ''),
              icon: LoadAssetImage(
                'goods/search',
                key: const Key('search'),
                width: 24.0,
                height: 24.0,
                color: _iconColor,
              ),
            )
          ],
        ),
        body: Column(
          key: _bodyKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // 隐藏点击效果
              padding: const EdgeInsets.only(left: 16.0),
              color: context.backgroundColor,
              child: TabBar(
                onTap: (index) {
                  if (!mounted) {
                    return;
                  }
                  _pageController.jumpToPage(index);
                },
                isScrollable: true,
                controller: _tabController,
                labelStyle: TextStyles.textBold18,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: const EdgeInsets.only(left: 0.0),
                unselectedLabelColor: context.isDark ? Colours.text_gray : Colours.text,
                labelColor: Theme.of(context).primaryColor,
                indicatorPadding: const EdgeInsets.only(right: 98.0 - 36.0),
                tabs: const <Widget>[
                  _TabView('热门城市', 0),
                  _TabView('一线城市', 1),
                  _TabView('特色城市', 2),
                ],
              ),
            ),
            Gaps.line,
            Expanded(
              child: PageView.builder(
                  key: const Key('pageView'),
                  itemCount: 3,
                  onPageChanged: _onPageChange,
                  controller: _pageController,
                  itemBuilder: (_, int index) => GoodsListPage(index: index)
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onPageChange(int index) {
    _tabController.animateTo(index);
    provider.setIndex(index);
  }

  @override
  bool get wantKeepAlive => true;
}

class _TabView extends StatelessWidget {

  const _TabView(this.tabName, this.index);

  final String tabName;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: SizedBox(
        width: 98.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(tabName),
            Consumer<CityProvider>(
              builder: (_, provider, child) {
                return Visibility(
                  visible: !(provider.goodsCountList[index] == 0 || provider.index != index),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(' (${provider.goodsCountList[index]}件)',
                      style: const TextStyle(fontSize: Dimens.font_sp12),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
