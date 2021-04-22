import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aqi/mapScreen/presenter/MapPresenter.dart';
import 'package:flutter_aqi/mapScreen/provider/map_provider.dart';
import 'package:flutter_aqi/mapScreen/widget/bubble_widget.dart';
import 'package:flutter_aqi/mvp/base_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import "package:flutter_map/flutter_map.dart" as flutterMap;
import "package:latlong/latlong.dart";
import 'package:provider/provider.dart';

import 'iview/map_iview.dart';
import 'models/map_model.dart';

class CreateMapScreen extends StatefulWidget {
  @override
  _CreateMapScreenState createState() => _CreateMapScreenState();
}

class _CreateMapScreenState extends State<CreateMapScreen> with BasePageMixin<CreateMapScreen, MapPresenter> implements MapIMvpView{
  MapController _controller;
  double lat = 0, long = 0;

  MapProvider provider = new MapProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapProvider>(
        create: (_) => provider,
        child: Scaffold(
          appBar: AppBar(title: const Text('地图看AQI')),
          body: Consumer<MapProvider>(
                  builder: (_, provider, __) {
                      lat = SpUtil.getDouble("lat");
                      long = SpUtil.getDouble("lng");
                      return Stack(
                        children: <Widget>[
                            FlutterMap(
                            mapController: _controller,
                            options: MapOptions(
                              center: LatLng(lat != null ? lat : 39.954592, long != null ? long : 116.468117),
                              zoom: 11.0,
                            ),
                            layers: [
                              TileLayerOptions(
                                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c']
                              ),
                              MarkerLayerOptions(
                                markers: generateMarker(),
                              ),
                            ],
                          ),
                          provider.pinClicked
                              ? Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 60, horizontal: 20),
                            height: 250,
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
                        ]);
                  }
        ))
    );
  }

  Widget showContainer() {
    MapEntity entity = provider.entity;
    MapItem location;
    if(entity != null){
      List<MapItem> items = entity.items;
      for (MapItem _location in items) {
           if(_location.g[0] == provider.lat || _location.g[1] == provider.long){
             location = _location;
           }
      }
    }
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
            location != null
                ? Text(
              location?.name,
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
                : Container(),
            location != null
                ? Text(
              '更新于 '+location?.updatetime,
              style: TextStyle(
                  color: Colors.black, fontSize: 10),
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
                provider.setPinClicked(true);
                provider.setLat(location.g[0]);
                provider.setLong(location.g[1]);
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