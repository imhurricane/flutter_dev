import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dev/moudel/VideoModel.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  String value;
  VideoModel videoModel;

  VideoPage(this.value, this.videoModel);

  @override
  State<StatefulWidget> createState() {
    return VideoPageState();
  }
}

class VideoPageState extends State<VideoPage> {
  VideoPlayerController mVideoPlayerController;
  Future mVideoPlayerFuture;

  List<String> nameItems = <String>['微信', '朋友圈', 'QQ', 'QQ空间', '微博', '链接'];
  List<String> urlItems = [
    "resources/images/weChart.png",
    "resources/images/pyq.png",
    "resources/images/QQ.png",
    "resources/images/QQZ.png",
    "resources/images/wb.png",
    "resources/images/lj.png"
  ];

  @override
  void initState() {
    super.initState();
    mVideoPlayerController =
        new VideoPlayerController.network(widget.videoModel.videoUrl);
    mVideoPlayerFuture = mVideoPlayerController.initialize().then((_) => {
          //视频初始化完成
          //调用播放
          mVideoPlayerController.play(),
          setState(() {}),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //播放视频
        buildVideoWidget(),
        //控制按钮
        buildControllerWidget(),
        //底部视频简介
        buildBottomWidget(),
        //右侧用户操作
        buildUserWidget(),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    mVideoPlayerController.dispose();
  }

  buildVideoWidget() {
    return FutureBuilder(
      future: mVideoPlayerFuture,
      builder: (BuildContext context, value) {
        if (value.connectionState == ConnectionState.done) {
          return InkWell(
            onTap: () {
              //初始化是否完成
              if (mVideoPlayerController.value.initialized) {
                //视频是否正在播放
                if (mVideoPlayerController.value.isPlaying) {
                  mVideoPlayerController.pause();
                } else {
                  mVideoPlayerController.play();
                }
                setState(() {});
              } else {
                mVideoPlayerController.initialize().then((value) => {
                      mVideoPlayerController.play(),
                      setState(() {}),
                    });
              }
            },
            child: Center(
              child: AspectRatio(
                //设置视频比例大小
                aspectRatio: mVideoPlayerController.value.aspectRatio,
                //视频播放组件
                child: VideoPlayer(mVideoPlayerController),
              ),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  buildControllerWidget() {
    Widget itemWidget = Container();
    if (mVideoPlayerController.value.initialized &&
        !mVideoPlayerController.value.isPlaying) {
      itemWidget = InkWell(
        onTap: () {
          if (mVideoPlayerController.value.initialized &&
              !mVideoPlayerController.value.isPlaying) {
            mVideoPlayerController.play();
            setState(() {});
          }
        },
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.all(Radius.circular(22))),
          child: Icon(Icons.play_circle_outline),
        ),
      );
    }
    return Align(
      alignment: Alignment(0, 0),
      child: itemWidget,
    );
  }

  buildBottomWidget() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 10),
        height: 180,
        color: Color(0x60ffffff),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "@程序狗们",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "十年生死两茫茫，不思量，自难忘。千里孤坟，无处话凄凉。纵使相逢应不识，尘满面，鬓如霜。夜来幽梦忽还乡，小轩窗，正梳妆。相顾无言，惟有泪千行。料得年年肠断处，明月夜，短松冈。",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  buildUserWidget() {
    return Align(
      alignment: Alignment(1, 0.2),
      child: Container(
        width: 40,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //用户头像信息
            buildUserItem(),
            //喜欢
            buildLikeWidget(
                assetImg: widget.videoModel.isLike
                    ? "resources/images/like.png"
                    : "resources/images/unlike.png",
                count: 1231,
                callBack: () {}),
            //评论
            buildLikeWidget(
                assetImg: "resources/images/pl.png",
                count: 12,
                callBack: () {
                  sowBottomWidget(1);
                }),
            //转发
            buildLikeWidget(
                assetImg: "resources/images/zf.png",
                count: 231,
                callBack: () {
                  sowBottomWidget(2);
                }),
          ],
        ),
      ),
    );
  }

  buildUserItem() {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Align(
            alignment: Alignment(0, 0),
            child: ClipOval(
              child: Container(
                width: 36,
                height: 36,
                color: Colors.white70,
                child: CachedNetworkImage(
                  imageUrl: widget.videoModel.videoImg,
                  placeholder: (context, url) => CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          widget.videoModel.isAttention
              ? Container()
              : Align(
                  alignment: Alignment(0, 1),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                    child: Text(
                      "+",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  buildLikeWidget({String assetImg, int count, callBack}) {
    return InkWell(
      onTap: callBack,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              assetImg,
              width: 33,
              height: 33,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "$count",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void sowBottomWidget(int i) {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          if (1 == i) {
            return commentItemWidget();
          } else {
            return shareItemWidget();
          }
        });
  }

  Widget commentItemWidget() {
    return Container(
      height: 240,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Stack(
            children: [
              Align(
                alignment: Alignment(0, 0),
                child: Text(
                  "评论区",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Align(
                alignment: Alignment(1, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.clear,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return buildCommentItemWidget();
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget shareItemWidget() {
    return Container(
      height: 260,
      padding: EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Container(
              height: 210,
              child: GridView.builder(
                  itemCount: nameItems.length,
                  padding: EdgeInsets.only(top: 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 6, right: 6),
                          child: Image.asset(
                            urlItems[index],
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text(
                          nameItems[index],
                        ),
                      ],
                    );
                  }),
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              height: 20,
              alignment: Alignment.center,
              child: Text("取消"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommentItemWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: Container(
              width: 30,
              height: 30,
              child: Image.asset(
                "resources/images/pl.png",
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "写程序的诗人",
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
                Text(
                  "江山代有才人出，各领风骚数百年，你一年来我一年。。。",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                Align(
                  alignment: Alignment(-1, 0),
                  child: Container(
                    margin: EdgeInsets.only(top: 6),
                    padding: EdgeInsets.only(left: 6, right: 6),
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: Text(
                      "12分钟前",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
