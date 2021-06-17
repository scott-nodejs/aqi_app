
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aqi/common/common.dart';
import 'package:flutter_aqi/res/resources.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/setting/widgets/exit_dialog.dart';
import 'package:flutter_aqi/setting/widgets/update_dialog.dart';
import 'package:flutter_aqi/utils/app_navigator.dart';
import 'package:flutter_aqi/widgets/my_app_bar.dart';
import 'package:flutter_aqi/widgets/click_item.dart';

import '../setting_router.dart';


/// design/8设置/index.html
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final String theme = SpUtil.getString(Constant.theme);
    String themeMode;
    switch(theme) {
      case 'Dark':
        themeMode = '开启';
        break;
      case 'Light':
        themeMode = '关闭';
        break;
      default:
        themeMode = '跟随系统';
        break;
    }

    final String locale = SpUtil.getString(Constant.locale);
    String localeMode;
    switch(locale) {
      case 'zh':
        localeMode = '中文';
        break;
      case 'en':
        localeMode = 'English';
        break;
      default:
        localeMode = '跟随系统';
        break;
    }

    return Scaffold(
      appBar: const MyAppBar(
        centerTitle: '设置',
      ),
      body: Column(
        children: <Widget>[
          Gaps.vGap5,
          ClickItem(
            title: '账号管理',
            onTap: () => NavigatorUtils.push(context, SettingRouter.accountManagerPage)
          ),
          ClickItem(
            title: '清除缓存',
            content: '23.5MB',
            onTap: _clear,
          ),
          ClickItem(
            title: '夜间模式',
            content: themeMode,
            onTap: () => NavigatorUtils.push(context, SettingRouter.themePage)
          ),
          ClickItem(
              title: '多语言',
              content: localeMode,
              onTap: () => NavigatorUtils.push(context, SettingRouter.localePage)
          ),
          ClickItem(
            title: '检查更新',
            onTap: _showUpdateDialog,
          ),
          ClickItem(
            title: '关于我们',
            onTap: () => NavigatorUtils.push(context, SettingRouter.aboutPage)
          ),
          ClickItem(
            title: '退出当前账号',
            onTap: _showExitDialog,
          ),
          // ClickItem(
          //   title: '其他Demo',
          //   onTap: () => AppNavigator.push(context, DemoPage()),
          // ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => const ExitDialog()
    );
  }

  void _clear() {
    showToast("清理缓存成功");
    SpUtil.remove(Constant.phone);
  }

  void _showUpdateDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UpdateDialog()
    );
  }
}
