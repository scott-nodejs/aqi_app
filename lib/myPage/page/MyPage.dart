import 'package:flutter/material.dart';
import 'package:flutter_aqi/common/common.dart';
import 'package:flutter_aqi/mvp/base_page.dart';
import 'package:flutter_aqi/myPage/models/user_entity.dart';
import 'package:flutter_aqi/myPage/presenter/my_presenter.dart';
import 'package:flutter_aqi/res/resources.dart';
import 'package:flutter_aqi/routers/fluro_navigator.dart';
import 'package:flutter_aqi/setting/setting_router.dart';
import 'package:flutter_aqi/myPage/iview/my_iview.dart';
import 'package:flutter_aqi/myPage/provider/user_provider.dart';
import 'package:flutter_aqi/setting/widgets/exit_dialog.dart';
import 'package:flutter_aqi/setting/widgets/update_dialog.dart';
import 'package:flutter_aqi/shop/shop_router.dart';
import 'package:flutter_aqi/utils/image_utils.dart';
import 'package:flutter_aqi/utils/theme_utils.dart';
import 'package:flutter_aqi/widgets/click_item.dart';
import 'package:flutter_aqi/widgets/load_image.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

/// design/6店铺-账户/index.html#artboard0
class MyPage extends StatefulWidget {

  const MyPage({
    Key key,
    this.isAccessibilityTest = false,
  }) : super(key : key);

  final bool isAccessibilityTest;

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin<MyPage>{

  final List<String> _menuTitle = ['账户流水', '资金管理', '提现账号'];
  final List<String> _menuImage = ['zhls', 'zjgl', 'txzh'];
  final List<String> _menuDarkImage = ['dark_zhls', 'dark_zjgl', 'dark_txzh'];

  UserProvider provider = UserProvider();

  @override
  bool get isAccessibilityTest => widget.isAccessibilityTest;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Color _iconColor = ThemeUtils.getIconColor(context);
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
    final Widget line = Container(
      height: 0.6,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16.0),
      child: Gaps.line,
    );
    return ChangeNotifierProvider<UserProvider>(
      create: (_) => provider,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              tooltip: '消息',
              onPressed: () {
                NavigatorUtils.push(context, ShopRouter.messagePage);
              },
              icon: LoadAssetImage(
                'shop/message',
                key: const Key('message'),
                width: 24.0,
                height: 24.0,
                color: _iconColor,
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Gaps.vGap12,
            Consumer<UserProvider>(
              builder: (_, provider, child) {
                final Widget header = Stack(
                  children: <Widget>[
                    const SizedBox(width: double.infinity, height: 56.0),
                    const Text(
                      '模糊笔记',
                      style: TextStyles.textBold24,
                    ),
                    Positioned(
                      right: 0.0,
                      child: CircleAvatar(
                        radius: 28.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage: ImageUtils.getImageProvider(provider.user?.avatarUrl, holderImg: 'shop/tx'),
                      ),
                    ),
                    child,
                  ],
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MergeSemantics(
                    child: header,
                  ),
                );
              },
              child: Positioned(
                top: 38.0,
                left: 0.0,
                child: Row(
                  children: const <Widget>[
                    LoadAssetImage('shop/zybq', width: 40.0, height: 16.0,),
                    Gaps.hGap8,
                    Text('模糊笔记', style: TextStyles.textSize12)
                  ],
                ),
              ),
            ),
            Gaps.vGap24,
            line,
            Gaps.vGap10,
            ClickItem(
                title: '账号管理',
                onTap: () => NavigatorUtils.push(context, SettingRouter.accountManagerPage)
            ),
            ClickItem(
                title: '清除缓存',
                content: '23.5MB',
                onTap: () {}
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
          ],
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog<void>(
        context: context,
        builder: (_) => const ExitDialog()
    );
  }

  void _showUpdateDialog() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => UpdateDialog()
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  MyPagePresenter createPresenter() => MyPagePresenter();



}

class _ShopFunctionModule extends StatelessWidget {

  const _ShopFunctionModule({
    Key key,
    this.onItemClick,
    @required this.data,
    @required this.image,
    @required this.darkImage,
  }): super(key: key);

  final Function(int index) onItemClick;
  final List<String> data;
  final List<String> image;
  final List<String> darkImage;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 12.0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.18,
      ),
      itemCount: data.length,
      itemBuilder: (_, index) {
        return InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoadAssetImage(context.isDark ? 'shop/${darkImage[index]}' : 'shop/${image[index]}', width: 32.0),
              Gaps.vGap4,
              Text(
                data[index],
                style: TextStyles.textSize12,
              )
            ],
          ),
          onTap: () {
            onItemClick(index);
          },
        );
      },
    );
  }
}

