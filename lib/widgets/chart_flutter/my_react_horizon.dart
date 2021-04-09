import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class MyReactHorizon extends StatelessWidget {


  const MyReactHorizon({Key key}) : super(key: key);

  // /// Creates a [BarChart] with sample data and no transition.
  // factory MyReact.withSampleData() {
  //   return new MyReact(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _createSampleData(),
      animate: false,
      vertical: false
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('北京', 100),
      new OrdinalSales('上海', 85),
      new OrdinalSales('广州', 50),
      new OrdinalSales('深圳', 35),
    ];

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