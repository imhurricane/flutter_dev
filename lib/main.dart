
import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dev/view/index/index_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  runApp(new RootApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
//        statusBarBrightness: Brightness.light,
//        statusBarIconBrightness: Brightness.dark
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    print("systemUiOverlayStyle");
  }
}

class RootApp extends StatefulWidget{
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  final List<Permission> permissions = [Permission.storage,Permission.camera,Permission.location,Permission.photos,Permission.calendar];

  @override
  State<StatefulWidget> createState() {
    return RootAppState();
  }

}

class RootAppState extends State<RootApp> {

  @override
  void initState() {
    super.initState();
    initPermission();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [RootApp.routeObserver],
      home: IndexPage(),
      builder: (context, widget) {
        return MediaQuery(
          //设置文字大小不随系统设置改变
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget,
        );
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        RefreshLocalizations.delegate,
      ],
      //当前语言环境
      locale: Locale("zh","CH"),
      supportedLocales: [
        const Locale("en","US"),
        const Locale("he","IL"),
        const Locale("zh","CH"),
      ],

    );
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
    });
  }

  initPermission() async{

    for(int i=0;i<widget.permissions.length;i++){
      await requestPermission(widget.permissions[i]);
    }

  }

}

