import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/page_loading.dart';
import 'package:flutter_dev/view/comm_views/detail/detail_page.dart';
import 'package:flutter_dev/view/comm_views/list/CustomScrollViewTestRoute.dart';
import 'package:flutter_dev/view/comm_views/list/comm_list_view.dart';
import 'package:flutter_dev/view/comm_views/list/second_menu.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';
import 'package:flutter_dev/view/main/home/grid_item.dart';
import 'package:flutter_dev/view/main/home/item_home.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeItemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeItemPageState();
  }
}

class HomeItemPageState extends State<HomeItemPage> {
//  List<String> imageList = ["img0.jpg", "img1.jpg", "img2.jpg", "img3.jpg"];
  RefreshController mRefreshController = new RefreshController();
  ClassicFooter footer = new ClassicFooter();
  List<ItemHome> itemHomes = new List();

  List<EntryModel> entryModels = new List();



  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    var baseMap = DataHelper.getBaseMap();
    baseMap.clear();
    baseMap['menuId'] = Address.MENU_ID;
//    baseMap['']="";
    ResultData result =
    await HttpManager.getInstance().get(Address.HOME_URL, baseMap);
    if(result.code != 200){
      CommUtils.showDialog(context, "提示", result.data, false,
          okOnPress: () {});
    }else{
      Map<String, dynamic> json = jsonDecode(result.data);

      ItemGrid itemGrid = ItemGrid.fromJson(json);
      debugPrint("json:"+result.data);
      entryModels = itemGrid.entryModels;
      Map<String, String> gridItem = Map();
      List<Map<String, String>> gridItems = new List<Map<String, String>>();
      gridItems.add(gridItem);
      ItemHome itemHome = ItemHome.grid(ViewType.gridView, gridItems);
      itemHomes.clear();
      itemHomes.add(itemHome);
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {
    ///网络获取数据
    return buildBody();
  }

  buildBody(){
    if(itemHomes!=null && itemHomes.length>0){
      return Container(
        height: MediaQuery.of(context).size.height,
//      padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        color: Colors.grey[100],
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
    }else{
      return PageLoading();
    }
  }

  Widget buildListView() {
    return ListView.builder(
        itemCount: itemHomes.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.grey[100],
            child: buildItem(itemHomes[index]),
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
    Future.delayed(Duration(milliseconds: 500), () {
      initData();
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
      color: Colors.grey[50],
      child: GridView.builder(
          itemCount: entryModels.length,
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
                    if(entryModels[index].secondLevel == null || !entryModels[index].secondLevel){
                      if(entryModels[index]?.dataType=="LIST"){
                        RouteUtils.pushPage(context, CommListView(entryModels[index]));
                      }else if(entryModels[index]?.dataType=="DETAIL"){
                        DetailPageInfo detailPageInfo = DetailPageInfo()
                          ..params = entryModels[index].params
                          ..dataType = entryModels[index].dataType
                          ..detailPageId = entryModels[index].toPage;
                        print("detailPageInfo:"+detailPageInfo.toJson().toString());
                        RouteUtils.pushPage(context, DetailPage(detailPageInfo));
                      }
                    }else{
                      RouteUtils.pushPage(context, SecondMenu(entryModels[index]));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey[300],
                      ),
                    ]
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.network(
                            "${Address.BaseImageURL + entryModels[index].icon}",
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "${entryModels[index].title}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
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
