import 'package:flutter/material.dart';
import 'package:flutter_dev/view/comm_views/dropdown/dropdown_search.dart';
import 'package:flutter_dev/view/comm_views/moudel/selects.dart';

typedef _SelectCallBack = void Function(Selects);

class FromDropDownSearch extends StatefulWidget {

  final List<Selects> selects;
  final bool isMulti;
  final _SelectCallBack selectCallBack;

  const FromDropDownSearch({
    Key key,
    @required
    this.selects,
    this.isMulti = false,
    this.selectCallBack,
  }) : super(key: key);

  @override
  _FromDropDownSearchState createState() => _FromDropDownSearchState();
}

class _FromDropDownSearchState extends State<FromDropDownSearch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: DropdownSearch<Selects>(
        mode: Mode.BOTTOM_SHEET,
        popupBackgroundColor: Colors.white,
//        isFilteredOnline: true,

        showClearButton: true,
        showSearchBox: true,
        enabled: true,//只读
//      label: 'User *',
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
      padding: EdgeInsets.all(0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(item?.desc==null?"":item?.desc,),
      ),
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
