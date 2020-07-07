import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeItemPageSort extends StatefulWidget {
  num pageIndex;
  String pageTitle;

  HomeItemPageSort(this.pageIndex, this.pageTitle);

  @override
  State<StatefulWidget> createState() {
    return HomeItemPageSortState();
  }
}

class HomeItemPageSortState extends State<HomeItemPageSort> {
//  List<String> imageList = ["img0.jpg", "img1.jpg", "img2.jpg", "img3.jpg"];
  RefreshController mRefreshController = new RefreshController();
  ClassicFooter footer = new ClassicFooter();

  @override
  Widget build(BuildContext context) {
//    Widget bannerWidget = buildBanner();
    return Container(
      color: Colors.grey[100],
      child: buildListView(),);
  }

  Widget buildListView() {
    return ListView.builder(
        padding: EdgeInsets.only(
          top: 0,
        ),
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 110,
            padding: EdgeInsets.only(left: 5, right: 5),
            margin: EdgeInsets.only(top: 3),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "标题",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "伊朗向美国总统特朗普发出逮捕令，请求国际刑警组织协助逮捕，据美联社报道，国际刑警组织..",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      "万年程序狗",
                      style: TextStyle(fontSize: 12, color: Colors.black38),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.thumb_up,
                      size: 14,
                      color: Colors.black26,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "20",
                      style: TextStyle(fontSize: 12, color: Colors.black38),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.share,
                      size: 14,
                      color: Colors.black38,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "120",
                      style: TextStyle(fontSize: 12, color: Colors.black38),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  onLoading() async {
    Future.delayed(Duration(milliseconds: 3000), () {
      mRefreshController.loadComplete();
      mRefreshController.loadNoData();
    });
  }

  onRefresh() async {
    Future.delayed(Duration(milliseconds: 3000), () {
      mRefreshController.refreshCompleted();
    });
  }
}
