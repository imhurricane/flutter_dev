import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/monitor_network_utils.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:flutter_dev/view/comm_views/components/page_loading.dart';
import 'package:flutter_dev/view/comm_views/components/progress.dart';
import 'package:flutter_dev/view/comm_views/moudel/page_info.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/equipment.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/paper.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/riss.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    return Slidable(
      actionPane: SlidableStrechActionPane(),//滑出选项的面板 动画
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[//右侧按钮列表
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: IconSlideAction(
            caption: '下载',
            color: Colors.lightBlue,
            icon: Icons.file_download,
            closeOnTap: true,
            onTap: () {
              checkTaskIsDownloaded(mData[index].xtm);
            },
          ),
        ),
      ],
      child: Card(
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        mData[index].description,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text("状态:    ${mData[index].comp == "1" ? "已完成" : "未完成"}",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600])),
                    ],
                  ),
                ),
//                SizedBox(
//                  width: 8.0,
//                ),
//                Expanded(
//                  flex: 2,
//                  child: RaisedButton(
//                    color: Colors.lightBlue[200],
//                    onPressed: () async{
//                      checkTaskIsDownloaded(mData[index].xtm);
//
//                    },
//                    child: Container(
//                        child: Text(
//                      "下载",
//                      style: TextStyle(fontSize: 16, color: Colors.white),
//                    )),
//                  ),
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  initData() async {
    int networkStatus = await MonitorNetworkUtils.getNetworkStatus();
    if(networkStatus==0){
      CommUtils.showDialog(context, "提示", "请连接网络后再试", false, okOnPress: () {});
    }else{
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

  }

  onDownloadTask(String taskXtm) async {
    showDialog(
        context: context,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlue,
            value: isDownloadComp,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        ));

    var baseMap = DataHelper.getBaseMap();
    baseMap.clear();
    baseMap['taskXtm'] = taskXtm;
    ResultData result =
        await HttpManager.getInstance().get(Address.DownloadTask_URL, baseMap);
    print('');
    if (result.code != 200) {
      Navigator.of(context).pop();
      CommUtils.showDialog(context, "提示", result.data, false, okOnPress: () {});
    } else {
      Map<String, dynamic> json = jsonDecode(result.data);
      if (TextUtil.isEmpty(json.toString())) {
        mRefreshController.loadNoData();
      }

      Task task = Task.fromJson(json);
      List<Paper> paperList = task.paper;
      TaskProvider taskProvider = TaskProvider();
      Map<String,dynamic> remove = task.toJson();
      remove.remove("paper");
      await taskProvider.insertTask(Task.fromJson(remove));

      for(int i=0;i<paperList.length;i++){
        Paper paper = paperList[i];
        PaperProvider paperProvider = PaperProvider();
        List<Equipment> equipments = paper.equipment;
        Map<String,dynamic> map = paper.toJson();
        map.remove("equipment");
        await paperProvider.insertPaper(Paper.fromJson(map));

        for(int j=0;j<equipments.length;j++){
          Equipment equipment = equipments[j];
          EquipmentProvider equProvider = EquipmentProvider();
          List<Riss> rissList = equipment.riss;
          Map<String,dynamic> map = equipment.toJson();
          map.remove("riss");
          await equProvider.insertEquipment(Equipment.fromJson(map));

          for(int k=0;k<rissList.length;k++){
            Riss riss = rissList[k];
            RissProvider rissProvider = RissProvider();
            await rissProvider.insertRiss(riss,false);
          }
        }
      }
      Navigator.of(context).pop();
      CommUtils.showDialog(context, "提示", "下载成功", true, okOnPress: () {});
    }
    setState(() {});
  }

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

  checkTaskIsDownloaded(String taskXtm) async{
    TaskProvider taskProvider = TaskProvider();
    Task task = await taskProvider.getTaskById(taskXtm);
    if(task!=null){
      CommUtils.showDialog(context, "提示", "该任务已存在，再次下载将会更新本地数据，是否继续？", true,okOnPress: (){
        onDownloadTask(taskXtm);
      },cancelOnPress: (){

      });
    }else{
      onDownloadTask(taskXtm);
    }
  }
}
