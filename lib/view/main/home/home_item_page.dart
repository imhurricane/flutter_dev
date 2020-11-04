import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/monitor_network_utils.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:flutter_dev/main.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/page_loading.dart';
import 'package:flutter_dev/view/comm_views/detail/detail_page.dart';
import 'package:flutter_dev/view/comm_views/list/comm_list_view.dart';
import 'package:flutter_dev/view/comm_views/list/second_menu.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';
import 'package:flutter_dev/view/comm_views/offline/download_page.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/riss_complete.dart';
import 'package:flutter_dev/view/comm_views/offline/task_list.dart';
import 'package:flutter_dev/view/comm_views/offline/task_upload.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:flutter_dev/view/main/home/grid_item.dart';
import 'package:flutter_dev/view/main/home/item_home.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'entry_model.dart';

class HomeItemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeItemPageState();
  }
}

class HomeItemPageState extends State<HomeItemPage> with RouteAware{
//  List<String> imageList = ["img0.jpg", "img1.jpg", "img2.jpg", "img3.jpg"];
  RefreshController mRefreshController = new RefreshController();
  ClassicFooter footer = new ClassicFooter();
  List<ItemHome> itemHomes = new List();
  bool network = true;
  List<EntryModel> entryModels = new List();

  List<RissComplete> mRissCompleteList;

  @override
  void initState() {
    super.initState();
    mRissCompleteList = List();
    initData();
  }

  initData() async {
    network = await MonitorNetworkUtils.isNetwork();
    LoginUser user =
        LoginUser.fromJson(StorageUtils.getModelWithKey("userInfo"));
    if (network) {
      var baseMap = DataHelper.getBaseMap();
      baseMap.clear();
      baseMap['menuId'] = Address.MENU_ID;
//    baseMap['']="";
      ResultData result =
          await HttpManager.getInstance().get(Address.HOME_URL, baseMap);
      if (result.code != 200) {
        CommUtils.showDialog(context, "提示", result.data, false,
            okOnPress: () {});
        initOfflineMenu(user);
      } else {
        Map<String, dynamic> json = jsonDecode(result.data);

        ItemGrid itemGrid = ItemGrid.fromJson(json);
        debugPrint("json:" + result.data);
        entryModels = itemGrid.entryModels;
        Map<String, String> gridItem = Map();
        List<Map<String, String>> gridItems = new List<Map<String, String>>();
        gridItems.add(gridItem);
        ItemHome itemHome = ItemHome.grid(ViewType.gridView, gridItems);
        itemHomes.clear();
        itemHomes.add(itemHome);
        List<EntryModel> newEntryModels = new List();
//        LoginUser user =
//            LoginUser.fromJson(StorageUtils.getModelWithKey("userInfo"));
//        print("userPermission:" + user.toJson().toString());
//        entryModels.forEach((element) {
//          print("permission:" + element.permission);
//          if (user.permission.containsKey(element.permission)) {
//            newEntryModels.add(element);
//          }
//        });
//        print('newEntryModels:'+newEntryModels[0].toJson().toString());
        StorageUtils.saveModel("menu", itemGrid);
        initCompleteTask();
        setState(() {});
      }
    } else {
      initOfflineMenu(user);
    }
  }

  initOfflineMenu(LoginUser user){
    entryModels.clear();
    ItemGrid itemGrid =
    ItemGrid.fromJson(StorageUtils.getModelWithKey("menu"));
    List<EntryModel> entryModelsTemp = itemGrid.entryModels;
    for (int i = 0; i < entryModelsTemp.length; i++) {
      if (user.permission.containsKey(entryModelsTemp[i].permission)) {
        entryModels.add(entryModelsTemp[i]);
      }
    }
    Map<String, String> gridItem = Map();
    List<Map<String, String>> gridItems = new List<Map<String, String>>();
    gridItems.add(gridItem);
    ItemHome itemHome = ItemHome.grid(ViewType.gridView, gridItems);
    itemHomes.clear();
    itemHomes.add(itemHome);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ///网络获取数据
    return buildBody();
  }

  buildBody() {
    if (itemHomes != null && itemHomes.length > 0) {
      return Container(
        height: MediaQuery.of(context).size.height,
//      padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        color: Colors.grey[100],
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
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
    } else {
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
                    if (entryModels[index]?.dataType != null) {
                      if (entryModels[index]?.dataType == "LIST") {
                        RouteUtils.pushPage(
                            context, CommListView(entryModels[index]));
                      } else if (entryModels[index]?.dataType == "DETAIL") {
                        DetailPageInfo detailPageInfo = DetailPageInfo()
                          ..params = entryModels[index].params
                          ..dataType = entryModels[index].dataType
                          ..detailPageId = entryModels[index].toPage;
                        RouteUtils.pushPage(
                            context, DetailPage(detailPageInfo));
                      }
                    } else if (entryModels[index]?.secondLevel != null &&
                        entryModels[index].secondLevel) {
                      RouteUtils.pushPage(
                          context, SecondMenu(entryModels[index]));
                    } else {
                      //  离线菜单
                      if (entryModels[index].id == "teak_download") {
                        RouteUtils.pushPage(context, DownloadPage());
                      } else if (entryModels[index].id == "task_check") {
                        RouteUtils.pushPage(context, TaskListPage());
                      } else if (entryModels[index].id == "task_upload") {
                        RouteUtils.pushPage(context, UploadTaskPage());
                      } else if (entryModels[index].id == "task_statistics") {
                        print('任务统计');
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey[300],
                          ),
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Stack(
                            children: [
                              Align(
                                child: network
                                    ? Image.network(
                                  "${Address.BaseImageURL + entryModels[index].icon}",
                                  width: 44,
                                  height: 44,
                                  alignment: Alignment.center,
                                )
                                    : Image.asset(
                                    "resources/images${entryModels[index].icon.substring(entryModels[index].icon.lastIndexOf("/"))}",
                                    width: 44,
                                    height: 44,
                                    alignment: Alignment.center,
                                ),
                                alignment: Alignment.topCenter,
                              ),
                              if(entryModels[index].id == "task_upload" && mRissCompleteList.length>0)
                              Align(
                                alignment: Alignment.topRight,
                                  child: Container(
                                    width: 14,
                                    height: 14,
//                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(color: Colors.red),
                                    ),
                                    child: Container(),
//                                    Text(mRissCompleteList.length.toString()+"",style: TextStyle(color: Colors.white,fontSize: 12),),
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${entryModels[index].title}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 监听路由
    RootApp.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    super.didPopNext();
    // 当从其他页面返回当前页面时出发此方法
    initCompleteTask();
  }

  initCompleteTask() async{
    RissCompleteProvider rissCompleteProvider = RissCompleteProvider();
    mRissCompleteList = await rissCompleteProvider.selectRissByIsUpload("0");
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didPop() {
    super.didPop();
    mRissCompleteList = null;
  }

}
