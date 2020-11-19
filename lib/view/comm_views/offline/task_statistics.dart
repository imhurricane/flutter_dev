
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/spinner.dart';
import 'package:flutter_dev/view/comm_views/moudel/selects.dart';
import 'package:flutter_dev/view/comm_views/offline/task_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../main.dart';
import 'moudel/equipment.dart';
import 'moudel/paper.dart';
import 'moudel/riss.dart';
import 'moudel/task.dart';

class StatisticsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return StatisticsPageState();
  }

}

class StatisticsPageState extends State<StatisticsPage>  with RouteAware{

  RefreshController mRefreshController = new RefreshController();
  List<Task> mTaskList=List();
  List<Selects> mTaskSelects = List();
  TextStyle _textStyle = TextStyle(fontSize: 16);
  TextStyle _textStyle1 = TextStyle(fontSize: 16,color: Colors.lightBlue);
  int mPosition;
  String mTaskStatus;
  int mPaperTotalCount;
  int mPaperComplementCount;
  int mEquipmentTotalCount;
  int mEquipmentComplementCount;
  int mRissTotalCount;
  int mRissComplementCount;

  @override
  void initState() {
    super.initState();
    mPosition = 0;
    mTaskStatus="";
    mPaperTotalCount = 0;
    mPaperComplementCount = 0;
    mEquipmentTotalCount = 0;
    mEquipmentComplementCount = 0;
    mRissTotalCount = 0;
    mRissComplementCount = 0;
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("任务统计"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: buildButton(),
    );
  }

  buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        FromSpinnerSearch(
          selects: mTaskSelects,
          preCallBack: preCallBack,
          nextCallBack: nextCallBack,
          selectCallBack: selectCallBack,
        ),
        SizedBox(height: 40,),
        buildTaskField(),
        SizedBox(height: 5,),
        Container(height:1,color: Colors.lightBlue,margin: EdgeInsets.symmetric(horizontal: 36),),
        SizedBox(height: 15,),
        buildPaperField(),
        SizedBox(height: 5,),
        Container(height:1,color: Colors.lightBlue,margin: EdgeInsets.symmetric(horizontal: 36),),
        SizedBox(height: 15,),
        buildEquipmentField(),
        SizedBox(height: 5,),
        Container(height:1,color: Colors.lightBlue,margin: EdgeInsets.symmetric(horizontal: 36),),
        SizedBox(height: 15,),
        buildRissField(),
        SizedBox(height: 5,),
        Container(height:1,color: Colors.lightBlue,margin: EdgeInsets.symmetric(horizontal: 36),),
      ],
    );
  }

  selectCallBack(Selects p1) async{
    setState(() {
      mPosition = mTaskSelects.indexOf(p1);
      mTaskSelects.forEach((element) {
        element.isChecked=false;
      });
      mTaskSelects[mPosition].isChecked=true;
    });
    await initStatistics();
  }

  initData() async{
//    mTaskList.clear();
//    mTaskSelects.clear();
    TaskProvider taskProvider = TaskProvider();
    mTaskList = await taskProvider.getAllTask();
    mTaskList.forEach((element) {
      Selects selects = Selects();
      selects.desc = element.description;
      selects.isChecked = false;
      mTaskSelects.add(selects);
    });
    if(mTaskSelects.length>0){
      mTaskSelects[mPosition].isChecked=true;
    }
    await initStatistics();

  }

  initStatistics() async{
    mPaperTotalCount = 0;
    mPaperComplementCount = 0;
    mEquipmentTotalCount = 0;
    mEquipmentComplementCount = 0;
    mRissTotalCount = 0;
    mRissComplementCount = 0;
    PaperProvider paperProvider = PaperProvider();
    EquipmentProvider equipmentProvider = EquipmentProvider();
    RissProvider rissProvider = RissProvider();
    List<Paper> paperList =
    await paperProvider.getPaperByParentId(mTaskList[mPosition].xtm);
    mPaperTotalCount = paperList.length;
    for(int i=0;i<paperList.length;i++){
      List<Equipment> equList = await equipmentProvider.getEquipmentByParentId(paperList[i].xtm);
      mEquipmentTotalCount += equList.length;
      int equipmentComplementCount = 0;
      for(int j=0;j<equList.length;j++){
        List<Riss> rissList = await rissProvider.getRissByParentId(equList[j].xtm);
        mRissTotalCount += rissList.length;
        int rissComplementCount = 0;
        rissList.forEach((element) {
          if(element.inactivemesure == "1" || element.activemesure == "1" || element.havemesure == "1"){
            mRissComplementCount++;
            rissComplementCount++;
          }
        });
        if(rissComplementCount == rissList.length){
          mEquipmentComplementCount++;
          equipmentComplementCount++;
        }
      }
      if(equipmentComplementCount == equList.length){
        mPaperComplementCount++;
      }
    }
    if(mPaperComplementCount == mPaperTotalCount){
      mTaskStatus = "已完成";
    }else if(mPaperComplementCount > 0){
      mTaskStatus = "部分完成";
    }else{
      mTaskStatus = "未完成";
    }
    setState(() {

    });
  }


  preCallBack() async{
    if(mPosition>0){
      mPosition--;
    }else{
      CommUtils.showDialog(context, "提示", "已经是第一条任务", false,okOnPress: (){});
    }
    mTaskSelects.forEach((element) {
      element.isChecked=false;
    });
    mTaskSelects[mPosition].isChecked=true;
    await initStatistics();
    setState(() {

    });
  }

  nextCallBack() async{
    if(mPosition<mTaskSelects.length-1){
      mPosition++;
    }else{
      CommUtils.showDialog(context, "提示", "已经是最后一条任务", false,okOnPress: (){});
    }
    mTaskSelects.forEach((element) {
      element.isChecked=false;
    });
    mTaskSelects[mPosition].isChecked=true;
    await initStatistics();
    setState(() {

    });
  }

  ///  创建普通可编辑text文本框
  buildTaskField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        children: [
          Text("任务状态：",style: _textStyle,),
          Expanded(
            flex: 1,
              child: Text(mTaskStatus,style: _textStyle1,textAlign: TextAlign.center,)),
        ],
      ),
    );
  }
  ///  创建普通可编辑text文本框
  buildPaperField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        children: [
          Text("任务清单：",style: _textStyle,),
          Expanded(flex:1,
              child: Text(mPaperComplementCount.toString()+"/"+mPaperTotalCount.toString(),style:_textStyle1,textAlign: TextAlign.center,)),
        ],
      ),
    );
  }

  ///  创建普通可编辑text文本框
  buildEquipmentField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("排查设备：",style: _textStyle,),
          Expanded(flex:1,child:
          Text(mEquipmentComplementCount.toString()+"/"+mEquipmentTotalCount.toString(),style:_textStyle1,textAlign: TextAlign.center,)),
        ],
      ),
    );

  }

  ///  创建普通可编辑text文本框
  buildRissField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("风险排查项:",style: _textStyle,),
          Expanded(flex:1,child:
          Text(mRissComplementCount.toString()+"/"+mRissTotalCount.toString(),style:_textStyle1,textAlign: TextAlign.center,)),
        ],
      ),
    );
  }

  buildButton() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: RaisedButton(
        onPressed: (){
          RouteUtils.pushPage(context, TaskDetailPage(mTaskList[mPosition]));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0)),
        color: Colors.lightBlue,
        child: Text("前往任务排查",style: TextStyle(color: Colors.white),),
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
  void didPopNext() async{
    super.didPopNext();
    // 当从其他页面返回当前页面时出发此方法
    await initStatistics();
  }

}