import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/view/comm_views/components/spinner_drop_down.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/equipment.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/paper.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/riss.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/task.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  TaskDetailPage(this.task);

  @override
  State<StatefulWidget> createState() {
    return TaskDetailPageState();
  }
}

class TaskDetailPageState extends State<TaskDetailPage> {
  List<Task> mTaskList;
  List<String> mTaskNames;
  int mTaskPosition;

  List<Paper> mPaperList;
  List<String> mPaperNames;
  int mPaperPosition;

  List<Equipment> mEquipmentList;
  List<String> mEquNames;
  int mEquPosition;

  List<Riss> mRissList;
  List<String> mRissNames;
  int mRissPosition;

  @override
  void initState() {
    super.initState();
    mTaskList = List();
    mPaperList = List();
    mEquipmentList = List();
    mRissList = List();

    mTaskNames = List();
    mTaskPosition = 0;

    mPaperNames = List();
    mPaperPosition = 0;

    mEquNames = List();
    mEquPosition = 0;

    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("任务排查"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
//            SizedBox(height: 4,),
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
            buildRiss(),
          ],
        ),
      ),
    );
  }

  buildRiss() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return buildRissItem(index);
          },
          itemCount: mRissList?.length,
        ),
      ),
    );
  }

  buildRissItem(index) {
    return Container(
      child: Row(
        children: [
          Text(mRissList[index].riskfactors),
        ],
      ),
    );
  }

  buildTaskSpinner() {
    if (mTaskNames.length > 0) {
      return SpinnerDropDown(
        mData: mTaskNames,
        mDataPosition: mTaskPosition,
        selectCallBack: (value) {
          for (int i = 0; i < mTaskList.length; i++) {
            if (mTaskNames[i] == value) {
              mTaskPosition = i;
            }
          }
          setState(() {});
        },
        nextCallBack: () {
          nextTask(0);
        },
        preCallBack: () {
          preTask(0);
        },
      );
    } else {
      return Container();
    }
  }

  buildPaperSpinner() {
    if (mPaperNames.length > 0) {
      return SpinnerDropDown(
        mData: mPaperNames,
        mDataPosition: mPaperPosition,
        selectCallBack: (value) {
          for (int i = 0; i < mPaperNames.length; i++) {
            if (mPaperNames[i] == value) {
              mPaperPosition = i;
            }
          }
          setState(() {});
        },
        nextCallBack: () {
          nextTask(1);
        },
        preCallBack: () {
          preTask(1);
        },
      );
    } else {
      return Container();
    }
  }

  buildEquipmentSpinner() {
    if (mEquNames.length > 0) {
      return SpinnerDropDown(
        mData: mEquNames,
        mDataPosition: mEquPosition,
        selectCallBack: selectEqu,
        nextCallBack: () {
          nextTask(2);
        },
        preCallBack: () {
          preTask(2);
        },
      );
    } else {
      return Container();
    }
  }

  initData() async {
    TaskProvider taskProvider = TaskProvider();
    mTaskList = await taskProvider.getAllTask();
    mTaskNames.clear();
    mTaskList.forEach((element) {
      mTaskNames.add(element.description);
      if (element.xtm == widget.task.xtm) {
        mTaskPosition = mTaskList.indexOf(element);
      }
    });

    await initPaperData();

    await initEquipmentData();
    await initRissData();

    setState(() {});
  }

  selectEqu(value) async{
      for (int i = 0; i < mEquNames.length; i++) {
        if (mEquNames[i] == value) {
          mEquPosition = i;
        }
      }
      await initRissData();
      setState(() {});

  }


  initPaperData() async {
    mPaperNames.clear();
    PaperProvider paperProvider = PaperProvider();
    mPaperList = await paperProvider.getPaperByParentId(widget.task.xtm);
    mPaperList.forEach((element) {
      mPaperNames.add(element.description);
    });
  }

  initEquipmentData() async {
    mEquNames.clear();
    EquipmentProvider equipmentProvider = EquipmentProvider();
    mEquipmentList =
        await equipmentProvider.getEquipmentByTaskId(widget.task.xtm);
    mEquipmentList.forEach((element) {
      mEquNames.add(element.description);
    });
  }

  initRissData() async {
    RissProvider rissProvider = RissProvider();
    mRissList =
        await rissProvider.getRissByParentId(mEquipmentList[mEquPosition].xtm);
  }

  nextTask(int index) async {
    switch (index) {
      case 0:
        if (mTaskPosition < mTaskList.length - 1) {
          mTaskPosition++;
        }
        await initPaperData();
        break;
      case 1:
        if (mPaperPosition < mPaperList.length - 1) {
          mPaperPosition++;
        }
        await initEquipmentData();
        await initRissData();
        break;
      case 2:
        if (mEquPosition < mEquipmentList.length - 1) {
          mEquPosition++;
        }
        await initRissData();
        break;
    }
    setState(() {});
  }

  preTask(int index) async {
    switch (index) {
      case 0:
        if (mTaskPosition > 0) {
          mTaskPosition--;
        }
        break;
      case 1:
        if (mPaperPosition > 0) {
          mPaperPosition--;
        }
        break;
      case 2:
        if (mEquPosition > 0) {
          mEquPosition--;
        }
        await initRissData();
        break;
    }
    setState(() {});
  }
}
