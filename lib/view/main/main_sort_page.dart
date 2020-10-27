import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'item/home_item_page_sort.dart';
class MainSortPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainSortPageState();
  }
}

class MainSortPageState extends State<MainSortPage>
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
  List<String> imageList = ["img0.jpg", "img1.jpg", "img2.jpg", "img3.jpg"];
  TabController mTabController;
  List<Widget> bodyPageList = [];

  bool isShow = false;

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
    if(isShow){
      return Scaffold(
        body: NestedScrollViewRefreshIndicator(
          onRefresh: refresh,
          child: buildBody(),
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("待开发"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Text("敬请期待"),
        ),
      );
    }

  }

  Future refresh() async {
    return Future.delayed(Duration(milliseconds: 3000));
  }

  Widget buildBanner() {
    return Container(
      height: 200,
      child: Swiper(
//        pagination: new SwiperPagination(),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 200,
            child: Image.asset(
              "resources/images/${imageList[index]}",
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }

  buildBody() {
    return extended.NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool flag) {
        return [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: buildBanner(),
            ),
//            actions: [IconButton(
//                icon: Icon(
//                  Icons.add_circle,
//                ),
//                onPressed: () {
//                  print("点击了加号");
//                },
//              )
//            ],
//            title: Material(
//              color: Colors.white,
//              borderRadius: BorderRadius.all(Radius.circular(6)),
//              child: Ink(
//                child: InkWell(
//                  onTap: () {
//                    print("点击了搜索框");
//                  },
//                  borderRadius: BorderRadius.all(Radius.circular(6)),
//                  splashColor: Colors.grey[100],
//                  child: Container(
//                    height: 33,
//                    child: Row(
//                      children: [
//                        Expanded(
//                          flex: 1,
//                          child: Icon(
//                            Icons.search,
//                            size: 18,
//                            color: Colors.grey[600],
//                          ),
//                        ),
//                        Expanded(
//                          flex: 5,
//                          child: Text(
//                            "搜索",
//                            style: TextStyle(
//                                fontSize: 14, color: Colors.grey[600]),
//                          ),
//                        ),
//                        Expanded(
//                          flex: 1,
//                          child: IconButton(
//                            icon: Icon(
//                              Icons.settings_voice,
//                              size: 16,
//                              color: Colors.grey[600],
//                            ),
//                            onPressed: () {
//                              print("点击了语音按钮");
//                            },
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ),
            bottom: TabBar(
              isScrollable: true,
              controller: mTabController,
              tabs: tabListTitle.map((String title) =>
                  Tab(text: title,),).toList(),
            ),
          )
        ];
      },
      body: TabBarView(
        children: bodyPageList,
        controller: mTabController,
      ),
    );
  }
}
