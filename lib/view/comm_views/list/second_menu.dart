import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/page_loading.dart';
import 'package:flutter_dev/view/comm_views/detail/detail_page.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';
import 'package:flutter_dev/view/main/home/entry_model.dart';
import 'package:flutter_dev/view/main/home/grid_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'comm_list_view.dart';

class SecondMenu extends StatefulWidget{

  final EntryModel entryModel;
  SecondMenu(this.entryModel);

  @override
  State<StatefulWidget> createState() {
    return SecondMenuState();
  }
  
}
class SecondMenuState extends State<SecondMenu> {

  List<EntryModel> entryModels;

  RefreshController mRefreshController;

  @override
  void initState() {
    super.initState();
    entryModels = List();
    mRefreshController = new RefreshController();
    initData();
  }

  @override
  Widget build(BuildContext context) {

   return Scaffold(
     appBar: AppBar(
       title: Text(widget.entryModel.title,style: TextStyle(fontSize: 20),),
       centerTitle: true,
       leading: IconButton(
         onPressed: () {
           Navigator.of(context).pop();
         },
         icon: Icon(Icons.arrow_back_ios),
       ),
     ),
     body: Container(
       color: Colors.grey[100],
       child: SmartRefresher(
         enablePullDown: true,
         enablePullUp: true,
         header: WaterDropHeader(
           waterDropColor: Colors.blue,
         ),
         footer: ClassicFooter(),
         controller: mRefreshController,
         onRefresh: onRefresh,
         onLoading: onLoading,
         child: buildGridWidget(),
       ),
     ),
   );
  }

  buildGridWidget() {
    if(entryModels != null && entryModels.length>0){
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
                child: Ink(
                  child: InkWell(
                    onTap: () {
                      if(entryModels[index].dataType=="LIST"){
                        EntryModel temp = EntryModel()
                          ..toPage = entryModels[index].toPage
                          ..dataType = entryModels[index].dataType
                          ..title = entryModels[index].title
                          ..params = entryModels[index].params
                          ..secondLevel = entryModels[index].secondLevel
                          ..icon = entryModels[index].icon
                          ..isHtml = entryModels[index].isHtml
                          ..xtm = entryModels[index].xtm;
                        RouteUtils.pushPage(context, CommListView(temp));
                      }else{
                        DetailPageInfo detailPageInfo = DetailPageInfo()
                          ..params = entryModels[index].params
                          ..dataType = entryModels[index].dataType
                          ..detailPageId = entryModels[index].toPage;
                        RouteUtils.pushPage(context, DetailPage(detailPageInfo));
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
                          Center(
                            child: Text(
                              entryModels[index].title.length>5?(entryModels[index].title.substring(0,4)+"··"):entryModels[index].title,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
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
    }else{
      return PageLoading();
    }

  }

  onLoading() async {
//    mRefreshController.loadComplete();
//    mRefreshController.loadNoData();
}

  onRefresh() async {
    await initData();
    mRefreshController.refreshCompleted();
  }

  initData() async{
    entryModels.clear();
    var baseMap = DataHelper.getBaseMap();
    baseMap.clear();
    Map<String, dynamic> user = StorageUtils.getModelWithKey("userInfo");
    if(null != user) {
      baseMap['parentXtm'] = widget.entryModel.xtm;
      baseMap['yhxtm'] = user['yhxtm'];
      if (widget.entryModel.params != null) {
        baseMap.addAll(widget.entryModel.params);
      }

      ResultData result = await HttpManager.getInstance().get(
          Address.SecondMenuItemUrl, baseMap);
      if (result.code == 200) {
        List<dynamic> jsonList = jsonDecode(result.data.toString());
        for(int i=0;i<jsonList.length;i++){
          EntryModel entryModel = EntryModel.fromJson(jsonList[i]);
          entryModels.add(entryModel);
        }
      }
      setState(() {

      });
    }
  }

@override
  void dispose() {
    super.dispose();
    entryModels.clear();
  }

}