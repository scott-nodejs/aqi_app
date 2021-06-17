
import 'package:flutter/material.dart';
import 'package:flutter_aqi/net/dio_utils.dart';
import 'package:flutter_aqi/net/http_api.dart';
import 'package:flutter_aqi/res/dimens.dart';
import 'package:flutter_aqi/res/gaps.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/shop/models/rank_entity.dart';
import 'package:flutter_aqi/shop/widgets/my_progressDialog.dart';
import 'package:flutter_aqi/utils/theme_utils.dart';
import 'package:flutter_aqi/widgets/load_image.dart';
import 'package:flutter_aqi/widgets/my_card.dart';
import 'package:flutter_aqi/widgets/my_refresh_list.dart';
import 'package:sprintf/sprintf.dart';

class RankPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RankPageState();
  }
}

class _RankPageState extends State<RankPage>  with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => false;

  bool _type = false;

  bool loading = true;

  int _page = 1;

  RankEntity rankEntity;

  List<City> _list = List<City>();
  List<RankItem> _ranklist = List<RankItem>();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _initData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("loadMore");
        _getMoreData();
      }
    });
    super.initState();
  }

  dynamic lastKey = 1;
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('城市排行',style: TextStyle(
              fontSize: Dimens.font_sp18,
              fontWeight: FontWeight.bold,
              color: Colors.black
          )))
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: MyProgressDialog(
                loading: loading,
                child:ListView.builder(
                  itemCount: _list.length <= 0 ? 0 : _list.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _list.length) {
                      return MoreWidget(_list.length, _hasMore(), 20);
                    } else {
                      return _buildItem(_list[index],_ranklist[index], index);
                    }
                  },
                  controller: _scrollController,
                )),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
        margin: EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
            height: 20.0,
            width: 20.0,
          ),
        ));
  }

  bool _hasMore() {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _buildItem(City city,RankItem item, int index) {
    final Color _iconColor = ThemeUtils.getIconColor(context);
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
                child: LoadAssetImage('order/${rankEntity?.type == 0 ? 'good':'bad'}'),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(4.0),
                //   border: Border.all(color: _iconColor, width: 0.6),
                //   image: DecorationImage(
                //     image: ImageUtils.getAssetImage('order/${provider.rank?.type == 0 ? 'good':'bad'}'),
                //     fit: BoxFit.fitWidth,
                //   ),
                // ),
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
              Gaps.hGap16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: _type ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Visibility(visible: !_type, child: Text(city!=null?city.feature==null?city.province+city.city:city.feature:'', style: Theme.of(context).textTheme.subtitle2)),
                  Text('当前空气质量指数: ${item.aqi}', style: Theme.of(context).textTheme.subtitle2),
                  Text('排行榜系数: ${item.c}', style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _initData() async {
    String url = sprintf(HttpApi.rank,[0, 1]);
    DioUtils.instance.asyncRequestNetwork<RankEntity>(Method.get, url,
      params: '',
      queryParameters: {},
      onSuccess: (data) {
        if(data != null){
          setState(() {
            loading = !loading;
            _ranklist.clear();
            _ranklist.addAll(data.ranks);
            _list.clear();
            _list.addAll(data.citys);
          });
        }

      },
      onError: (code, msg) {

      },
    );
  }

  Future<Null> _onRefresh() async {
    String url = sprintf(HttpApi.rank,[0, 1]);
    DioUtils.instance.asyncRequestNetwork<RankEntity>(Method.get, url,
      params: '',
      queryParameters: {},
      onSuccess: (data) {
        if(data != null){
          setState(() {
            _ranklist.clear();
            _ranklist.addAll(data.ranks);
            _list.clear();
            _list.addAll(data.citys);
          });
        }

      },
      onError: (code, msg) {

      },
    );
  }

  Future<Null> _getMoreData() async {
    String url = sprintf(HttpApi.rank,[0, ++_page]);

    DioUtils.instance.asyncRequestNetwork<RankEntity>(Method.get, url,
      params: '',
      queryParameters: {},
      onSuccess: (data) {
        if(data != null){
          setState(() {
            rankEntity = data;
            _ranklist.addAll(data.ranks);
            _list.addAll(data.citys);
          });
        }
      },
      onError: (code, msg) {

      },
    );
  }
}