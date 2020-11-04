import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/view/comm_views/moudel/selects.dart';

typedef _SelectCallBack = void Function(Selects);
typedef _PreCallBack = void Function();
typedef _NextCallBack = void Function();

class FromSpinnerSearch extends StatefulWidget {

  final List<Selects> selects;
  final bool isMulti;
  final _SelectCallBack selectCallBack;
  final _PreCallBack preCallBack;
  final _NextCallBack nextCallBack;

  const FromSpinnerSearch({
    Key key,
    @required
    this.selects,
    this.isMulti = false,
    this.selectCallBack,
    this.preCallBack,
    this.nextCallBack,
  }) : super(key: key);

  @override
  _FromSpinnerSearchState createState() => _FromSpinnerSearchState();
}

class _FromSpinnerSearchState extends State<FromSpinnerSearch> {
  @override
  void initState() {
    super.initState();
  }

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
            color: Colors.lightBlue,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.lightBlue, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
//            color: Colors.grey[200],
            height: 40,
            width: double.infinity,
            padding: EdgeInsets.only(left: 20,right: 20),
            alignment: Alignment.center,
            child: Container(
              child: DropdownSearch<Selects>(
                mode: Mode.BOTTOM_SHEET,
                popupBackgroundColor: Colors.white,
//        isFilteredOnline: true,
                showClearButton: false,
//                showSearchBox: true,

                enabled: true,//只读
//                autoFocusSearchBox: false,//默认打开键盘
                showDropDownButton: false,
                dropdownBuilderSupportsNullItem: true,
                dropdownSearchDecoration: InputDecoration(
                    filled: false,
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    fillColor: Colors.white),
                items: widget.selects,
                selectedItem: getSelectedItem(widget.selects),
                onChanged: widget.selectCallBack,
                dropdownBuilder: _customDropDownExample,
                popupItemBuilder: _customPopupItemBuilderExample,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: widget.nextCallBack,
          child: Icon(
            Icons.chevron_right,
            size: 36,
            color: Colors.lightBlue,
          ),
        ),
      ],
    );
  }

  getSelectedItem(List<Selects> selects) {
    for(int i=0;i<selects.length;i++){
      if(selects[i].isChecked){
        return selects[i];
      }
    }
  }
  Widget _customDropDownExample(
      BuildContext context, Selects item, String itemDesignation) {
    return Container(
      alignment: Alignment.center,
//      padding: EdgeInsets.only(right: -10),
      child: Text(item?.desc==null?"":item?.desc,maxLines: 1,),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, Selects item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.desc==null?"":item?.desc),
      ),
    );
  }
}
