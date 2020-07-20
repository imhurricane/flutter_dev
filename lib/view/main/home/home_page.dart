

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'home_item_page.dart';

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

  @override
  void initState() {
    super.initState();
    redCach();
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
        body: HomeItemPage(),
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

  redCach() async {
    await SpUtil.getInstance();
  }
}
