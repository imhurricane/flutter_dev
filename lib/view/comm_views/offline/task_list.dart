import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/page_loading.dart';
import 'package:flutter_dev/view/comm_views/moudel/page_info.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/equipment.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/page_status.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/paper.dart';
import 'package:flutter_dev/view/comm_views/offline/task_detail.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../main.dart';
import 'moudel/riss.dart';
import 'moudel/task.dart';

class TaskListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskListPageState();
  }
}

class TaskListPageState extends State<TaskListPage> with RouteAware{
  RefreshController mRefreshController = new RefreshController();
  ClassicFooter footer = new ClassicFooter();
  PageInfo pageInfo = PageInfo();

  List<Task> mData;
  double isDownloadComp;
  String complementText = "";
  List<String> complementTextList = List();
  LoginUser mLoginUser = LoginUser();
  PageStatus pageStatus = PageStatus.loading;

  @override
  void initState() {
    super.initState();
    mData = List();
    pageInfo.pageNumber = 1;
    pageInfo.pageSize = 10;
    initData();
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
              ),
            ];
          },
          body: Container(
            color: Colors.grey[200],
            child: SmartRefresher(
//              enablePullDown: true,
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
    if(pageStatus == PageStatus.loading){
      return PageLoading();
    }else if(pageStatus == PageStatus.showData){
      return ListView.builder(
          itemCount: mData.length,
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return buildListItem(index);
          });
    }else{
      return Container(
        child: Center(
          child: Text("暂无数据"),
        ),
      );
    }

  }

  buildListItem(int index) {
    if(mLoginUser.issysadmin == '1'){
      return Slidable(
        actionPane: SlidableStrechActionPane(),//滑出选项的面板 动画
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[//右侧按钮列表
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              closeOnTap: true,
              onTap: (){
                deleteTask(index);
              },
            ),
          ),
        ],
        child: Card(
          elevation: 0.0,
          child: InkWell(
            onTap: () {
              RouteUtils.pushPage(context, TaskDetailPage(mData[index]));
            },
            child: Container(
              height: 80,
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
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      complementTextList[index],
                      style: TextStyle(color: Colors.lightBlue, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }else{
      return Card(
        elevation: 0.0,
        child: InkWell(
          onTap: () {
            RouteUtils.pushPage(context, TaskDetailPage(mData[index]));
          },
          child: Container(
            height: 80,
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
                    ],
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    complementTextList[index],
                    style: TextStyle(color: Colors.lightBlue, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

  }

  initData() async {
    mLoginUser = LoginUser.fromJson(StorageUtils.getModelWithKey("userInfo"));
    TaskProvider taskProvider = TaskProvider();
    List<Task> tasks  = await taskProvider.getTaskByLimit(pageInfo.pageSize, pageInfo.pageNumber);
    print('tasks.length:'+tasks.length.toString());
    if (tasks.length == 0) {
      mRefreshController.loadComplete();
      mRefreshController.loadNoData();
    }else{
      mRefreshController.loadComplete();
    }
    for(int i = 0; i < tasks.length; i++){
      bool isComplement = true;
      bool isComplementPart = false; // 部分完成
      RissProvider rissProvider = RissProvider();
      List<Riss> rissList = await rissProvider.getRissByTaskId(tasks[i].xtm);
      for(int j = 0; j < rissList.length; j++){
        Riss riss = rissList[j];
        if ((riss.havemesure == null || riss.havemesure == '0') &&
            (riss.activemesure == null || riss.activemesure == '0') &&
            (riss.inactivemesure == null || riss.inactivemesure == '0')) {
          isComplement = false;
        }else{
          isComplementPart = true;
        }
      }
      if (isComplement) {
        complementText = '已完成';
      } else if(!isComplement && isComplementPart){
        complementText = '部分完成';
      }else if(!isComplement && !isComplementPart){
        complementText = '未完成';
      }
      complementTextList.add(complementText);
      mData.add(tasks[i]);
    }
    if (mData.length == 0) {
      pageStatus=PageStatus.noThing;
    }else{
      pageStatus=PageStatus.showData;
    }
    setState(() {});
  }

  onLoading() async {
    pageInfo.pageNumber++;
    await initData();
  }

  onRefresh() async {
    mData.clear();
    complementTextList.clear();
    pageInfo.pageNumber=1;
    await initData();
    mRefreshController.refreshCompleted();
    mRefreshController.loadComplete();
  }

  onPressItem(Task task) {
    RouteUtils.pushPage(context, TaskDetailPage(task));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 监听路由
    RootApp.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() async{
    super.didPopNext();
    // 当从其他页面返回当前页面时出发此方法
    mData.clear();
    complementTextList.clear();
    pageInfo.pageNumber=1;
    await initData();
  }

  deleteTask(int index) async{
    await CommUtils.showDialog(context, "提示", "确认删除该任务数据吗？", true,okOnPress: (){
      TaskProvider taskProvider = TaskProvider();
      taskProvider.deleteTaskById(mData[index].xtm);
      PaperProvider paperProvider = PaperProvider();
      paperProvider.deletePaperByTaskId(mData[index].xtm);
      EquipmentProvider equipmentProvider = EquipmentProvider();
      equipmentProvider.deleteEquipmentByTaskId(mData[index].xtm);
      RissProvider rissProvider = RissProvider();
      rissProvider.deleteRissByTaskId(mData[index].xtm);
      initData();
    },cancelOnPress: (){});

  }
}