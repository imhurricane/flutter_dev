import 'package:flutter/material.dart';
import 'package:flutter_dev/view/comm_views/dropdown/dropdown_search.dart';
import 'package:flutter_dev/view/comm_views/moudel/selects.dart';

typedef _SelectCallBack = void Function(Selects);

class FromDropDownSearch extends StatefulWidget {
  final List<Selects> selects;
  final _SelectCallBack selectCallBack;
  final bool showDropDownButton;
  final bool showDropClearButton;
  final double height;

  const FromDropDownSearch({
    Key key,
    @required this.selects,
    this.showDropDownButton = true,
    this.showDropClearButton = true,
    this.height = 40.0,
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
      height: widget.height,
      child: DropdownSearch<Selects>(
        mode: Mode.BOTTOM_SHEET,
        popupBackgroundColor: Colors.white,
//        isFilteredOnline: true,

        showDropDownButton: widget.showDropDownButton,
        showClearButton: widget.showDropClearButton,
        showSearchBox: true,
        enabled: true,
        //只读
        dropdownSearchDecoration: InputDecoration(
            filled: false,
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
            fillColor: Colors.white),
        items: widget.selects,
        itemAsString: (select){
          return select.desc;
        },
        selectedItem: getSelectedItem(widget.selects),
        onChanged: widget.selectCallBack,
        dropdownBuilder: _customDropDownExample,
        popupItemBuilder: _customPopupItemBuilderExample,
      ),
    );
  }

  getSelectedItem(List<Selects> selects) {
    for (int i = 0; i < selects.length; i++) {
      if (selects[i].isChecked) {
        return selects[i];
      }
    }
  }

  Widget _customDropDownExample(
      BuildContext context, Selects item, String itemDesignation) {
    return Container(
      alignment: Alignment.centerLeft,
//      padding: EdgeInsets.only(right: -10),
      child: Text(item?.desc==null?"":item?.desc,maxLines: 1,style: TextStyle(fontSize: 17),),
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
