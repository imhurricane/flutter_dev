import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_dev/view/main/item/home_item_page_sort.dart';

class ListViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomScrollViewTestRoute();
  }
}

class CustomScrollViewTestRoute extends State
    with SingleTickerProviderStateMixin {
  List<String> tabListTitle = [
    "推荐",
    "动态",
    "Java",
    "程序人生",
    "移动开发",
    "程序感言",
    "移动算法"
  ];
  TabController mTabController;
  List<Widget> bodyPageList = [];

  @override
  void initState() {
    super.initState();
    mTabController =
        new TabController(length: tabListTitle.length, vsync: this);
    for (int i = 0; i < tabListTitle.length; i++) {
      bodyPageList.add(new HomeItemPageSort(i, tabListTitle[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    //因为本路由没有使用Scaffold，为了让子级Widget(如Text)使用
    //Material Design 默认的样式风格,我们使用Material作为本路由的根。
    return MaterialApp(
//      theme: ThemeData.dark(),
      home: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context11, bool flag) {
            return <Widget>[
              //AppBar，包含一个导航栏
              SliverAppBar(
                leading: GestureDetector(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () => Navigator.pop(context),
                ),
                //左侧按钮
                // title: Text('大标题'), //标题
                centerTitle: true,
                //标题是否居中
                actions: [Icon(Icons.add)],
                //右侧的内容和点击事件啥的
                title: Text("sdwdw"),
                elevation: 4,
                //阴影的高度
                forceElevated: false,
                //是否显示阴影
                backgroundColor: Colors.blue,
                //背景颜色
                brightness: Brightness.dark,
                //黑底白字，lignt 白底黑字
                iconTheme:
                    IconThemeData(color: Colors.white, size: 30, opacity: 1),
                //所有的icon的样式,不仅仅是左侧的，右侧的也会改变
                textTheme: TextTheme(),
                //字体样式
                primary: true,
                // appbar是否显示在屏幕的最上面，为false是显示在最上面，为true就显示在状态栏的下面
                titleSpacing: 16,
                //标题两边的空白区域
                expandedHeight: 280.0,
                //默认高度是状态栏和导航栏的高度，如果有滚动视差的话，要大于前两者的高度
                floating: false,
                //滑动到最上面，再滑动是否隐藏导航栏的文字和标题等的具体内容，为true是隐藏，为false是不隐藏
                pinned: true,
                //是否固定导航栏，为true是固定，为false是不固定，往上滑，导航栏可以隐藏
                snap: false,
                //只跟floating相对应，如果为true，floating必须为true，也就是向下滑动一点儿，整个大背景就会动画显示全部，网上滑动整个导航栏的内容就会消失
                flexibleSpace: FlexibleSpaceBar(
//                title: Text('Demo'),
                  centerTitle: true,
                  collapseMode: CollapseMode.pin,
                  background: buildChart(context),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  controller: mTabController,
                  tabs: tabListTitle
                      .map(
                        (String title) => Tab(
                          text: title,
                        ),
                      )
                      .toList(),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: bodyPageList,
            controller: mTabController,
          ),
        ),
      ),
    );
  }

  buildChart(context) {
    List<Barsales> dataBar = [
      new Barsales(tabListTitle[0], 20),
      new Barsales(tabListTitle[1], 50),
      new Barsales(tabListTitle[2], 20),
      new Barsales(tabListTitle[3], 80),
      new Barsales(tabListTitle[4], 120),
      new Barsales(tabListTitle[5], 30),
      new Barsales(tabListTitle[6], 50),
    ];

    var seriesBar = [
      charts.Series(
        data: dataBar,
//        areaColorFn: (_, __) => charts.MaterialPalette.white,
//        colorFn: (_, __) => charts.MaterialPalette.white,
        seriesColor: charts.MaterialPalette.purple.shadeDefault,
        domainFn: (Barsales sales, _) => sales.day,
        measureFn: (Barsales sales, _) => sales.sale,
        id: "Sales",
      )
    ];
    return Container(
//      color: Colors.white,
//      padding: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.),
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).viewInsets.top + 60, bottom: 50),
      child: charts.BarChart(
        seriesBar,
      ),
    );
  }
}

class Barsales {
  String day;
  int sale;

  Barsales(this.day, this.sale);
}

class Linesales {
  DateTime time;
  int sale;

  Linesales(this.time, this.sale);
}
