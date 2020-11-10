import 'dart:collection';
import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/date_picker_tool.dart';
import 'package:flutter_dev/comm/device_info.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:flutter_dev/view/comm_views/components/check_box_select_.dart';
import 'package:flutter_dev/view/comm_views/components/comm_bottom_action.dart';
import 'package:flutter_dev/view/comm_views/components/drop_down.dart';
import 'package:flutter_dev/view/comm_views/components/float_button.dart';
import 'package:flutter_dev/view/comm_views/components/form_Input_cell.dart';
import 'package:flutter_dev/view/comm_views/components/page_loading.dart';
import 'package:flutter_dev/view/comm_views/components/picture_show.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';
import 'package:multiple_select/Item.dart';
import 'package:multiple_select/multi_filter_select.dart';
import 'package:multiple_select/multiple_select.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'detail_page_item.dart';

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
  DetailData detailData;
  final double titleContentSpaces = 10;
  final double titleSpaces = 106;
  final Alignment titlePosition = Alignment.centerRight;
  final controller = TextEditingController();

  final TextStyle titleStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w100,
  );
  final TextStyle contentStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  ///  点击非textField关闭键盘
  FocusNode blankNode = FocusNode();
  bool selected = false;
  ScrollController scrollController;
  List<DetailPageItem> pageItems;
  List<LocalMedia> images = new List<LocalMedia>();

  @override
  void initState() {
    super.initState();
    detailData = new DetailData();
    initMenu();
    initData();

    scrollController = new ScrollController();
    scrollController.addListener(() {
//      print('${scrollController.position}');
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
        body: Container(
          child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (BuildContext listContext, bool flag) {
              return [
                SliverAppBar(
                  pinned: true,
                  title: Text(detailData.itemDetailColumns == null ? ""
                      : detailData.itemDetailColumns[0].pageTitle,style: TextStyle(fontSize: 20),),
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
                        CommBottomAction.result = "";
                        final result = await showMenu(
                          color: Colors.grey[700],
                            context: context,
                            position: RelativeRect.fromLTRB(4000.0, 90.0, 0.0, 100.0),
                            items: buildTopRightButton()
                            );
                        if(null != result){
                          String imagePath = await CommBottomAction.action(context,int.parse(result));
                          if(null != imagePath && imagePath.length>0){
                            LocalMedia localMedia = LocalMedia();
                            localMedia.realPath=imagePath;
                            localMedia.path=imagePath;
                            localMedia.loadPictureType=LoadPictureType.file;
                            setState(() {
                              images.add(localMedia);
                            });
                            uploadPicture(imagePath);
                          }
                        }

                      },
                      icon: Icon(Icons.menu),
                    ),
                  ],
                ),
              ];
            },
            body: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(blankNode);
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 16.0),
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

          ),
        ),
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buildBottomButton(detailData.itemDetailButtons),
        ),
      ),
    );
  }

  onLoading() async {
    mRefreshController.loadComplete();
//    mRefreshController.loadNoData();
  }

  Future onRefresh() async {

    setState(() {
      initData();
    });
    mRefreshController.refreshCompleted();
  }

  initMenu(){
    DetailPageItem detailPageItem = DetailPageItem(
      xh: 1,
      itemType: PageItemType.column,
    );
    DetailPageItem detailPageItemPicture = DetailPageItem(
      xh: 2,
      itemType: PageItemType.picture,
    );
    pageItems = List<DetailPageItem>();

    pageItems.add(detailPageItem);
    pageItems.add(detailPageItemPicture);
    /// 按序号排序
    pageItems.sort((a,b)=>(a.xh).compareTo(b.xh));
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
      Map<String, dynamic> json = jsonDecode(result.data);
      setState(() {
        detailData = DetailData.fromJson(json);
        images = detailData.iconInfoList?.localMedia;
      });
    } else {
      CommUtils.showDialog(context, "提示", "${result.data}", false,
          okOnPress: () {});
    }
  }

  uploadPicture(imagePath) async{
    var deviceId = await DeviceInfo.getDeviceInfo();

    var params = HashMap<String,dynamic>();
    params['a']="b";
    params['type']="p";
    params['tablename']=detailData.tableName;
    params['yhxtm']=CommUtils.getUserInfo().yhxtm;
    params['photolocpath']=imagePath;
    params['devicextm']=deviceId;
    params['riskxtm']=widget.detailPage.id;
    params['suggetstxtm']="";
    params['time']=DateUtil.formatDate(DateTime.now());

    await HttpManager.getInstance().uploadPicture(Address.DetailPageIconUrl, params , imagePath);
  }

  buildBody() {
    if(detailData.itemDetailColumns != null && !TextUtil.isEmpty(detailData.itemDetailColumns.toList().toString())){
      return ListView.builder(
        itemBuilder: (BuildContext context,int index){
          return buildPageItem(index);
        },
        itemCount: pageItems?.length,
      );
    }else{
      return PageLoading(
        iconColor: Colors.grey,
      );
    }
  }

  buildPageItem(int index) {
    switch(pageItems[index].itemType){
      case PageItemType.column:
        return buildColumn();
        break;
      case PageItemType.picture:
        return buildPicture();
        break;
    }
  }

  buildPicture(){
   return  GestureDetector(
     onTap: () {
       FocusScope.of(context).requestFocus(blankNode);
     },
     child: images.length>0?Container(
        child: PictureShow(
          image: images==null?"":images,
          columnSize:3,
        ),
      ):Container(),
   );
  }

  buildColumn(){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(blankNode);
      },
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0.0),
          cacheExtent: 30.0,
          itemCount: detailData.itemDetailColumns == null ? 0
              : detailData.itemDetailColumns.length,
          itemBuilder: (BuildContext context, int index) {
            return buildColumnItem(index, detailData.itemDetailColumns[index]);
          }),
    );
  }

  buildColumnItem(int index, ItemDetailColumns item) {
    switch (item.itemType) {
      case 1:
        return buildTextField(index, item);
        break;
      case 2:
        return buildTextField(index, item);
        break;
      case 3:
        return buildDropDown(index);
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
      case 7:
        return buildTextField(index, item);
        break;
      case 8:
        return buildSwitch(index, item);
        break;
      case 9:
        return buildSelectOptions(index);
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
              dateType: DateType.YMD,
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
  buildSelectOptions(int index) {
    ItemDetailColumns item = detailData.itemDetailColumns[index];

    // TODO  需要增加每行显示个数配置
    return FormInputCell(
      space: titleSpaces,
      titlePosition: titlePosition,
      title: item.columnDes == null ? "" : item.columnDes + ":",
      titleStyle: titleStyle,
      titleContentSpaces: titleContentSpaces,
      textWidget: CheckBoxSelect(
        selects: item.selects,
        isMulti: false,
        itemCount: 2,
      ),
    );
  }

  // 下拉菜单
  buildDropDown(int index) {
    ItemDetailColumns item = detailData.itemDetailColumns[index];
    return  FormInputCell(
      space: titleSpaces,
      titlePosition: titlePosition,
      title: item.columnDes == null ? "" : item.columnDes + ":",
      titleStyle: titleStyle,
      titleContentSpaces: titleContentSpaces,
      textWidget: FromDropDownSearch(
        selects: item.selects,
        selectCallBack: (select){
          setState(() {
            for(int i=0;i<item.selects.length;i++){
              if(item.selects[i].value == select.value){
                detailData.itemDetailColumns[index].selects[i].isChecked=true;
                detailData.itemDetailColumns[index].columnValue = select.value;
              }else{
                detailData.itemDetailColumns[index].selects[i].isChecked=false;
              }
            }
          });
        },
      ),
    );
  }

  // 开关
  buildSwitch(int index, ItemDetailColumns item) {
    return FormInputCell(
      space: titleSpaces,
      titlePosition: titlePosition,
      title: item.columnDes == null ? "" : item.columnDes + ":",
      titleStyle: titleStyle,
      textWidget: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0,top:4.0,bottom: 4.0),
            child: CupertinoSwitch(
              value: detailData.itemDetailColumns[index].columnValue=="1"?true:false,
              onChanged: (bool value) {
                String v = value?"1":"0";
                setState(() {
                  detailData.itemDetailColumns[index].columnValue = v;
                });

              },

            ),
          ),
        ],
      ),
    );
  }

  /// 创建底部按钮组
  buildBottomButton(ItemDetailButtons itemDetailButtons) {
    List<Widget> buttons = new List<Widget>();
    if (null != itemDetailButtons) {
      for (int i = 0; i < itemDetailButtons.itemDetailButtonBottom.length; i++) {
        if (i < 4) {
          buttons.add(FloatButton(
            value: itemDetailButtons.itemDetailButtonBottom[i].description,
            onPressed: () async{
              CommBottomAction.result = "";
              String imagePath = await CommBottomAction.action(context,itemDetailButtons.itemDetailButtonBottom[i].buttonType);
              if(null != imagePath && imagePath.length>0){
                LocalMedia localMedia = LocalMedia();
                localMedia.realPath=imagePath;
                localMedia.path=imagePath;
                localMedia.loadPictureType=LoadPictureType.file;
                setState(() {
                  images.add(localMedia);
                });
                uploadPicture(imagePath);
              }
            },
          ));
        }
      }
    }
    return buttons;
  }

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
//                Icon(Icons.add_circle,size: 20,color: Colors.white,),
//                SizedBox(width: 4.0,),
                Text(buttonTopRight[i].description,style: TextStyle(fontSize:18,color: Colors.white),),
              ],
            )));
//        items.add(PopupMenuDivider(height: 1.0));
      }
    }
    return items;
  }

  buildMultipleSelect(int index, ItemDetailColumns item) {

    List<MultipleSelectItem> elements =
    List.generate(item.selects==null?0:item.selects.length, (index) =>
        MultipleSelectItem.build(
            value: index,
            display: item.selects[index].desc==null?"":item.selects[index].desc,
            content: item.selects[index].desc,
        ));
    List _values = [];//item.
    List<Item<num, String, String>> items = List.generate(
      150,
          (index) =>
          Item.build(
            value: index,
            display: '$index display',
            content: '$index content' * (index + 1),
          ),
    );// selects;
    return FormInputCell(
      space: titleSpaces,
      titlePosition: titlePosition,
      title: item.columnDes == null ? "" : item.columnDes + ":",
      titleStyle: titleStyle,
      textWidget: Padding(
        padding: EdgeInsets.only(left:12.0),
        child:
        MultiFilterSelect(
          allItems: items,
          initValue: _values,
          selectCallback: (List selectedValue) => print(selectedValue.length),
        ),
      ),
    );
  }




}
