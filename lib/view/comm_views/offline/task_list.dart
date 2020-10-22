
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
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/page_loading.dart';
import 'package:flutter_dev/view/comm_views/components/progress.dart';
import 'package:flutter_dev/view/comm_views/moudel/page_info.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/paper.dart';
import 'package:flutter_dev/view/comm_views/offline/task_detail.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'moudel/task.dart';

class TaskListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskListPageState();
  }
}

class TaskListPageState extends State<TaskListPage> {
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
                title: Text("任务清单"),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
//                actions: [
//                  IconButton(
////                  padding: EdgeInsets.only(right: 20),
//                    icon: Icon(
//                      Icons.menu,
//                      color: Colors.white,
//                    ),
//                    onPressed: () {},
//                  ),
//                ],
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
        onTap: (){
          RouteUtils.pushPage(context, TaskDetailPage(mData[index]));
        },
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mData[index].description,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
//                    Text("状态:    ${mData[index].comp == "0" ? "未完成" : "已完成"}",
//                        style:
//                        TextStyle(fontSize: 16, color: Colors.grey[600])),
                  ],
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                flex: 2,
                child: Text(mData[index].comp=="1"?"已完成":"未完成",style: TextStyle(color: Colors.lightBlue,fontSize: 16),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  initData() async {
    LoginUser user = LoginUser.fromJson(StorageUtils.getModelWithKey("userInfo"));
    TaskProvider taskProvider = TaskProvider();
    mData = await taskProvider.getAllTask();
//    mData.addAll(tasks);
    if(mData.length==0){
      CommUtils.showDialog(context, "提示", "暂无数据，请先下载任务", true,okOnPress: (){
        Navigator.of(context).pop();
      });
    }
    setState(() {});
  }

  onLoading() async {
    await initData();
    mRefreshController.loadComplete();
  }

  onRefresh() async {
    mData.clear();
    await initData();
    mRefreshController.refreshCompleted();
    mRefreshController.loadComplete();
  }

  onPressItem(Task task) {
    RouteUtils.pushPage(context, TaskDetailPage(task));
  }
}