import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/moudel/VideoModel.dart';

import 'find_video_page.dart';

class MainFindPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainFindPageState();
  }
}

class MainFindPageState extends State<MainFindPage>
    with SingleTickerProviderStateMixin {
  List<String> tabTextList = ["关注", "推荐"];
  List<Tab> tabWightList = [];
  TabController mTabController;
  List<VideoModel> videoList = [];
  List<VideoModel> videoList2 = [];

  @override
  void initState() {
    super.initState();
    for (var value in tabTextList) {
      tabWightList.add(Tab(
        text: value,
      ));
    }
    mTabController = new TabController(length: tabTextList.length, vsync: this);
    for (int i = 0; i < 10; i++) {
      VideoModel videoModel = new VideoModel();
      videoModel.videoName = "关注数据";
      videoModel.videoImg = "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2797688287,3624379169&fm=26&gp=0.jpg";
      videoModel.videoUrl = "https://apd-bab5711429d87a6de6ca0438701e3f4e.v.smtcdns.com/om.tc.qq.com/AS-6kPVK8gYkOAASIYFEecPjfP97oibfwDGik0POwt9A/uwMROfz2r5zBIaQXGdGnC2dfDma3J1MItM3912IN4IRQvkRM/f07776csw04.mp4?sdtfrom=v1010&guid=cda7d346386f583fbad7443c28dc78f2&vkey=4E982977F0E17A07DA2C2E938A6C1778A285BD9914BA6118CB576A957C837AF5CDB2133B57F672FDF8B046A5651E3F83733A1FA84A0F791EB23F3463753BB525F9393441049EF8786627260E90EA1D4D7E672D9D135AA9DA5B4EF481B42DC35D8434605034C77DC4F7D7C9C3365BA262B1E25200D412D076488E1A8B916538B2";
      videoModel.parisCount = i * 22;
      if (i % 3 == 0) {
        videoModel.isAttention = true;
        videoModel.isLike = true;
      } else {
        videoModel.isAttention = false;
        videoModel.isLike = false;
      }
      videoList.add(videoModel);
    }
    for (int i = 0; i < 10; i++) {
      VideoModel videoModel = new VideoModel();
      videoModel.videoName = "关注数据";
      videoModel.videoImg = "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2797688287,3624379169&fm=26&gp=0.jpg";
      videoModel.videoUrl = "https://apd-bab5711429d87a6de6ca0438701e3f4e.v.smtcdns.com/om.tc.qq.com/AS-6kPVK8gYkOAASIYFEecPjfP97oibfwDGik0POwt9A/uwMROfz2r5zBIaQXGdGnC2dfDma3J1MItM3912IN4IRQvkRM/f07776csw04.mp4?sdtfrom=v1010&guid=cda7d346386f583fbad7443c28dc78f2&vkey=4E982977F0E17A07DA2C2E938A6C1778A285BD9914BA6118CB576A957C837AF5CDB2133B57F672FDF8B046A5651E3F83733A1FA84A0F791EB23F3463753BB525F9393441049EF8786627260E90EA1D4D7E672D9D135AA9DA5B4EF481B42DC35D8434605034C77DC4F7D7C9C3365BA262B1E25200D412D076488E1A8B916538B2";
      videoModel.parisCount = i * 22;
      if (i % 3 == 0) {
        videoModel.isAttention = true;
        videoModel.isLike = true;
      } else {
        videoModel.isAttention = false;
        videoModel.isLike = false;
      }
      videoList2.add(videoModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildBody() {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              color: Colors.black,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: buildTabView(),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 54,
            bottom: 0,
            child: buildTabBar(),
          ),
        ],
      ),
    );
  }

  buildTabView() {
    return TabBarView(
      controller: mTabController,
      children: tabTextList.map<Widget>((value) =>
          buildTabViewItemWidget(value)).toList(),
    );
  }

  buildTabBar() {
    return Container(
      alignment: Alignment.topCenter,
      child: TabBar(
        indicatorColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: true,
        indicatorWeight: 1,
        tabs: tabWightList,
        controller: mTabController,
      ),
    );
  }

  buildTabViewItemWidget(String value) {
    List<VideoModel> list = [];

    if (value == "推荐") {
      list = videoList;
    } else {
      list = videoList2;
    }
    return PageView.builder(
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          VideoModel videoModel = list[index];
          return VideoPage(value, videoModel);
        });
  }

}
