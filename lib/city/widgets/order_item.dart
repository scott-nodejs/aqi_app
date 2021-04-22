
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aqi/city/widgets/pay_type_dialog.dart';
import 'package:flutter_aqi/city/widgets/rating_bar.dart';
import 'package:flutter_aqi/res/resources.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/utils/theme_utils.dart';
import 'package:flutter_aqi/utils/toast.dart';
import 'package:flutter_aqi/utils/other_utils.dart';
import 'package:flutter_aqi/widgets/load_image.dart';
import 'package:flutter_aqi/widgets/my_card.dart';

//import '../order_router.dart';

const List<String> orderLeftButtonText = ['拒单', '拒单', '订单跟踪', '订单跟踪', '订单跟踪'];
const List<String> orderRightButtonText = ['接单', '开始配送', '完成', '', ''];

class OrderItem extends StatelessWidget {

  const OrderItem({
    Key key,
    @required this.tabIndex,
    @required this.index,
  }) : super(key: key);

  final int tabIndex;
  final int index;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: MyCard(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () => NavigatorUtils.push(context, ''),
            child: _route(context, index),
          ),
        ),
      )
    );
  }

  Widget _route(context, index){
     if(tabIndex == 0){
      return _buildHouse(context);
     }else if(tabIndex == 1){
       return _buildLandscape(context);
     }else if(tabIndex == 2){
       return _buildRaiders(context);
     }else if(tabIndex == 3){
       return _buildEducation(context);
     }else if(tabIndex == 4){
       return _buildHispotail(context);
     }else{
       return _buildContent(context);
     }
  }

  //美景列表
  Widget _buildLandscape(BuildContext context){
    final TextStyle textTextStyle = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: Dimens.font_sp12);
    final bool isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage('https://n1-q.mafengwo.net/s11/M00/46/1A/wKgBEFrsPkeARLM7AAEBBbum5WQ58.jpeg?imageMogr2%2Fthumbnail%2F%21380x270r%2Fgravity%2FCenter%2Fcrop%2F%21380x270%2Fquality%2F100')
                    )
                )
            ),
            Expanded(
              child:Container(
                        height: 75.0,
                        margin: EdgeInsets.only(bottom: 1.0),
                        child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Container(
                                  child: new Text(
                                    "故宫 (5A)",
                                    style: new TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  // child: Text(
                                  //   "评分: ${app.score}",
                                  //   style: TextStyle(
                                  //       fontSize: 12.0, color: ConfigColor.colorText3),
                                  // ),
                                    child: RatingBar(
                                          4.9 * 2,
                                          size: 11.0,
                                          fontSize: 0.0,
                                        )
                                ),
                                new Container(
                                  child: Text(
                                        '4.8/4.7  1323234评论',
                                        style: Theme.of(context).textTheme.subtitle2,
                                         maxLines: 2,
                                        ),
                                )
                              ],
                      ),
              )
            ),
          ],
        ),
        Gaps.vGap12,
        MyCard(
            color: Color(0xffDCDCDC),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Text('又名紫禁城，是中国乃至世界上保存最完整，规模最大的木质结构古建筑群，被誉为“世界五大宫之首'),
            )
        ),
        Gaps.vGap4,
      ],
    );
  }

  //攻略
  Widget _buildRaiders(BuildContext context){
    final bool isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: NetworkImage('http://b1-q.mafengwo.net/s11/M00/36/36/wKgBEFrhb3SAN3dcABAft7C2kYs76.jpeg?imageMogr2%2Fthumbnail%2F%21305x183r%2Fgravity%2FCenter%2Fcrop%2F%21305x183%2Fquality%2F100')
                    )
                )
            ),
            Expanded(
                child:Container(
                  height: 75.0,
                  margin: EdgeInsets.only(left: 8.0, bottom: 1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Container(
                        child: new Text(
                          "不到长城非好汉",
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      new Container(
                        child: Text(
                          '''''被称为“天下九塞”之一，是明长城景色中的精华，海拔高达1015米，也是居庸关的前哨。
                            ·分为南长城和北长城两部分，南长城有7处敌楼，游客相对较少，北长城有12处敌楼，比较难爬。
                          ·是游览北京的必到之处，尼克松、撒切尔夫人等三百多位世界知名人士曾登上长城。
                          ·是5A级景区，被联合国教科文组织列入《世界文化遗产名录》，热度仅次于天安门广场。''',
                          style: Theme.of(context).textTheme.subtitle2,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                )
            ),
          ],
        ),
        Container(
          child: Text("马蜂窝 12322评论", style: Theme.of(context).textTheme.subtitle2,),
        )
      ],
    );
  }

  //住房
  Widget _buildHouse(BuildContext context){
    final TextStyle textTextStyle = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: Dimens.font_sp12);
    final bool isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text('海淀区'),
            ),
            Text(
              '查看更多',
              style: TextStyle(
                fontSize: Dimens.font_sp12,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
        Gaps.vGap8,
        Text(
          '目前海淀区的房价均价在70000-100000之间',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Gaps.vGap8,
        Gaps.line,
        Gaps.vGap8,
        RichText(
          text: TextSpan(
            style: textTextStyle,
            children: <TextSpan>[
              const TextSpan(text: '月亮湾高档小区在售'),
              TextSpan(text: '  1400套', style: Theme.of(context).textTheme.subtitle2),
            ],
          ),
        ),
        Gaps.vGap8,
        RichText(
          text: TextSpan(
            style: textTextStyle,
            children: <TextSpan>[
              const TextSpan(text: '皇城一号小区在售'),
              TextSpan(text: '  902套', style: Theme.of(context).textTheme.subtitle2),
            ],
          ),
        ),
        Gaps.vGap12,
        Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: textTextStyle,
                  children: <TextSpan>[
                    TextSpan(text: Utils.formatPrice('均价80000', format: MoneyFormat.NORMAL)),
                    TextSpan(text: '  共30023套', style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: Dimens.font_sp10)),
                  ],
                ),
              ),
            ),
            const Text(
              '2021.04.21 18:00',
              style: TextStyles.textSize12,
            ),
          ],
        ),
        Gaps.vGap8,
      ],
    );
  }

  Widget _buildEducation(BuildContext context){
    return Row(
      children: <Widget>[
        Text('$index'),
        Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage('http://allvectorlogo.com/img/2017/06/tsinghua-university-logo.png')
                )
            )
        ),
        Expanded(
            child:Container(
              height: 40.0,
              margin: EdgeInsets.only(left: 8.0, bottom: 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    child: new Text(
                      "清华大学",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Visibility(
                        // 默认为占位替换，类似于gone
                        //visible: ,
                        child: _GoodsItemTag(
                          text: '211 985',
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                      Opacity(
                        // 修改透明度实现隐藏，类似于invisible
                        opacity: 1.0,
                        child: _GoodsItemTag(
                          text: '综合学科',
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
        ),
      ],
    );
  }

  Widget _buildHispotail(BuildContext context){
    return Row(
      children: <Widget>[
        Text('$index'),
        Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(''))
            )
        ),
        Expanded(
            child:Container(
              height: 40.0,
              margin: EdgeInsets.only(left: 8.0, bottom: 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    child: new Text(
                      "北医三院",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Container(
                    child: Text(
                      '综合性3甲医院',
                      style: Theme.of(context).textTheme.subtitle2,
                      maxLines: 2,
                    ),
                  )
                ],
              ),
            )
        ),
      ],
    );
  }


  Widget _buildContent(BuildContext context) {
    final TextStyle textTextStyle = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: Dimens.font_sp12);
    final bool isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text('15000000000（郭李）'),
            ),
            Text(
              '货到付款',
              style: TextStyle(
                fontSize: Dimens.font_sp12,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
        Gaps.vGap8,
        Text(
          '西安市雁塔区 鱼化寨街道唐兴路唐兴数码3楼318',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Gaps.vGap8,
        Gaps.line,
        Gaps.vGap8,
        RichText(
          text: TextSpan(
            style: textTextStyle,
            children: <TextSpan>[
              const TextSpan(text: '清凉一度抽纸'),
              TextSpan(text: '  x1', style: Theme.of(context).textTheme.subtitle2),
            ],
          ),
        ),
        Gaps.vGap8,
        RichText(
          text: TextSpan(
            style: textTextStyle,
            children: <TextSpan>[
              const TextSpan(text: '清凉一度抽纸'),
              TextSpan(text: '  x2', style: Theme.of(context).textTheme.subtitle2),
            ],
          ),
        ),
        Gaps.vGap12,
        Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: textTextStyle,
                  children: <TextSpan>[
                    TextSpan(text: Utils.formatPrice('20.00', format: MoneyFormat.NORMAL)),
                    TextSpan(text: '  共3件商品', style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: Dimens.font_sp10)),
                  ],
                ),
              ),
            ),
            const Text(
              '2018.02.05 10:00',
              style: TextStyles.textSize12,
            ),
          ],
        ),
        Gaps.vGap8,
        Gaps.line,
        Gaps.vGap8,
        Row(
          children: <Widget>[
            OrderItemButton(
              key: Key('order_button_1_$index'),
              text: '联系客户',
              textColor: isDark ? Colours.dark_text : Colours.text,
              bgColor: isDark ? Colours.dark_material_bg : Colours.bg_gray,
              onTap: () => _showCallPhoneDialog(context, '15000000000'),
            ),
            const Expanded(
              child: Gaps.empty,
            ),
            OrderItemButton(
              key: Key('order_button_2_$index'),
              text: orderLeftButtonText[tabIndex],
              textColor: isDark ? Colours.dark_text : Colours.text,
              bgColor: isDark ? Colours.dark_material_bg : Colours.bg_gray,
              onTap: () {
                if (tabIndex >= 2) {
                  NavigatorUtils.push(context, '');
                }
              },
            ),
            if (orderRightButtonText[tabIndex].isEmpty) Gaps.empty else Gaps.hGap10,
            if (orderRightButtonText[tabIndex].isEmpty) Gaps.empty else OrderItemButton(
              key: Key('order_button_3_$index'),
              text: orderRightButtonText[tabIndex],
              textColor: isDark ? Colours.dark_button_text : Colors.white,
              bgColor: isDark ? Colours.dark_app_main : Colours.app_main,
              onTap: () {
                if (tabIndex == 2) {
                  _showPayTypeDialog(context);
                }
              },
            ),
          ],
        )
      ],
    );
  }

  void _showCallPhoneDialog(BuildContext context, String phone) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text('是否拨打：$phone ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => NavigatorUtils.goBack(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                //Utils.launchTelURL(phone);
                NavigatorUtils.goBack(context);
              },
              style: ButtonStyle(
                // 按下高亮颜色
                overlayColor: MaterialStateProperty.all<Color>(Theme.of(context).errorColor.withOpacity(0.2)),
              ),
              child: Text('拨打', style: TextStyle(color: Theme.of(context).errorColor),),
            ),
          ],
        );
      },
    );
  }

  void _showPayTypeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PayTypeDialog(
          onPressed: (index, type) {
            Toast.show('收款类型：$type');
          },
        );
      },
    );
  }

}


class OrderItemButton extends StatelessWidget {
  
  const OrderItemButton({
    Key key,
    this.bgColor,
    this.textColor,
    this.text,
    this.onTap
  }): super(key: key);
  
  final Color bgColor;
  final Color textColor;
  final GestureTapCallback onTap;
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        constraints: const BoxConstraints(
          minWidth: 64.0,
          maxHeight: 30.0,
          minHeight: 30.0,
        ),
        child: Text(text, style: TextStyle(fontSize: Dimens.font_sp14, color: textColor),),
      ),
      onTap: onTap,
    );
  }
}

class _GoodsItemTag extends StatelessWidget {

  const _GoodsItemTag({
    Key key,
    this.color,
    this.text,
  }): super(key: key);

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      margin: const EdgeInsets.only(right: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2.0),
      ),
      height: 16.0,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: Dimens.font_sp10,
        ),
      ),
    );
  }
}
