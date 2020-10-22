
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpinnerWidget extends StatefulWidget{
  List<String> _list;
  final double left,right,bottom,top,height,width,iconLeft;
  final String title;
  final Color bgColor;
  String content;
  final Function backSelector;
  TextStyle textStyle;

  SpinnerWidget(this.title,this._list,{this.left,this.right,this.bottom,this.top,
    this.height,this.width,this.bgColor,this.content,this.iconLeft,this.textStyle,
    this.backSelector,
  });
  @override
  State createState() {
    return SpinnerState();
  }
}

class SpinnerState extends State<SpinnerWidget>{
  @override
  Widget build(BuildContext context) {
    return
      Padding(
          padding: EdgeInsets.only(left: widget.left??0, right: widget.right??0, bottom:widget.bottom?? 0,top: widget.top??0),
          child: GestureDetector(
            child: Container(
              height: widget.height??50,
              width: widget.width??double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.bgColor),
              child: PopupMenuButton(itemBuilder: (ctx) {
                return widget._list.map((value) {
                  return PopupMenuItem<String>(
                      child: Text("$value"), value: "$value");
                }).toList();
              },
                child: Row(
                  children: <Widget>[
                    Text("${widget.title}",style: widget.textStyle??null,),
                    Padding(padding: EdgeInsets.only(left: 10),),
                    Text("${widget.content}",style: widget.textStyle??null,),
                    Padding(padding: EdgeInsets.only(left: widget.iconLeft??60),
                      child: Icon(Icons.arrow_drop_down),)
                  ],
                ),
                onSelected: (String action){
                  setState(() {
                    widget.backSelector(action);
                  });
                },
              ),
            ),
          ));
  }
}
class SpinnerCustomItemWidget<T> extends StatefulWidget{
  final double left,right,bottom,top,height,width;
  final String title;
  final Color bgColor;
  List<T> list;
  String content;
  final Function backSelector;
  final Function backWidget;
  SpinnerCustomItemWidget(this.title,this.list,this.backWidget,{this.left,this.right,this.bottom,this.top,
    this.height,this.width,this.bgColor,this.content,
    this.backSelector,
  });
  @override
  State createState() {
    return SpinnerCustomItemState<T>();
  }
}

class SpinnerCustomItemState<T> extends State<SpinnerCustomItemWidget>{
  @override
  Widget build(BuildContext context) {
    return
      Padding(
          padding: EdgeInsets.only(left: widget.left??0, right: widget.right??0, bottom:widget.bottom?? 0,top: widget.top??0),
          child: GestureDetector(
            child: Container(
              height: widget.height??50,
              width: widget.width??double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.bgColor),
              child: PopupMenuButton(itemBuilder: (ctx) {
                return widget.list.map((value) {
                  return PopupMenuItem<T>(
                      child: widget.backWidget(widget.list.indexOf(value)), value: value);
                }).toList();
              },
                child: Row(
                  children: <Widget>[
                    Text("${widget.title}"),
                    Padding(padding: EdgeInsets.only(left: 10),),
                    Text("${widget.content}"),
                    Padding(padding: EdgeInsets.only(left: 60),
                      child: Icon(Icons.arrow_drop_down),)
                  ],
                ),
                onSelected: (T action){
                  setState(() {
                    widget.backSelector(action);
                  });
                },
              ),
            ),
          ));
  }
}