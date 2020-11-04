import 'dart:convert';
import 'dart:ui';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/page_loading.dart';
import 'package:flutter_dev/view/comm_views/detail/detail_page.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';
import 'package:flutter_dev/view/main/home/entry_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
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
  String pageTitle = "";

  @override
  void initState() {
    super.initState();
    viewItems = new List<ListViewItem>();
    detailPageInfo = DetailPageInfo();
    pageInfo.pageNumber=1;
    pageInfo.pageSize=10;
    initPageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext listContext, bool flag) {
          return [
            SliverAppBar(
              pinned: true,
              title: Text(pageTitle,style: TextStyle(fontSize: 20,),),
              centerTitle: true,
              leading: IconButton(
                alignment: Alignment.center,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              actions: [
                IconButton(
                  alignment: Alignment.center,
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
            child: buildBody(),
          ),
        ),
      ),
    );
  }

  buildBody(){
    if(buildBody != null && viewItems.length>0){
      return ListView.builder(
          itemCount: viewItems.length,
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return buildListItem(index);
          });
    }else{
      return PageLoading(
//        textStyle: TextStyle(color: Colors.red),
      );
    }

  }

  buildListItem(int index){
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
          if(viewItems[index].dataType=="LIST"){
//            widget.entryModel.dataType=viewItems[index].dataType;
//            widget.entryModel.toPage=viewItems[index].detailPageId;
            EntryModel temp = EntryModel()
              ..toPage = viewItems[index].detailPageId
              ..dataType = viewItems[index].dataType
              ..title = widget.entryModel.title
              ..params = widget.entryModel.params
              ..secondLevel = widget.entryModel.secondLevel
              ..icon = widget.entryModel.icon
              ..isHtml = widget.entryModel.isHtml
              ..xtm = widget.entryModel.xtm;
            RouteUtils.pushPage(context, CommListView(temp));
          }else if(viewItems[index].dataType=="DETAIL"){
            RouteUtils.pushPage(context, DetailPage(detailPageInfo));
          }
        },
        child: IntrinsicHeight(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 60,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
//                Column(
//                  children:[
//                    Container(
//                      height: 40,
//                      width: 6,
//                      decoration: BoxDecoration(
//                        color: Colors.blueAccent,
//                        borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(8)),
//                      ),
//                    ),
//                  ],
//                ),
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Html(
                          style: {"body":Style(margin: EdgeInsets.all(0.0),
                              fontSize: FontSize(18),color: Colors.black,fontWeight: FontWeight.w400)},
                          data: viewItems[index].itemListViewContent.title==null?"":viewItems[index].itemListViewContent.title,
                        ),
                        Offstage(
                          offstage: viewItems[index].itemListViewContent.describe!=null?false:true,
                          child: Html(
                            style: {"body" : Style(margin: EdgeInsets.only(top:4.0),
                              fontSize: FontSize(16),color:Colors.grey[800],),},
                            data: viewItems[index].itemListViewContent.describe==null?"":viewItems[index].itemListViewContent.describe,
                          ),
                        ),
                        Offstage(
                          offstage: viewItems[index].itemListViewContent.note!=null?false:true,
                          child: Html(
                            style:{
                              "body" : Style(margin: EdgeInsets.only(top:4.0),
                                  fontSize: FontSize(14),color: Colors.grey[500]
                              ),
                            },
                            data: viewItems[index].itemListViewContent.note==null?"":viewItems[index].itemListViewContent.note,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Offstage(
                    offstage: viewItems[index].itemListViewContent.subTitle!=null?false:true,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Html(
                          data: viewItems[index].itemListViewContent.subTitle==null?"":viewItems[index].itemListViewContent.subTitle,
                          style:{
                            "body":Style(margin: EdgeInsets.all(0.0),textAlign: TextAlign.end,
                                fontSize: FontSize(18),color: Colors.blueAccent),
                          },
                        ),
                      ],
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
  }

  onLoading() async {
    setState(() {
      pageInfo.pageNumber++;
    });
    await initPageData();
    mRefreshController.loadComplete();
  }

  onRefresh() async {
    setState(() {
      pageInfo.pageNumber=1;
    });
    await initPageData();
    mRefreshController.refreshCompleted();
  }
  Future<String> decodeStringFromAssets(String path) async {
    ByteData byteData = await PlatformAssetBundle().load(path);
    String htmlString = String.fromCharCodes(byteData.buffer.asUint8List());
    return htmlString;
  }

  initPageData() async {
    var baseMap = DataHelper.getBaseMap();
    baseMap.clear();///8aUUVC4cbmHyy6+2yB+/2A==
    Map<String, dynamic> user = StorageUtils.getModelWithKey("userInfo");
    if(null != user){
      debugPrint("page:"+widget.entryModel.toPage);
      debugPrint("page:"+widget.entryModel.dataType);
      debugPrint("user:"+user.toString());
      baseMap['toPage']=widget.entryModel.toPage;
      baseMap['pageId']=widget.entryModel.dataType;
      baseMap['pageSize']=pageInfo.pageSize;
      baseMap['pageNumber']=pageInfo.pageNumber;
      baseMap['yhxtm']=user['yhxtm'];

      if(widget.entryModel.params != null){
        baseMap.addAll(widget.entryModel.params);
      }

      ResultData result = await HttpManager.getInstance().get(Address.MenuItemUrl, baseMap);
      if(result.code == 200){
        List json = jsonDecode(result.data);
        if(json.length==0){
          mRefreshController.loadNoData();
        }else{
          pageTitle = ListViewItem.fromJson(json[0]).listTitle;
          if(pageInfo.pageNumber==1){
            viewItems.clear();
          }
        }
        json.forEach((element) {
          viewItems.add(ListViewItem.fromJson(element));
        });
      }else{
        CommUtils.showDialog(context, "提示", "${result.data}", false,
            okOnPress: () {});
      }
    }else{
//      CommUtils.showDialog(context, "提示", "登录信息过期,请重新登录", false,
//          okOnPress: () {});
    }
    setState(() {});
  }
  @override
  void dispose() {
    super.dispose();
  }

}