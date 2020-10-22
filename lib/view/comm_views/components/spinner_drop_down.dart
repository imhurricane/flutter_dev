import 'package:flutter/material.dart';
import 'package:flutter_dev/view/comm_views/moudel/selects.dart';

typedef _SelectCallBack = void Function(dynamic);
typedef _PreCallBack = void Function();
typedef _NextCallBack = void Function();

class SpinnerDropDown extends StatefulWidget {

  final List<String> mData;
  final int mDataPosition;
  final _SelectCallBack selectCallBack;
  final _PreCallBack preCallBack;
  final _NextCallBack nextCallBack;

  const SpinnerDropDown({
    Key key,
    @required
    this.mData,
    @required
    this.mDataPosition,
    @required
    this.preCallBack,
    @required
    this.nextCallBack,
    this.selectCallBack,
  }) : super(key: key);

  @override
  _SpinnerDropDownState createState() => _SpinnerDropDownState();
}

class _SpinnerDropDownState extends State<SpinnerDropDown> {

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: widget.preCallBack,
          child: Icon(
            Icons.chevron_left,
            size: 36,
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey[200],
            height: 40,
            width: double.infinity,
            padding: EdgeInsets.only(left: 20,right: 20),
            alignment: Alignment.center,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: widget.mData.length>0?widget.mData[widget.mDataPosition]:"",
                  isExpanded: true,
                  icon: Container(),
                  items: buildItems(),
                  onChanged: widget.selectCallBack
                  ),
            ),
          ),
        ),
        InkWell(
          onTap: widget.nextCallBack,
          child: Icon(
            Icons.chevron_right,
            size: 36,
          ),
        ),
      ],
    );
  }

  buildItems() {
    List<DropdownMenuItem<String>> items = List();
    if(widget.mData.length>0){
      widget.mData.forEach((element) {
        items.add(DropdownMenuItem(
            value:element,
            child: Center(
                child: Text(element,maxLines: 1,)
            )
        ));
      });
    }
    return items;
  }
}
