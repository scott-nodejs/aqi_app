
import 'package:flutter/material.dart';
import 'package:flutter_aqi/city/models/cityq_detail_entity.dart';
import 'package:flutter_aqi/city/models/trade_entity.dart';
import 'package:flutter_aqi/city/provider/order_page_provider.dart';
import 'package:flutter_aqi/city/widgets/order_item.dart';
import 'package:flutter_aqi/city/widgets/order_tag_item.dart';
import 'package:flutter_aqi/net/dio_utils.dart';
import 'package:flutter_aqi/net/http_api.dart';
import 'package:flutter_aqi/utils/change_notifier_manage.dart';
import 'package:flutter_aqi/widgets/my_refresh_list.dart';
import 'package:flutter_aqi/widgets/state_layout.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class OrderListPage extends StatefulWidget {

  OrderListPage({
    Key key,
    @required this.index,
    @required this.uid,
  }): super(key: key);

  final int index;

  int uid;
  
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> with AutomaticKeepAliveClientMixin<OrderListPage>, ChangeNotifierMixin<OrderListPage>{

  final ScrollController _controller = ScrollController();
  final StateType _stateType = StateType.loading;
  /// 是否正在加载数据
  bool _isLoading = false;
  int _maxPage = 3;
  int _page = 1;
  int _index = 0;
  List<String> _list = <String>[];

  List<dynamic> _list1 = <dynamic>[];
  
  @override
  void initState() {
    super.initState();
    _index = widget.index;
    _getTradeList(widget.uid);
    //_onRefresh();
  }

  @override
  Map<ChangeNotifier, List<VoidCallback>> changeNotifier() {
    return {_controller: null};
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener(
      onNotification: (ScrollNotification note) {
        if (note.metrics.pixels == note.metrics.maxScrollExtent) {
          _loadMore();
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        displacement: 120.0, /// 默认40， 多添加的80为Header高度
        child: Consumer<OrderPageProvider>(
          builder: (_, provider, child) {
            return CustomScrollView(
              /// 这里指定controller可以与外层NestedScrollView的滚动分离，避免一处滑动，5个Tab中的列表同步滑动。
              /// 这种方法的缺点是会重新layout列表
              controller: _index != provider.index ? _controller : null,
              key: PageStorageKey<String>('$_index'),
              slivers: <Widget>[
                SliverOverlapInjector(
                  ///SliverAppBar的expandedHeight高度,避免重叠
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                child,
              ],
            );
          },
          child: SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: _list1.isEmpty ? SliverFillRemaining(child: StateLayout(type: _stateType)) :
            SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                return index < _list1.length ?
                OrderItem(key: Key('order_item_$index'), index: index, tabIndex: _index, list: _list1,)
                // (index % 5 == 0 ?
                //     const OrderTagItem(date: '2020年2月5日', orderTotal: 4) :
                //     OrderItem(key: Key('order_item_$index'), index: index, tabIndex: _index,)
                // )
                :
                MoreWidget(_list1.length, _hasMore(), 10);
              },
              childCount: _list1.length + 1),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _page = 1;
      _list1.clear();
    });
    _getTradeList(widget.uid);
  }

  void _getTradeList(int id) async{
    String url = sprintf(HttpApi.trade_list,[id,_page]);
    DioUtils.instance.asyncRequestNetwork<CityqDetailEntity>(Method.get, url,
      params: '',
      queryParameters: {},
      onSuccess: (data) {
        setState(() {
          switch(widget.index){
            case 0:
              _list1 = List.generate(10, (i) => 'newItem：$i');
              return _list1;
            case 1:
              if(data != null && data.trades != null){
                _maxPage = data.trades.maxpage;
                _list1.addAll(data.trades.cityQWapper);
              }
              return _list1;
            case 2:
              if(data != null && data.raiders != null){
                _maxPage = data.trades.maxpage;
                _list1.addAll(data.raiders.cityQWapper);
              }
              return _list1;
            case 3:
              _list1 = List.generate(10, (i) => 'newItem：$i');
              return _list1;
            case 4:
              _list1 = List.generate(10, (i) => 'newItem：$i');
              return _list1;
          }
        });
      },
      onError: (code, msg) {

      },
    );

  }

  bool _hasMore() {
    return _page < _maxPage;
  }

  Future<void> _loadMore() async {
    if (_isLoading) {
      return;
    }
    if (!_hasMore()) {
      return;
    }
    _isLoading = true;
    setState(() {
      _page ++;
      _isLoading = false;
    });
    _getTradeList(widget.uid);
  }
  
  @override
  bool get wantKeepAlive => true;
}
