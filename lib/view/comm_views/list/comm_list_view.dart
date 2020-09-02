import 'dart:convert';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/detail/detail_page.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:flutter_dev/view/comm_views/moudel/item_info.dart';
import 'package:flutter_dev/view/comm_views/moudel/page_info.dart';
import 'package:flutter_dev/view/main/home/grid_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommListView extends StatefulWidget {

  final EntryModel entryModel;
  CommListView(this.entryModel);

  @override
  State<StatefulWidget> createState() {
    return CommListViewState();
  }
}

class CommListViewState extends State<CommListView> {
  RefreshController mRefreshController = new RefreshController();
  ClassicFooter footer = new ClassicFooter();
  PageInfo pageInfo = PageInfo();
  DetailPageInfo detailPageInfo;
  List<ListViewItem> viewItems;
  @override
  void initState() {
    super.initState();
    viewItems = new List<ListViewItem>();
    detailPageInfo = DetailPageInfo();
    pageInfo.pageNumber=1;
    pageInfo.pageSize=10;
    initData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext listContext, bool flag) {
          return [
            SliverAppBar(
              pinned: true,
              title: Text(viewItems.length>0?viewItems[0].listTitle:""),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              actions: [
                IconButton(
//                  padding: EdgeInsets.only(right: 20),
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ];
        },
        body: Container(
          color: Colors.grey[200],
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(
              waterDropColor: Colors.blue,
            ),
            footer: footer,
            controller: mRefreshController,
            onRefresh: onRefresh,
            onLoading: onLoading,
            child: ListView.builder(
                itemCount: viewItems.length,
                padding: EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      onTap: () {
                        detailPageInfo.detailPageId=viewItems[index].detailPageId;
                        detailPageInfo.dataType=viewItems[index].dataType;
                        detailPageInfo.params=viewItems[index].params;
                        detailPageInfo.id=viewItems[index].itemListViewContent.id;
                        RouteUtils.pushPage(context, DetailPage(detailPageInfo));
                      },
                      child: IntrinsicHeight(
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: 60,
                          ),
                          child: Row(
                            children: [
                              Column(
                                children:[
                                  Container(
                                    height: 40,
                                    width: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8)),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                flex: 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Html(
                                        style: {"body":Style(alignment: Alignment.center,fontSize: FontSize.percent(130),color: Colors.black,fontWeight: FontWeight.w400)},
                                        data: viewItems[index].itemListViewContent.title,
                                      ),
                                      Offstage(
                                        offstage: viewItems[index].itemListViewContent.describe!=null?false:true,
                                        child: Html(
                                          style: {"body" : Style(fontSize: FontSize.percent(116),color:Colors.grey[800],),},
                                          data: viewItems[index].itemListViewContent.describe==null?"":viewItems[index].itemListViewContent.describe,
                                        ),
                                      ),
                                      Offstage(
                                        offstage: viewItems[index].itemListViewContent.note!=null?false:true,
                                        child: Html(
                                          style:{
                                            "body" : Style(
                                              fontSize: FontSize.percent(110),color: Colors.grey[400]
                                            ),
                                          },
                                          data: viewItems[index].itemListViewContent.note==null?"":viewItems[index].itemListViewContent.note,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Offstage(
                                offstage: viewItems[index].itemListViewContent.subTitle!=null?false:true,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 110,
                                  ),
                                  child: Html(
                                    data: viewItems[index].itemListViewContent.subTitle==null?"":viewItems[index].itemListViewContent.subTitle,
                                    style:{
                                      "body":Style(
                                      fontSize: FontSize.percent(130),color: Colors.blueAccent),
                                  },
                                  ),
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right,size: 24,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  onLoading() async {
    setState(() {
      pageInfo.pageNumber++;
    });
    await initData();
    mRefreshController.loadComplete();
    mRefreshController.loadNoData();
  }

  onRefresh() async {
    setState(() {
      pageInfo.pageNumber=1;
    });
    await initData();
    mRefreshController.refreshCompleted();
  }
  Future<String> decodeStringFromAssets(String path) async {
    ByteData byteData = await PlatformAssetBundle().load(path);
    String htmlString = String.fromCharCodes(byteData.buffer.asUint8List());
    return htmlString;
  }

  initData() async {
    var baseMap = DataHelper.getBaseMap();
    baseMap.clear();///8aUUVC4cbmHyy6+2yB+/2A==
    Map<String, dynamic> user = StorageUtils.getModelWithKey("userInfo");
    if(null != user){
      debugPrint("page:"+widget.entryModel.toPage);
      debugPrint("user:"+user.toString());
      baseMap['toPage']=widget.entryModel.toPage;
      baseMap['pageSize']=pageInfo.pageSize;
      baseMap['pageNumber']=pageInfo.pageNumber;
      baseMap['yhxtm']=user['yhxtm'];
      if(widget.entryModel.params != null){
        baseMap.addAll(widget.entryModel.params);
      }

      ResultData result = await HttpManager.getInstance().get(Address.MenuItemUrl, baseMap);
      if(result.code == 200){
        debugPrint("data:"+result.data);
        List json = jsonDecode(result.data);

        json.forEach((element) {
          viewItems.add(ListViewItem.fromJson(element));
        });

        debugPrint("viewItems:"+viewItems[0].icon);
        setState(() {

        });
      }else{
        setState(() {

        });
        CommUtils.showDialog(context, "提示", "${result.data}", false,
            okOnPress: () {});
      }
    }else{
//      CommUtils.showDialog(context, "提示", "登录信息过期,请重新登录", false,
//          okOnPress: () {});
    }

  }

}
