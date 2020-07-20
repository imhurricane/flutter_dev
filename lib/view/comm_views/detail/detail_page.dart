import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DetailPage extends StatefulWidget {

  final DetailPageInfo detailPage;
  DetailPage(this.detailPage);

  @override
  State<StatefulWidget> createState() {
    return DetailPageState();
  }
}

class DetailPageState extends State<DetailPage> {
  RefreshController mRefreshController = new RefreshController();
  DetailData detailData = new DetailData();
  @override
  void initState() {
    super.initState();
    initData();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext listContext, bool flag) {
            return [
              SliverAppBar(
                pinned: true,
                title: Text(detailData.itemDetailColumns==null?"":detailData.itemDetailColumns[0].pageTitle),
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
                      Icons.add_circle_outline,
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
                enablePullUp: false,
                header: WaterDropHeader(
                  waterDropColor: Colors.blue,
                ),
                footer: ClassicFooter(),
                controller: mRefreshController,
                onRefresh: onRefresh,
                onLoading: onLoading,
                child: Column(
                  children: [

                  ],
                ),
              )),
        ),
      ),
    );
  }

  onLoading() async {
    mRefreshController.loadComplete();
//    mRefreshController.loadNoData();
  }

  onRefresh() async {
    mRefreshController.refreshCompleted();
  }

  initData() async {
    var baseMap = DataHelper.getBaseMap();
    baseMap.clear();
    Map<String, dynamic> user = SpUtil.getObject("userInfo");
    debugPrint("page:"+widget.detailPage.detailPageId);
    baseMap['datatype']=widget.detailPage.dataType;
    baseMap['detailPageId']=widget.detailPage.detailPageId;
    baseMap['yhxtm']=user['yhxtm'];
    if(widget.detailPage.params != null){
      baseMap.addAll(widget.detailPage.params);
    }

    ResultData result = await HttpManager.getInstance().get(Address.MenuItemDetailUrl, baseMap);
    if(result.code == 200){
      debugPrint("data:"+result.data);
      Map<String,dynamic> json = jsonDecode(result.data);
      detailData = DetailData.fromJson(json);

      setState(() {

      });
    }else{
      CommUtils.showDialog(context, "提示", "${result.data}", false,
          okOnPress: () {});
    }
  }
}
