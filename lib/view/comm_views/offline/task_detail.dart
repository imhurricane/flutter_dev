import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/sign_page.dart';
import 'package:flutter_dev/view/comm_views/components/spinner.dart';
import 'package:flutter_dev/view/comm_views/components/task_check_view.dart';
import 'package:flutter_dev/view/comm_views/moudel/selects.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/equipment.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/paper.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/riss.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/riss_complete.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/task.dart';

import '../../../main.dart';
import 'abnormal_phenomena.dart';
import 'moudel/current_check_info.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  TaskDetailPage(this.task);

  @override
  State<StatefulWidget> createState() {
    return TaskDetailPageState();
  }
}

class TaskDetailPageState extends State<TaskDetailPage> with RouteAware{
  ScrollController mListViewController;
  List<Task> mTaskList;
  List<Selects> mTaskSelects;
  int mTaskPosition;

  List<Paper> mPaperList;
  List<Selects> mPaperSelects;
  int mPaperPosition;

  List<Equipment> mEquipmentList;
  int mEquPosition;
  List<Selects> mEquipmentSelects;

  List<Riss> mRissList;

  CurrentCheckInfo mCheckInfo;

  @override
  void initState() {
    super.initState();
    mListViewController = ScrollController();

    mTaskList = List();
    mPaperList = List();
    mEquipmentList = List();
    mRissList = List();

    mTaskSelects = List();
    mTaskPosition = 0;

    mPaperSelects = List();
    mPaperPosition = 0;

    mEquipmentSelects = List();
    mEquPosition = 0;

    mCheckInfo = CurrentCheckInfo();
    initTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: WillPopScope(
        onWillPop: () async{
          saveCurrentCheckInfo();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("任务排查"),
            leading: IconButton(
              onPressed: () {
                saveCurrentCheckInfo();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            actions: [
              IconButton(
                padding: const EdgeInsets.all(8.0),
                icon: Icon(Icons.assignment),
                onPressed: () async{
                  RissCompleteProvider provider = RissCompleteProvider();
                  List<RissComplete> allRiss = await provider.getRissByPaperId(mPaperList[mPaperPosition].xtm);
                  bool flag = false;
                  String rissXtm = "";
                  for (int i = 0; i < allRiss.length; i++) {
                    if (allRiss[i].havemesure == "1" ||
                        allRiss[i].activemesure == "1" ||
                        allRiss[i].inactivemesure == "1") {
                      flag = true;
                      rissXtm = allRiss[i].xtm;
                      break;
                    }
                  }
                  if(flag){
                    RouteUtils.pushPage(context, SignApp(mRissXtm: rissXtm,mPaperXtm: mPaperList[mPaperPosition].xtm,));
                  }else{
                    CommUtils.showDialog(context, "提示", "请先检查排查项", false,okOnPress: (){});
                  }
                },
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                buildTaskSpinner(),
                SizedBox(
                  height: 4,
                ),
                buildPaperSpinner(),
                SizedBox(
                  height: 4,
                ),
                buildEquipmentSpinner(),
                SizedBox(
                  height: 4,
                ),
                Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 36, right: 36),
                        width: double.infinity,
                        child: Text(
                          "排查项目",
                          style: TextStyle(color: Colors.lightBlue),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 36, right: 36),
                      height: 1,
                      color: Colors.lightBlue,
                    ),
                  ],
                ),
                buildRiss(),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 36, right: 36),
                      height: 1,
                      color: Colors.lightBlue,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonBar(
                      children: [
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          splashColor: Colors.grey,
                          child: Text(" 上一设备 "),
                          onPressed: () {
                            preTask(2);
                          },
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          splashColor: Colors.grey,
                          child: Text(" 下一设备 "),
                          onPressed: () {
                            nextTask(2);
                          },
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          splashColor: Colors.grey,
                          child: Text(" 校验数据 "),
                          onPressed: () {
                            checkTaskPaperIsComplete();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildRiss() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          controller: mListViewController,
          itemBuilder: (BuildContext context, int index) {
            return buildRissItem(index);
          },
          itemCount: mRissList?.length,
        ),
      ),
    );
  }

  buildRissItem(index) {
    return FlatButton(
      onPressed: (){
        if(mRissList[index].havemesure=="1"||mRissList[index].activemesure=="1"||mRissList[index].inactivemesure=="1"){
          RouteUtils.pushPage(context, AbnormalPhenomena(mRiss: mRissList[index],mPaerXtm: mPaperList[mPaperPosition].xtm,));
        }else{
          CommUtils.showDialog(context, "提示", "请选择检查项后进入", false,okOnPress: (){});
        }
      },
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.grey[300]))),
        child: TaskCheck(
          top: 10,
          left: 20,
          right: 20,
          riss: mRissList[index],
          checkedCallBack: (riss) {
            checkedCallBack(index,riss);
          },
        ),
      ),
    );
  }

  buildTaskSpinner() {
    return FromSpinnerSearch(
      selects: mTaskSelects,
      selectCallBack: (select) {
        selectCallBack(select, 0);
      },
      nextCallBack: () {
        nextTask(0);
      },
      preCallBack: () {
        preTask(0);
      },
    );
  }

  buildPaperSpinner() {
    return FromSpinnerSearch(
      selects: mPaperSelects,
      selectCallBack: (select) {
        selectCallBack(select, 1);
      },
      nextCallBack: () {
        nextTask(1);
      },
      preCallBack: () {
        preTask(1);
      },
    );
  }

  buildEquipmentSpinner() {
    return FromSpinnerSearch(
      selects: mEquipmentSelects,
      selectCallBack: (select) {
        selectCallBack(select, 2);
      },
      nextCallBack: () {
        nextTask(2);
      },
      preCallBack: () {
        preTask(2);
      },
    );
  }

  selectCallBack(select, index) async {
    switch (index) {
      case 0:
        mTaskPosition = mTaskSelects.lastIndexOf(select);
        mTaskSelects.forEach((element) {
          element.isChecked = false;
        });
        mTaskSelects[mTaskPosition].isChecked = true;
        await initPaperData(0);
        await initEquipmentData(0);
        await initRissData();
        break;
      case 1:
        mPaperPosition = mPaperSelects.lastIndexOf(select);
        mPaperSelects.forEach((element) {
          element.isChecked = false;
        });
        mPaperSelects[mPaperPosition].isChecked = true;
        await initEquipmentData(0);
        await initRissData();
        break;
      case 2:
        mEquPosition = mEquipmentSelects.lastIndexOf(select);
        mEquipmentSelects.forEach((element) {
          element.isChecked = false;
        });
        mEquipmentSelects[mEquPosition].isChecked = true;
        await initRissData();
        break;
    }
  }

  initTaskData() async {

    Map<dynamic,dynamic> modelWithKey = StorageUtils.getModelWithKey("currentCheckInfo");
    if(modelWithKey != null){
      mCheckInfo = CurrentCheckInfo.fromJson(modelWithKey);
      if(widget.task.xtm==mCheckInfo.taskXtm){
        mPaperPosition = mCheckInfo.paperPosition;
        mEquPosition = mCheckInfo.equipmentPosition;
      }
    }

    TaskProvider taskProvider = TaskProvider();
    mTaskList = await taskProvider.getAllTask();
    mTaskList.forEach((element) {
      if (element.xtm == widget.task.xtm) {
        mTaskPosition = mTaskList.indexOf(element);
      }
      Selects selects = Selects();
      selects.desc = element.description;
      selects.isChecked = false;
      mTaskSelects.add(selects);
    });
    mTaskSelects[mTaskPosition].isChecked = true;
    await initPaperData(mPaperPosition);
    await initEquipmentData(mEquPosition);
    await initRissData();
    setState(() {});
  }

  initPaperData(int position) async {
    mPaperSelects.clear();
    mPaperList.clear();
    PaperProvider paperProvider = PaperProvider();
    mPaperList =
        await paperProvider.getPaperByParentId(mTaskList[mTaskPosition].xtm);
    mPaperList.forEach((element) {
      Selects selects = Selects();
      selects.desc = element.description;
      selects.isChecked = false;
      mPaperSelects.add(selects);
    });
    if (mPaperSelects.length > 0) {
      mPaperPosition = position;
      mPaperSelects[mPaperPosition].isChecked = true;
    }
    setState(() {});
  }

  initEquipmentData(int position) async {
    mEquipmentList.clear();
    mEquipmentSelects.clear();
    EquipmentProvider equipmentProvider = EquipmentProvider();
    if (mPaperList.length > mPaperPosition) {
      mEquipmentList = await equipmentProvider
          .getEquipmentByParentId(mPaperList[mPaperPosition].xtm);
      mEquipmentList.forEach((element) {
        Selects selects = Selects();
        selects.desc = element.description;
        selects.isChecked = false;
        mEquipmentSelects.add(selects);
      });
      if (mEquipmentSelects.length > 0) {
        mEquPosition = position;
        mEquipmentSelects[mEquPosition].isChecked = true;
      }
    }
    setState(() {});
  }

  initRissData() async {
    mRissList.clear();
    RissProvider rissProvider = RissProvider();
    if (mEquipmentList.length > mEquPosition) {
      mRissList = await rissProvider
          .getRissByParentId(mEquipmentList[mEquPosition].xtm);
    }
    ScrollPosition position = mListViewController.position;
    position.jumpTo(0.0);
    setState(() {});
  }

  nextTask(int index) async {
    switch (index) {
      case 0:
        if (mTaskPosition < mTaskList.length - 1) {
          mTaskPosition++;
          mTaskSelects.forEach((element) {
            element.isChecked = false;
          });
          mTaskSelects[mTaskPosition].isChecked = true;
          await initPaperData(0);
          await initEquipmentData(0);
          await initRissData();
        } else {
          CommUtils.showDialog(context, "提示", "已经最后一个任务", false,
              okOnPress: () {});
        }
        break;
      case 1:
        if (mPaperPosition < mPaperList.length - 1) {
          mPaperPosition++;
          mPaperSelects.forEach((element) {
            element.isChecked = false;
          });
          mPaperSelects[mPaperPosition].isChecked = true;
          await initEquipmentData(0);
          await initRissData();
        } else {
          CommUtils.showDialog(context, "提示", "已经最后一个任务清单", false,
              okOnPress: () {});
        }

        break;
      case 2:
        if (mEquPosition < mEquipmentList.length - 1) {
          mEquPosition++;
          mEquipmentSelects.forEach((element) {
            element.isChecked = false;
          });
          mEquipmentSelects[mEquPosition].isChecked = true;
          await initRissData();
        } else {
          CommUtils.showDialog(context, "提示", "已经最后一个设备", false,
              okOnPress: () {});
        }
        break;
    }
  }

  preTask(int index) async {
    switch (index) {
      case 0:
        if (mTaskPosition > 0) {
          mTaskPosition--;
          mTaskSelects.forEach((element) {
            element.isChecked = false;
          });
          mTaskSelects[mTaskPosition].isChecked = true;
          await initPaperData(0);
          await initEquipmentData(0);
          await initRissData();
        } else {
          CommUtils.showDialog(context, "提示", "已经第一个任务", false,
              okOnPress: () {});
        }
        break;
      case 1:
        if (mPaperPosition > 0) {
          mPaperPosition--;
          mPaperSelects.forEach((element) {
            element.isChecked = false;
          });
          mPaperSelects[mPaperPosition].isChecked = true;
          await initEquipmentData(0);
          await initRissData();
        } else {
          CommUtils.showDialog(context, "提示", "已经第一个任务清单", false,
              okOnPress: () {});
        }
        break;
      case 2:
        if (mEquPosition > 0) {
          mEquPosition--;
          mEquipmentSelects.forEach((element) {
            element.isChecked = false;
          });
          mEquipmentSelects[mEquPosition].isChecked = true;
          await initRissData();
        } else {
          CommUtils.showDialog(context, "提示", "已经第一个设备", false,
              okOnPress: () {});
        }
        break;
    }
  }

  checkedCallBack(int index,Riss riss) async{
    RissProvider rissProvider = RissProvider();
    await rissProvider.update(riss,true);
    Map<String, dynamic> user = await StorageUtils.getModelWithKey("userInfo");
    RissComplete rissComplete = RissComplete();
    rissComplete.xtm=riss.xtm;
    rissComplete.errdetail=riss.errdetail;
    rissComplete.parentxtm=riss.parentxtm;
    rissComplete.rwxtm=riss.rwxtm;
    rissComplete.pjjb=riss.pjjb;
    rissComplete.riskfactors=riss.riskfactors;
    rissComplete.fxffcs=riss.fxffcs;
    rissComplete.inactivemesure=riss.inactivemesure;
    rissComplete.activemesure=riss.activemesure;
    rissComplete.havemesure=riss.havemesure;
    rissComplete.paperXtm=mPaperList[mPaperPosition].xtm;
    rissComplete.checkData=DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");;
    rissComplete.isUpload="0";
    rissComplete.yhXtm=user['yhxtm'];
    RissCompleteProvider rissCompleteProvider = RissCompleteProvider();
    rissCompleteProvider.insertRiss(rissComplete);
    setState(() {
      mRissList[index] = riss;
    });
  }

  checkTaskPaperIsComplete() async{
    if(mPaperList.length>0){
      EquipmentProvider equipmentProvider = EquipmentProvider();
      List<Equipment> equipmentList = await equipmentProvider.getEquipmentByParentId(mPaperList[mPaperPosition].xtm);

      bool isComplete = false;
      int noCompleteEquPosition = 0;
      for(int i =0;i<equipmentList.length;i++){
        RissProvider rissProvider = RissProvider();
        List<Riss> rissList = await rissProvider.getRissByParentId(equipmentList[i].xtm);
        bool tempBool = true;

        for(int j = 0;j<rissList.length;j++){
          if(rissList[j].activemesure=="1" || rissList[j].inactivemesure =="1"||rissList[j].havemesure=="1"){
            tempBool=true;
          }else{
            tempBool = false;
            break;
          }
        }
        noCompleteEquPosition = i;
        isComplete = tempBool;
        if(!tempBool){
          break;
        }
      }
      if(isComplete){
        CommUtils.showDialog(context, "提示", "当前任务清单已完成", false,okOnPress: (){});
      }else{
        CommUtils.showDialog(context, "提示", "当前任务清单未完成，请前往查看", false,okOnPress: (){
          jumpEquipment(noCompleteEquPosition);
        });
      }
    }else{
      CommUtils.showDialog(context, "提示", "暂无可检查数据！", false,okOnPress: (){});
    }
  }

  // 跳转到未完成的设备
  jumpEquipment(int position) async{
    mEquipmentSelects[mEquPosition].isChecked=false;
    mEquPosition = position;
    mEquipmentSelects[mEquPosition].isChecked = true;
    await initRissData();
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
    PaperProvider paperProvider = PaperProvider();
    mPaperList =
    await paperProvider.getPaperByParentId(mTaskList[mTaskPosition].xtm);
    await initRissData();
  }

  saveCurrentCheckInfo() async{
    CurrentCheckInfo currentCheckInfo = CurrentCheckInfo();
    currentCheckInfo.taskXtm=mTaskList[mTaskPosition].xtm;
    currentCheckInfo.paperPosition=mPaperPosition;
    currentCheckInfo.equipmentPosition=mEquPosition;
    await StorageUtils.saveModel("currentCheckInfo", currentCheckInfo);
  }
}
