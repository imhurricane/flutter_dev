import 'package:flutter/material.dart';
import 'package:flutter_dev/view/comm_views/moudel/selects.dart';

class CheckBoxSelect extends StatefulWidget {

  final List<Selects> selects;
  final int itemCount;
  final bool isMulti;

  const CheckBoxSelect({
    Key key,
    this.selects,
    this.itemCount,
    this.isMulti = false,
  }) : super(key: key);

  @override
  _CheckBoxSelectState createState() => _CheckBoxSelectState();
}

class _CheckBoxSelectState extends State<CheckBoxSelect> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double childAspectRatio = 0;
    switch (widget.itemCount) {
      case 1:
        childAspectRatio = 8;
        break;
      case 2:
        childAspectRatio = 4;
        break;
      case 3:
        childAspectRatio = 2;
        break;
      default:
        childAspectRatio = 1;
        break;
    }
    return InkWell(
      child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GridView.builder(
            itemCount: widget.selects.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0.0),
            //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //横轴元素个数
                crossAxisCount: widget.itemCount,
                //纵轴间距
                mainAxisSpacing: 0.0,
                //横轴间距
                crossAxisSpacing: 0.0,
                //子组件宽高长度比例
                childAspectRatio: childAspectRatio),
            itemBuilder: (BuildContext context, int index) {
              //Widget Function(BuildContext context, int index)
              return buildGridItem(widget.selects, index);
            }),
      ]),
    );
  }

  buildGridItem(List<Selects> selects, int index) {
    return Ink(
      child: InkWell(
        splashColor: Colors.grey[100],
        focusColor: Colors.grey[200],
        onTap: () {
          setState(() {
            selects[index].isChecked = !selects[index].isChecked;
            if(!widget.isMulti){
              for (int i = 0; i < selects.length; i++) {
                if (i != index) {
                  selects[i].isChecked = false;
                }
              }
            }

          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  selects[index].value,
                  style: TextStyle(color: selects[index].isChecked
                          ? Colors.blueAccent : Colors.black),
                ),
              ),
              Expanded(
                child: Checkbox(
                  value: selects[index].isChecked,
                  onChanged: (value) {
                    setState(() {
                      if(!widget.isMulti){
                        for (int i = 0; i < selects.length; i++) {
                          selects[i].isChecked = false;
                        }
                      }
                      selects[index].isChecked = value;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
