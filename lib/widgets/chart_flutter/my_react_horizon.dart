import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aqi/shop/models/rank_entity.dart';

class MyReactHorizon extends StatelessWidget {
  List<RankItem> items;

  List<OrdinalSales> data = [];
  List<TickSpec<String>> tickSpecs = [];
  MyReactHorizon(this.items, {Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _createSampleData(),
      animate: false,
      vertical: false,
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    if(items != null && items.length > 0){
      items.forEach((v) {
        data.add(new OrdinalSales(v.name, v.c));
      });
    }

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}