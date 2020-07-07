import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/view/main/home/item_home.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeItemPage extends StatefulWidget {
  final List<ItemHome> itemHomes;

  HomeItemPage(this.itemHomes);

  @override
  State<StatefulWidget> createState() {
    return HomeItemPageState();
  }
}

class HomeItemPageState extends State<HomeItemPage> {
//  List<String> imageList = ["img0.jpg", "img1.jpg", "img2.jpg", "img3.jpg"];
  RefreshController mRefreshController = new RefreshController();
  ClassicFooter footer = new ClassicFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
//      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      color: Colors.grey[300],
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(
          waterDropColor: Colors.blue,
        ),
        footer: footer,
        child: buildListView(),
        controller: mRefreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
      ),
    );
  }

  Widget buildListView() {
    return ListView.builder(
        itemCount: widget.itemHomes.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.grey[100],
            child: buildItem(widget.itemHomes[index]),
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

  buildItem(ItemHome itemHom) {
    switch (itemHom.viewType) {
      case ViewType.gridView:
        return buildGridWidget();
        break;
      case ViewType.reportView:
        return buildMsgWidget();
        break;
      default:
        break;
    }
  }

  buildGridWidget() {
    return Container(
      margin: EdgeInsets.all(5),
      child: GridView.builder(
          itemCount: 9,
          primary: false,
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: Colors.grey[100],
              child: Ink(
                child: InkWell(
                  onTap: () {
                    print("sadas");
                  },
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "resources/images/logo.png",
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                        ),
                        Center(
                          child: Text(
                            "测试",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  buildMsgWidget() {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5,left: 10,right: 10),
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(13),
//        color: Colors.red,
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
      ),
    );
  }
}
