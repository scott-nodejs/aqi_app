import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_aqi/statistics/models/aqi_model.dart';

class MyBezier extends StatelessWidget {

  List<TimeSeriesSales> data = [];

  List<AqiItem> item;

  MyBezier(this.item,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  _simpleLine();
  }

  Widget _simpleLine() {

    List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
      if(item != null && item.length > 0){
        item.forEach((v) {
          data.add(new TimeSeriesSales(DateTime.fromMillisecondsSinceEpoch(v.date), v.aqi),);
        });
      }

      return [
        new charts.Series<TimeSeriesSales, DateTime>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: data,
        )
      ];
    }


    return charts.TimeSeriesChart(_createSampleData(),
        animate: true,
        defaultRenderer: charts.LineRendererConfig(
          // 圆点大小
          radiusPx: 0.0,
          stacked: false,
          // 线的宽度
          strokeWidthPx: 2.0,
          // 是否显示线
          includeLine: true,
          // 是否显示圆点
          includePoints: true,
          // 是否显示包含区域
          includeArea: true,
          // 区域颜色透明度 0.0-1.0
          areaOpacity: 0.2 ,
        ),
        domainAxis: new charts.DateTimeAxisSpec(
          tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
            day: new charts.TimeFormatterSpec(
              format: 'dd',
              transitionFormat: 'MM-dd',
            ),
          ),
        ),
    );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}