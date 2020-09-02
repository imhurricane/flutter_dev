import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/date_picker_tool.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:flutter_dev/view/comm_views/components/buttom_location.dart';
import 'package:flutter_dev/view/comm_views/components/check_box_select_.dart';
import 'package:flutter_dev/view/comm_views/components/float_button.dart';
import 'package:flutter_dev/view/comm_views/components/form_Input_cell.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DetailPage extends StatefulWidget {
  final DetailPageInfo detailPage;

  DetailPage(this.detailPage);

  @override
  State<StatefulWidget> createState() {
    return DetailPageState();
  }
}

class DetailPageState extends State<DetailPage>{
  RefreshController mRefreshController = new RefreshController();
  DetailData detailData = new DetailData();
  final double titleContentSpaces = 10;
  final double titleSpaces = 90;
  final Alignment titlePosition = Alignment.centerRight;
  final controller = TextEditingController();

  final TextStyle titleStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  final TextStyle contentStyle = TextStyle(
    color: Colors.black,
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );
  ///  点击非textField关闭键盘
  FocusNode blankNode = FocusNode();
  bool selected = false;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    initData();
    scrollController = new ScrollController();
    scrollController.addListener(() {
      print('${scrollController.position}');
//      print("offset:"+scrollController.offset.toString());
//      if(scrollController.position > 0){
//        FocusScope.of(context).requestFocus(blankNode);
//      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext listContext, bool flag) {
            return [
              SliverAppBar(
                pinned: true,
                title: Text(detailData.itemDetailColumns == null ? ""
                    : detailData.itemDetailColumns[0].pageTitle),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      final result = await showMenu(
//                        color: Colors.grey[700],
                          context: context,
                          position: RelativeRect.fromLTRB(4000.0, 90.0, 0.0, 100.0),
                          items: buildTopRightButton()
                          );
                      // TODO 封装按钮处理类 便于调用
                      debugPrint("asdas:"+result.toString());
                    },
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),
            ];
          },
          body: Container(
              color: Colors.grey[200],
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: WaterDropHeader(
                  waterDropColor: Colors.blue,
                ),
                footer: ClassicFooter(),
                controller: mRefreshController,
                onRefresh: onRefresh,
                onLoading: onLoading,
                child: buildBody(),
              )),
        ),
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buildFloatButton(detailData.itemDetailButtons),
        ),
//        bottomSheet: Text("asdasda"),
//        floatingActionButton:Row(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: buildFloatButton(detailData.itemDetailButtons),
//        ),
//        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
//            FloatingActionButtonLocation.centerFloat, 0, 16),
      ),
    );
  }

  onLoading() async {
    FocusScope.of(context).requestFocus(blankNode);
    mRefreshController.loadComplete();
//    mRefreshController.loadNoData();
  }

  onRefresh() async {
    FocusScope.of(context).requestFocus(blankNode);
    mRefreshController.refreshCompleted();
  }

  initData() async {
    var baseMap = DataHelper.getBaseMap();
    baseMap.clear();
    Map<String, dynamic> user = StorageUtils.getModelWithKey("userInfo");

    debugPrint("page:" + widget.detailPage.detailPageId);
    baseMap['datatype'] = widget.detailPage.dataType;
    baseMap['detailPageId'] = widget.detailPage.detailPageId;
    baseMap['yhxtm'] = user['yhxtm'];
    if (widget.detailPage.params != null) {
      baseMap.addAll(widget.detailPage.params);
    }

    ResultData result =
        await HttpManager.getInstance().get(Address.MenuItemDetailUrl, baseMap);
    if (result.code == 200) {
      debugPrint("data:" + result.data);
      Map<String, dynamic> json = jsonDecode(result.data);
      detailData = DetailData.fromJson(json);
      setState(() {});
    } else {
      CommUtils.showDialog(context, "提示", "${result.data}", false,
          okOnPress: () {});
    }
  }

  buildBody() {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(blankNode);
      },
      child: Container(
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            physics:BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0.0),
            cacheExtent: 30.0,
            itemCount: detailData.itemDetailColumns == null ? 0
                : detailData.itemDetailColumns.length,
            itemBuilder: (BuildContext context, int index) {
              return buildColumn(index, detailData.itemDetailColumns[index]);
            }),
      ),
    );
  }

  buildColumn(int index, ItemDetailColumns item) {
    switch (item.itemType) {
      case 1:
        return buildTextField(index, item);
        break;
      case 2:
        return buildTextField(index, item);
        break;
      case 3:
        return buildTextField(index, item);
        break;
      case 4:
        return buildTextField(index, item);
        break;
      case 5:
        return buildTextField(index, item);
        break;
      case 6:
        return buildDatePicker(index, item);
        break;
      case 9:
        return buildSelectOptions(index, item);
        break;
      default:
        buildTextField(index, item);
        break;
    }
  }


  ///  创建普通可编辑text文本框
  buildTextField(int index, ItemDetailColumns item) {
    return FormInputCell(
      space: titleSpaces,
      title: item.columnDes == null ? "" : item.columnDes + ":",
      titlePosition: titlePosition,
      titleStyle: titleStyle,
      titleContentSpaces: titleContentSpaces,
      text: item.columnValue,
      textStyle: contentStyle,
      enabled: item.isReadOnlyCol == "1" ? false : true,
    );
  }

  ///  创建日期选择行
  buildDatePicker(int index, ItemDetailColumns item) {
    return FormInputCell(
      space: titleSpaces,
      titlePosition: titlePosition,
      title: item.columnDes == null ? "" : item.columnDes + ":",
      titleStyle: titleStyle,
      titleContentSpaces: titleContentSpaces,
      textWidget: InkWell(
          onTap: () {
            DatePickerTool.showDatePicker(
              context,
              dateType: DateType.YMD_HM,
              clickCallback: (selectDateStr, selectDate) {
                String formatDate = DateUtil.formatDateStr(selectDate,
                    format: DateFormats.full);
                setState(() {
                  detailData.itemDetailColumns[index].columnValue = formatDate;
                });
              },
            );
          },
          child: Text(
            DateUtil.formatDateStr(item.columnValue, format: DateFormats.full),
            style: contentStyle,
          )),
    );
  }

  ///  创建单选多选CheckBox
  buildSelectOptions(int index, ItemDetailColumns item) {
    // TODO  需要增加每行显示个数配置
    return FormInputCell(
      space: titleSpaces,
      titlePosition: titlePosition,
      title: item.columnDes == null ? "" : item.columnDes + ":",
      titleStyle: titleStyle,
      titleContentSpaces: titleContentSpaces,
      textWidget: CheckBoxSelect(
        selects: item.selects,
        isMulti: true,
        itemCount: 2,
      ),
    );
  }

  /// 创建底部按钮组
  buildFloatButton(ItemDetailButtons itemDetailButtons) {
    List<Widget> buttons = new List<Widget>();
    if (null != itemDetailButtons) {
      for (int i = 0; i < itemDetailButtons.itemDetailButtonBottom.length; i++) {
        if (i < 4) {
          buttons.add(FloatButton(
            value: itemDetailButtons.itemDetailButtonBottom[i].description,
            onPressed: () {
              // TODO 按钮的处理事件
              debugPrint("as:"+itemDetailButtons.itemDetailButtonBottom[i].toJson().toString());
            },
          ));
        }
      }
    }
    return buttons;
  }

  @override
  bool get wantKeepAlive => true;

  buildTopRightButton() {
    List<PopupMenuEntry<String>> items = new List<PopupMenuEntry<String>>();
    if(null != detailData.itemDetailButtons){
      List<ItemDetailButton> buttonTopRight = detailData.itemDetailButtons.itemDetailButtonTopRight;
      for(int i = 0;i < buttonTopRight.length;i++){
        items.add(PopupMenuItem<String>(
                  value: buttonTopRight[i].buttonType.toString(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline,size: 20,),
                SizedBox(width: 4.0,),
                Text(buttonTopRight[i].description,style: TextStyle(fontSize:18,color: Colors.black),),
              ],
            )));
        items.add(PopupMenuDivider(height: 1.0));
      }
    }
    return items;
  }


}
