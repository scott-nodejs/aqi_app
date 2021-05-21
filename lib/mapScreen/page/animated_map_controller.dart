import 'package:flutter/material.dart';
import 'package:flutter_aqi/mapScreen/iview/map_iview.dart';
import 'package:flutter_aqi/mapScreen/models/map_model.dart';
import 'package:flutter_aqi/mapScreen/presenter/MapPresenter.dart';
import 'package:flutter_aqi/mapScreen/provider/map_provider.dart';
import 'package:flutter_aqi/mapScreen/widget/bubble_widget.dart';
import 'package:flutter_aqi/mvp/base_page.dart';
import 'package:flutter_aqi/net/dio_utils.dart';
import 'package:flutter_aqi/net/http_api.dart';
import 'package:flutter_aqi/shop/models/rank_entity.dart';
import 'package:flutter_aqi/utils/toast.dart';
import 'package:flutter_aqi/widgets/search_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_aqi/utils/theme_utils.dart';
import "package:flutter_map/flutter_map.dart" as flutterMap;
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sprintf/sprintf.dart';

class AnimatedMapControllerPage extends StatefulWidget {
  static const String route = 'map_controller_animated';

  @override
  AnimatedMapControllerPageState createState() {
    return AnimatedMapControllerPageState();
  }
}

class AnimatedMapControllerPageState extends State<AnimatedMapControllerPage>
    with TickerProviderStateMixin,BasePageMixin<AnimatedMapControllerPage, MapPresenter> implements MapIMvpView{

  static LatLng beijing = LatLng(39.954592,116.468117);
  static LatLng shenzhen = LatLng(22.543099,114.057868);
  static LatLng shanghai = LatLng(31.2047372,121.4489017);
  static LatLng chengdu = LatLng(30.6250145,104.0670559);
  static LatLng xiamen = LatLng(24.479834,118.089425);
  final TextEditingController _controller = TextEditingController();
  List<String> citys = ['北京', '深圳', '上海', '成都'];

  MapController mapController;

  double lat = 0, long = 0;

  bool isDark;

  MapProvider provider = new MapProvider();

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _getCityQByClient(String city) async{
    String url = sprintf(HttpApi.get_city, [city]);
    DioUtils.instance.asyncRequestNetwork<City>(Method.get, url,
      params: '',
      queryParameters: {},
      onSuccess: (data) {
        setState(() {
          if(data != null){
            _animatedMapMove(LatLng(data.lat,data.lon), 10.0);
          }
        });
      },
      onError: (code, msg) {

      },
    );

  }

  @override
  Widget build(BuildContext context) {
    isDark = context.isDark;
    return ChangeNotifierProvider<MapProvider>(
        create: (_) => provider,
        child: Scaffold(
          appBar: SearchBar(
            hintText: '请输入城市名称查询',
            onPressed: (text) => {
              _getCityQByClient(text)
            },
            controller: _controller,
            citys: citys,
          ),
          // appBar: AppBar(title: Center(child: Text('地图看AQI',style: TextStyle(fontSize: 16, color: isDark ? Colors.white: Colors.black)))),
          body: Consumer<MapProvider>(
              builder: (_, provider, __) {
                lat = SpUtil.getDouble("lat");
                long = SpUtil.getDouble("lng");
                return Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      _controller.text = "北京";
                                      _animatedMapMove(beijing, 10.0);
                                    },
                                    child: Text('北京'),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      _controller.text = "深圳";
                                      _animatedMapMove(shenzhen, 10.0);
                                    },
                                    child: Text('深圳'),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      _controller.text = "上海";
                                      _animatedMapMove(shanghai, 10.0);
                                    },
                                    child: Text('上海'),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      _controller.text = "成都";
                                      _animatedMapMove(chengdu, 10.0);
                                    },
                                    child: Text('成都'),
                                  ),
                                  // MaterialButton(
                                  //   onPressed: () {
                                  //     _animatedMapMove(xiamen, 10.0);
                                  //   },
                                  //   child: Text('厦门'),
                                  // ),//
                                ],
                              ),
                            ),
                            Flexible(
                              child: Stack(
                                children: <Widget>[
                                  FlutterMap(
                                    mapController: mapController,
                                    options: MapOptions(
                                        center: LatLng(lat != 0.0 ? lat : 39.954592, long != 0.0 ? long : 116.468117),
                                        zoom: 10.0,
                                        maxZoom: 13.0,
                                        minZoom: 8.0),
                                    layers: [
                                      TileLayerOptions(
                                          urlTemplate:
                                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          subdomains: ['a', 'b', 'c']),
                                      MarkerLayerOptions(markers: generateMarker())
                                    ],
                                  ),
                                  provider.pinClicked
                                      ? Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 60, horizontal: 20),
                                    height: 190,
                                    child: Dialog(
                                      backgroundColor:
                                      Colors.white10.withAlpha(100),
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: showContainer(),
                                    ),
                                  )
                                  : Container(),
                              ])
                            ),
                          ],
                        ),
                      );
              })
        )
    );
  }

  Widget showContainer() {
    // MapEntity entity = provider.entity;
    // MapItem location;
    // if(entity != null){
    //   List<MapItem> items = entity.items;
    //   for (MapItem _location in items) {
    //     if(_location.g[0] == provider.lat || _location.g[1] == provider.long){
    //       location = _location;
    //     }
    //   }
    // }
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            provider.name != null
                ? Text(
              provider.name,
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
                : Container(),
            provider.updatetime != null
                ? Text(
              '更新于 '+provider?.updatetime,
              style: TextStyle(
                  color: Colors.black, fontSize: 10),
                textAlign: TextAlign.center
            )
                : Container(),
            RaisedButton(
                color: Colors.red,
                child: Text("关闭"),
                onPressed: () {
                  provider.setPinClicked(false);
                })
          ],
        ),
      ),
    );
  }

  List<flutterMap.Marker> generateMarker() {
    List<flutterMap.Marker> marker = [];
    MapEntity entity = provider.entity;
    if(entity != null){
      List<MapItem> items = entity.items;
      for (MapItem location in items) {
        marker.add(
          Marker(
              width: 80.0,
              height: 40.0,
              point: LatLng(
                location.g == null ? 80.0 : location.g[0],
                location.g == null ? 40 : location.g[1],
              ),
              builder: (context) =>  GestureDetector(
                child: new Container(
                  child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: BubbleWidget(35.0, 30.0, Color(location.color),
                              BubbleArrowDirection.bottom,arrHeight:6.0,radius:5.0,innerPadding:0.0,strokeWidth:2.0,
                              child: Text(location.a == '0' ? '-':location.a, style: TextStyle(color: Colors.white, fontSize: 14.0))
                          )
                      )
                  ),
                ),
                onTap: (){
                  _animatedMapMove(LatLng(location.g[0],location.g[1]), 10.0);
                  provider.setPinClicked(true);
                  provider.setLat(location.g[0]);
                  provider.setLong(location.g[1]);
                  provider.setName(location.name);
                  provider.setUpdatetime(location.updatetime);
                },
              )
          ),
        );
      }
    }

    return marker;
  }

  @override
  MapPresenter createPresenter() {
    return MapPresenter();
  }

  @override
  void setMapEntity(entity) {
    provider.setMapEntity(entity);
  }
}
