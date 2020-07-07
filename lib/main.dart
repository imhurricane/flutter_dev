

import 'package:flutter/material.dart';
import 'package:flutter_dev/view/index/index_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



void main() => runApp(new RootApp());

class RootApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RootAppState();
  }

}

class RootAppState extends State<RootApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IndexPage(),
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
}

