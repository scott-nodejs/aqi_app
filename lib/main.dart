import 'package:amap_location/amap_location.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aqi/home/home_page.dart';
import 'package:flutter_aqi/localization/app_localizations.dart';
import 'package:flutter_aqi/provider/locale_provider.dart';
import 'package:flutter_aqi/provider/theme_provider.dart';
import 'package:flutter_aqi/routers/not_found_page.dart';
import 'package:flutter_aqi/routers/routers.dart';
import 'package:flutter_aqi/utils/device_utils.dart';
import 'package:flutter_aqi/utils/log_utils.dart';
import 'package:flutter_aqi/utils/toast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'home/splash_page.dart';
import 'net/dio_utils.dart';
import 'net/intercept.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// sp初始化
  await SpUtil.getInstance();
  runApp(MyApp());
  if (Device.isAndroid) {
    const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {

  MyApp({this.home, this.theme}) {
    startPosition();//开启位置
    Log.init();
    initDio();
    Routes.initRoutes();
  }

  void initDio() {
    final List<Interceptor> interceptors = <Interceptor>[];
    /// 统一添加身份验证请求头
    //interceptors.add(AuthInterceptor());
    /// 刷新Token
    //interceptors.add(TokenInterceptor());
    /// 打印Log(生产模式去除)
    // if (!Constant.inProduction) {
    //   interceptors.add(LoggingInterceptor());
    // }
    /// 适配数据(根据自己的数据结构，可自行选择添加)
    interceptors.add(AdapterInterceptor());
    configDio(
      baseUrl: 'http://10.90.128.67:9090/client/api/',
      interceptors: interceptors,
    );
  }

  startPosition()async{
    await AMapLocationClient.startup(new AMapLocationOption( desiredAccuracy:CLLocationAccuracy.kCLLocationAccuracyHundredMeters  ));
  }

  @override
  void dispose() {
    //这里可以停止定位
    AMapLocationClient.stopLocation();
  }

  final Widget home;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => LocaleProvider())
          ],
          child: Consumer2<ThemeProvider, LocaleProvider>(
            builder: (_, ThemeProvider provider, LocaleProvider localeProvider, __) {
              return MaterialApp(
                title: 'Flutter Deer',
//              showPerformanceOverlay: true, //显示性能标签
//              debugShowCheckedModeBanner: false, // 去除右上角debug的标签
//              checkerboardRasterCacheImages: true,
//              showSemanticsDebugger: true, // 显示语义视图
//              checkerboardOffscreenLayers: true, // 检查离屏渲染
                theme: theme ?? provider.getTheme(),
                darkTheme: provider.getTheme(isDarkMode: true),
                themeMode: provider.getThemeMode(),
                home: home ?? SplashPage(),
                onGenerateRoute: Routes.router.generator,
                localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                  AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: localeProvider.supportedLocales,
                locale: localeProvider.locale,
                builder: (BuildContext context, Widget child) {
                  /// 保证文字大小不受手机系统设置影响 https://www.kikt.top/posts/flutter/layout/dynamic-text/
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child,
                  );
                },
                /// 因为使用了fluro，这里设置主要针对Web
                onUnknownRoute: (_) {
                  return MaterialPageRoute<void>(
                    builder: (BuildContext context) => NotFoundPage(),
                  );
                },
              );
            },
          ),
        ),
        /// Toast 配置
        backgroundColor: Colors.black54,
        textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        radius: 20.0,
        position: ToastPosition.bottom
    );
  }
}
