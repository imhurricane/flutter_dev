import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/moudel/user_bean.dart';
import 'package:flutter_dev/view/comm_views/components/comm_bottom_action.dart';
import 'package:flutter_dev/view/comm_views/components/float_button.dart';
import 'package:flutter_dev/view/comm_views/components/picture_show.dart';
import 'package:flutter_dev/view/comm_views/components/task_check_view.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/riss.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';

import 'moudel/image.dart';
import 'moudel/riss_complete.dart';

class AbnormalPhenomena extends StatefulWidget {
  final Riss mRiss;
  final String mPaerXtm;

  AbnormalPhenomena({
    this.mRiss,
    this.mPaerXtm
  });

  @override
  State<StatefulWidget> createState() {
    return AbnormalPhenomenaState();
  }
}

class AbnormalPhenomenaState extends State<AbnormalPhenomena> {
  FocusNode blankNode = FocusNode();
  List<LocalMedia> images = List<LocalMedia>();
  TextEditingController textEditingController;
  LoginUser loginUser;
  List<String> popupActions = List();
  bool isSaved=true;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.text = widget.mRiss.errdetail;
    loginUser = loginUser = LoginUser.fromJson(StorageUtils.getModelWithKey("userInfo"));
    popupActions.add("删除");
    popupActions.add("设为待上传");
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(blankNode);
      },
      child: WillPopScope(
        onWillPop: () async{
          if(!isSaved){
            CommUtils.showDialog(context, "提示", "数据未保存，是否保存？", true,okOnPress: (){
              save();
              return false;
            },cancelOnPress: (){
              Navigator.of(context).pop();
              return true;
            });
          }
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  title: Text("异常信息"),
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () {
                      checkSaved();
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ];
            },
            controller: ScrollController(),
            body: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRissInfo(),
                  buildTextField(),
                  buildPicture(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatButton(
                  onPressed: () async {
                    CommBottomAction.result = "";
                    String imagePath = await CommBottomAction.action(context, 1005);
                    if (null != imagePath && imagePath.length > 0) {
                      setState(() {
                        addPicture(imagePath);
                      });
                    }
                  },
                  value: "拍照",
                ),
                FloatButton(
                  onPressed: () async {
                    CommBottomAction.result = "";
                    String imagePath = await CommBottomAction.action(context, 1004);
                    if (null != imagePath && imagePath.length > 0) {
                      print('imagePath：'+imagePath);
                      setState(() {
                        addPicture(imagePath);
                      });
                    }
                  },
                  value: "相册",
                ),
                FloatButton(
                  onPressed: () async{
                    await save();
                  },
                  value: "保存",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildRissInfo() {
    return TaskCheck(
      top: 10,
      left: 20,
      right: 20,
      riss: widget.mRiss,
      checkedCallBack: (riss) {
        setState(() {
          widget.mRiss.activemesure=riss.activemesure;
          widget.mRiss.inactivemesure=riss.inactivemesure;
          widget.mRiss.havemesure=riss.havemesure;
          isSaved = false;
        });
      },
    );
  }

  buildTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
      child: TextField(
        maxLines: 8,
        controller: textEditingController,
        onChanged: (str){
          isSaved = false;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(2.0),
          hintText: '请输入异常信息',
          counterText: "",
          hintStyle: TextStyle(color: Color(0xff9e51ff)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(
//              color: Color(0xff9e51ff),
//            ), //这个不生效
          ),
          enabledBorder: OutlineInputBorder(
            //未选中时候的颜色
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Color(0xff9e51ff),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //选中时外边框颜色
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Color(0xff9e51ff),
            ),
          ),
        ),
      ),
    );
  }

  buildPicture() {
    return Expanded(
      child: Container(
        child: images.length > 0
            ? Container(
                margin: EdgeInsets.only(top: 8.0, left: 20, right: 20),
                padding: EdgeInsets.all(0.0),
                child: PictureShow(
                  popupActions: popupActions,
                  onLongPressCallBack: (menuIndex,index) async{
                    switch(menuIndex){
                      case 0:
                        widget.mRiss.image.removeAt(index);
                        await CommUtils.showDialog(context, "提示", "删除成功!", false,okOnPress: (){isSaved = false;});
                        break;
                      case 1:
                        widget.mRiss.image[index].isUpload=false;
                        await CommUtils.showDialog(context, "提示", "设置成功!", false,okOnPress: (){isSaved = false;});
                        break;
                    }
                    initData();
                    setState(() {

                    });
                  },
                  image: images == null ? "" : images,
                  columnSize: 3,
                ),
              )
            : Container(),
      ),
    );
  }

  initData() {
    images.clear();
    if(null != widget.mRiss.image){
      widget.mRiss.image.forEach((element) {
        LocalMedia localMedia = LocalMedia();
        localMedia.path=element.path;
        localMedia.loadPictureType=LoadPictureType.file;
        images.add(localMedia);
      });
    }
  }

  save() async{
    FocusScope.of(context).requestFocus(blankNode);
    List<RissImages> images = List();
    images.forEach((element) {
      RissImages rissImages = RissImages();
      rissImages.path=element.path;
      rissImages.date=DateUtil.formatDate(DateTime.now(),format: "yyyy-MM-dd HH:mm:ss");
      rissImages.yhxtm=loginUser.yhxtm;
      images.add(rissImages);
    });
    widget.mRiss.errdetail=textEditingController.text.trim();
    RissProvider rissProvider = RissProvider();
    await rissProvider.update(widget.mRiss, true);
    RissComplete rissComplete = RissComplete();
    rissComplete.xtm=widget.mRiss.xtm;
    rissComplete.errdetail=widget.mRiss.errdetail;
    rissComplete.parentxtm=widget.mRiss.parentxtm;
    rissComplete.rwxtm=widget.mRiss.rwxtm;
    rissComplete.pjjb=widget.mRiss.pjjb;
    rissComplete.riskfactors=widget.mRiss.riskfactors;
    rissComplete.fxffcs=widget.mRiss.fxffcs;
    rissComplete.inactivemesure=widget.mRiss.inactivemesure;
    rissComplete.activemesure=widget.mRiss.activemesure;
    rissComplete.havemesure=widget.mRiss.havemesure;
    rissComplete.checkData=DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");;
    rissComplete.isUpload="0";
    rissComplete.yhXtm=loginUser.yhxtm;
    rissComplete.image=widget.mRiss.image;
    rissComplete.paperXtm=widget.mPaerXtm;
    RissCompleteProvider rissCompleteProvider = RissCompleteProvider();
    await rissCompleteProvider.insertRiss(rissComplete);
    await CommUtils.showDialog(context, "提示", "保存成功", false,okOnPress: (){});
    isSaved=true;
  }

  addPicture(String imagePath){
    RissImages rissImages = RissImages();
    rissImages.path=imagePath;
    rissImages.yhxtm=loginUser.yhxtm;
    rissImages.date=DateUtil.formatDate(DateTime.now(),format: "yyyy-MM-dd HH:mm:ss");
    rissImages.isUpload=false;
    if(widget.mRiss.image == null){
      widget.mRiss.image = List<RissImages>();
    }
    widget.mRiss.image.add(rissImages);
    initData();
    isSaved = false;
  }

  checkSaved() async{
    if(!isSaved){
      CommUtils.showDialog(context, "提示", "数据未保存，是否保存？", true,okOnPress: (){
        save();
      },cancelOnPress: (){
        Navigator.of(context).pop();
      });
    }else{
      Navigator.of(context).pop();
    }
  }
}
