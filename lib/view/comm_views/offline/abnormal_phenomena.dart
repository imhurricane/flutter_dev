import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/view/comm_views/components/comm_bottom_action.dart';
import 'package:flutter_dev/view/comm_views/components/float_button.dart';
import 'package:flutter_dev/view/comm_views/components/picture_show.dart';
import 'package:flutter_dev/view/comm_views/components/task_check_view.dart';
import 'package:flutter_dev/view/comm_views/moudel/detail_info.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/riss.dart';

class AbnormalPhenomena extends StatefulWidget {
  final Riss mRiss;

  AbnormalPhenomena({
    this.mRiss,
  });

  @override
  State<StatefulWidget> createState() {
    return AbnormalPhenomenaState();
  }
}

class AbnormalPhenomenaState extends State<AbnormalPhenomena> {
  FocusNode blankNode = FocusNode();
  List<LocalMedia> images = List<LocalMedia>();
  List<String> imgPaths = List();
  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.text = widget.mRiss.errdetail;
    if(null != widget.mRiss.imgPath){

      List<String> split = widget.mRiss.imgPath.replaceAll("]", "").replaceAll("[", "").replaceAll(" ","").split(",");
      split.forEach((element) {
        LocalMedia localMedia = LocalMedia();
        localMedia.path=element;
        localMedia.loadPictureType=LoadPictureType.file;
        images.add(localMedia);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
          ];
        },
        controller: ScrollController(),
        body: Container(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(blankNode);
            },
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
                  LocalMedia localMedia = LocalMedia();
                  localMedia.realPath = imagePath;
                  localMedia.path = imagePath;
                  localMedia.loadPictureType = LoadPictureType.file;
                  setState(() {
                    images.add(localMedia);
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
                  LocalMedia localMedia = LocalMedia();
                  localMedia.realPath = imagePath;
                  localMedia.path = imagePath;
                  localMedia.loadPictureType = LoadPictureType.file;
                  setState(() {
                    images.add(localMedia);
                  });
                }
              },
              value: "相册",
            ),
            FloatButton(
              onPressed: () async{
                FocusScope.of(context).requestFocus(blankNode);
                images.forEach((element) {
                  imgPaths.add(element.path);
                });
                widget.mRiss.imgPath=imgPaths.toString();
                widget.mRiss.errdetail=textEditingController.text.trim();
                RissProvider rissProvider = RissProvider();
                await rissProvider.update(widget.mRiss, false);
                await CommUtils.showDialog(context, "提示", "保存成功", false,okOnPress: (){});
              },
              value: "保存",
            ),
          ],
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
                  image: images == null ? "" : images,
                  columnSize: 3,
                ),
              )
            : Container(),
      ),
    );
  }
}
