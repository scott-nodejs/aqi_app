
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:event_bus/event_bus.dart';
// import 'package:flutter_statusbar/flutter_statusbar.dart';


class CommonUtils {
  static const DEBUG = true;

  static const TOKEN_KEY = "accessToken";

  static const USER_INFO = "userInfo";

  static const USER_DTO = "user_dto";

  static const Local_Icon_prefix = "assets/images/";

  static const QRCode_Prefix = "https://lizhiketang.com/";

  static const TOTAL_COUNT = "totalCount";

  static const LIKE_COUNT = "likeCount";

  static const ATTENTION_COUNT = "attentionCount";

  static const COMMENT_COUNT = "commentCount";

  static final EventBus eventBus = new EventBus();

  static String coverPath(id,style) {
    return "http://cover.lizhiketang.com/$style/$id.webp";
  }

  static String avatarPath(id) {
    return "http://avatar.lizhiketang.com/$id.jpg";
  }

  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new Material(
          color: Colors.transparent,
          child: WillPopScope(
            onWillPop: () => new Future.value(false),
            child: Center(
              child: new CupertinoActivityIndicator(),              
            )
          )
        );
      }
    );
  }

  static openPage(BuildContext context, Widget widget) {
    return Navigator.push(context, new CupertinoPageRoute(builder: (context) => widget));
  }

  static closePage(BuildContext context) {
    Navigator.pop(context);
  }

  static bool sStaticUserIsLogin = false;

  static bool isChinaPhoneLegal(String str) {
    return new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$').hasMatch(str);
  }
}