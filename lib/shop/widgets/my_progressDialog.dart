import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aqi/widgets/progress_dialog.dart';

class MyProgressDialog extends StatelessWidget {
  final bool loading;
  final Widget child;

  MyProgressDialog({Key key, @required this.loading, @required this.child})
      : assert(child != null),
        assert(loading != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    //如果正在加载，则显示加载添加加载中布局
    if (loading) {
      widgetList.add(Center(
        child: buildProgress(),
      ));
    }
    return Stack(
      children: widgetList,
    );
  }

  Widget buildProgress() => const ProgressDialog(hintText: '正在加载...');
}