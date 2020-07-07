import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/base/base_widget.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/login/login_page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'home_item_page.dart';
import '../item/home_item_page_sort.dart';
import 'item_home.dart';

class MainHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainHomePageState();
  }
}

class MainHomePageState extends State<MainHomePage>
    with SingleTickerProviderStateMixin {
  List<Widget> bodyPageList = [];
  List<String> imageList = ["img0.jpg", "img1.jpg", "img2.jpg", "img3.jpg"];

  List<ItemHome> itemHomes = new List();

  @override
  void initState() {
    super.initState();
    redCach();
    initData();
  }
  initData(){
    print("asdsadsa");
    for (int i = 0; i < 5; i++) {
      if(i==0){
        Map<String,String> gridItem = Map();
        gridItem["icon"]="";
        gridItem["title"]="";
        List<Map<String,String>> gridItems = new List<Map<String,String>>();
        gridItems.add(gridItem);
        ItemHome itemHome = ItemHome.grid(ViewType.gridView,gridItems);
        itemHomes.add(itemHome);
      }else{
        itemHomes.add(new ItemHome.report(ViewType.reportView,new List()));
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool flag) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: buildBanner(),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                  ),
                  onPressed: () {
                    print("点击了加号");
                  },
                )
              ],
              title: Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: Ink(
                  child: InkWell(
                    onTap: () {
                      print("点击了搜索框");
                    },
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    splashColor: Colors.grey[100],
                    child: Container(
                      height: 33,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.search,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              "搜索",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(
                                Icons.settings_voice,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                print("点击了语音按钮");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: HomeItemPage(itemHomes),
      ),
    );
  }

  Widget buildBanner() {
    return Container(
      height: 200,
      child: Swiper(
        pagination: new SwiperPagination(),
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

  redCach() async{
    await SpUtil.getInstance();
  }

}
