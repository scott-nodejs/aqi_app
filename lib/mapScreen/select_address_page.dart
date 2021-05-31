
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/widgets/my_button.dart';
import 'package:flutter_aqi/widgets/search_bar.dart';

class AddressSelectPage extends StatefulWidget {
  @override
  _AddressSelectPageState createState() => _AddressSelectPageState();
}

class _AddressSelectPageState extends State<AddressSelectPage> {
  
  List<PoiSearch> _list = [];
  int _index = 0;
  final ScrollController _controller = ScrollController();
  AMap2DController _aMap2DController;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    /// iOS配置key
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      Flutter2dAMap.setApiKey('4327916279bf45a044bb53b947442387');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('地图'),),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: AMap2DView(
                webKey: '4e479545913a3a180b3cffc267dad646',
                onPoiSearched: (result) {
                  _controller.animateTo(0.0, duration: const Duration(milliseconds: 10), curve: Curves.ease);
                  _index = 0;
                  _list = result;
                  setState(() {
                   
                  });
                },
                onAMap2DViewCreated: (controller) {
                  _aMap2DController = controller;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressItem extends StatelessWidget {

  const _AddressItem({
    Key key,
    @required this.date,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final PoiSearch date;
  final bool isSelected;
  final GestureTapCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 50.0,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                date.provinceName + ' ' +
                date.cityName + ' ' +
                date.adName + ' ' +
                date.title,
              ),
            ),
            Visibility(
              visible: isSelected,
              child: const Icon(Icons.done, color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}

