import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/view/comm_views/components/check_box_select_.dart';
import 'package:flutter_dev/view/comm_views/components/form_select_cell.dart';
import 'package:flutter_dev/view/comm_views/moudel/selects.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/riss.dart';

typedef _CheckedCallBack = void Function(Riss);

class TaskCheck extends StatefulWidget {

  final _CheckedCallBack checkedCallBack;
  final Riss riss;

  const TaskCheck({
    this.riss,
    this.checkedCallBack,
  });

  @override
  _TaskCheckState createState() => _TaskCheckState();

}

class _TaskCheckState extends State<TaskCheck> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10,left: 36,right: 36),
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: Text("内容："),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.riss.riskfactors}"),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex:2,child: Text("标准：")),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.riss.fxffcs}",),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: widget.riss.activemesure=="1"?true:false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (v) {
                  setState(() {
                    widget.riss.inactivemesure="0";
                    widget.riss.havemesure="0";
                    if(v){
                      widget.riss.activemesure="1";
                    }else{
                      widget.riss.activemesure="0";
                    }
                  });
                  widget.checkedCallBack(widget.riss);
                },

              ),
              Text("有效"),
              Checkbox(
                value: widget.riss.inactivemesure=="1"?true:false,
                onChanged: (v) {
                  setState(() {
                    widget.riss.activemesure="0";
                    widget.riss.havemesure="0";
                    if(v){
                      widget.riss.inactivemesure="1";
                    }else{
                      widget.riss.inactivemesure="0";
                    }
                  });
                  widget.checkedCallBack(widget.riss);
                },
              ),
              Text("无效"),
              Checkbox(
                value: widget.riss.havemesure=="1"?true:false,
                onChanged: (v) {
                  widget.riss.activemesure="0";
                  widget.riss.inactivemesure="0";
                  setState(() {
                    if(v){
                      widget.riss.havemesure="1";
                    }else{
                      widget.riss.havemesure="0";
                    }
                  });
                  widget.checkedCallBack(widget.riss);
                },
              ),
              Text("无措施"),
            ],
          ),
        ],
      ),
    );
  }

}