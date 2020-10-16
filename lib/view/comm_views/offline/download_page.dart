import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:flutter_dev/view/comm_views/components/page_loading.dart';
import 'package:flutter_dev/view/comm_views/components/progress.dart';
import 'package:flutter_dev/view/comm_views/moudel/page_info.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'moudel/task.dart';

class DownloadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DownloadPageState();
  }
}

class DownloadPageState extends State<DownloadPage> {
  RefreshController mRefreshController = new RefreshController();
  ClassicFooter footer = new ClassicFooter();
  PageInfo pageInfo = PageInfo();

  List<Task> mData;
  double isDownloadComp;

  @override
  void initState() {
    mData = List();
    pageInfo.pageNumber = 1;
    pageInfo.pageSize = 10;
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildPage();
  }

  Widget buildPage() {
    return Material(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext listContext, bool flag) {
            return [
              SliverAppBar(
                pinned: true,
                title: Text("任务下载清单"),
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
              child: buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  buildBody() {
    return mData.length > 0
        ? ListView.builder(
            itemCount: mData.length,
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return buildListItem(index);
            })
        : PageLoading();
  }

  buildListItem(int index) {
    return Card(
      elevation: 0.0,
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mData[index].description,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text("状态:    ${mData[index].comp == "0" ? "未完成" : "已完成"}",
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[600])),
                  ],
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                flex: 2,
                child: RaisedButton(
                  color: Colors.lightBlue[200],
                  onPressed: () {
//                    isDownloadComp = null;
                    showDialog(
                        context: context,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlue,
                            value: isDownloadComp,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        ));
                    onDownloadTask(mData[index].xtm);
                  },
                  child: Container(
                      child: Text(
                    "下载",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  initData() async {
    LoginUser user =
        LoginUser.fromJson(StorageUtils.getModelWithKey("userInfo"));
    var baseMap = DataHelper.getBaseMap();
    baseMap.clear();
    baseMap['date'] = DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd");
    baseMap['yhxtm'] = user.yhxtm;
    baseMap['pageNumber'] = pageInfo.pageNumber;
    baseMap['pageSize'] = pageInfo.pageSize;
    ResultData result = await HttpManager.getInstance()
        .get(Address.DownloadTaskList_URL, baseMap);
    if (result.code != 200) {
      CommUtils.showDialog(context, "提示", result.data, false, okOnPress: () {});
    } else {
      List<dynamic> json = jsonDecode(result.data);
      json.forEach((element) {
        mData.add(Task.fromJson(element));
      });
    }
    setState(() {});
  }

  onDownloadTask(String taskXtm) async {
    var baseMap = DataHelper.getBaseMap();
    baseMap.clear();
    baseMap['taskXtm'] = "ab648db4156448c3a53864dfc951d52c";
    ResultData result =
        await HttpManager.getInstance().get(Address.DownloadTask_URL, baseMap);
    if (result.code != 200) {
      CommUtils.showDialog(context, "提示", result.data, false, okOnPress: () {});
    } else {
      Map<String, dynamic> json = jsonDecode(result.data);
      if (TextUtil.isEmpty(json.toString())) {
        mRefreshController.loadNoData();
      }
      Navigator.of(context).pop();
      CommUtils.showDialog(context, "提示", "下载成功", true, okOnPress: () {});
      print('json:' + json.toString());


    }
    setState(() {});
  }

  handleNewDate(DateTime date) {}

  onLoading() async {
    pageInfo.pageNumber++;
    await initData();
    mRefreshController.loadComplete();
  }

  onRefresh() async {
    pageInfo.pageNumber = 1;
    mData.clear();
    await initData();
    mRefreshController.refreshCompleted();
    mRefreshController.loadComplete();
  }
}
