import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';

import 'moudel/riss_complete.dart';

class UploadTaskPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UploadTaskPageState();
  }
}

class UploadTaskPageState extends State<UploadTaskPage> {
  int mTotalCount;
  int mUploadCount;
  double progressValue;
  String mButtonStr;

  List<RissComplete> mRissCompleteList;

  @override
  void initState() {
    super.initState();
    mRissCompleteList = List();
    mTotalCount = 0;
    mUploadCount = 0;
    progressValue=0;
    mButtonStr = "数据上传";
    initCompleteTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("数据上传"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top:20.0,left: 8.0,right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "已上传:    "+ (mUploadCount>0?(progressValue * 100).toString()+"%":"0/"+mTotalCount.toString()).toString(),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 4,
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: SizedBox(
                height: 8.0,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.lightBlue,
                  value: progressValue,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colors.lightBlue,
              textColor: Colors.white,
              splashColor: Colors.grey,
              child: Text("  $mButtonStr  "),
              onPressed: () {
                if(mButtonStr.length>4){
                  return null;
                }else{
                  if((mTotalCount-mUploadCount)>0){
                    uploadTask();
                  }else{
                    CommUtils.showDialog(context, "提示", "没有待上传数据", false,okOnPress: (){});
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  initCompleteTask() async{
    RissCompleteProvider rissCompleteProvider = RissCompleteProvider();
    mRissCompleteList = await rissCompleteProvider.selectRissByIsUpload("0");
    mTotalCount = mRissCompleteList.length;
    mRissCompleteList.forEach((element) {
      print('element:'+element.toJson().toString());
    });
    setState(() {});
  }

  uploadTask() async{
    setState(() {
      mUploadCount=0;
      mButtonStr = "正在上传请稍后...";
    });
    List<RissComplete> list = mRissCompleteList;
    for(int i =0;i<list.length;i++){
      RissComplete rissComplete = list[i];
      var baseMap = DataHelper.getBaseMap();
      baseMap.clear();
      baseMap['data']=rissComplete.toJson();
      ResultData result =
      await HttpManager.getInstance().post(Address.UploadTask_URL, baseMap);
      if (result.code != 200) {
        CommUtils.showDialog(context, "提示", result.data, false, okOnPress: () {});
      } else {
        Map<String, dynamic> json = jsonDecode(result.data);
        if(json['code']==200){
          print(json['msg']);
          RissCompleteProvider rissCompleteProvider = RissCompleteProvider();
          RissComplete rissComplete = await rissCompleteProvider.getRissById(json['data']);
          rissComplete.isUpload="1";
          rissCompleteProvider.update(rissComplete);

          setState(() {
            if(mUploadCount<mTotalCount){
              mUploadCount++;
              String str = (mUploadCount/mTotalCount).toString();
              str = str.substring(0,str.length>6?6:str.length);
              print('str:'+str);
              progressValue = double.parse(str);
            }
            mButtonStr = "重新上传";
          });
        }
      }
    }
  }



}
