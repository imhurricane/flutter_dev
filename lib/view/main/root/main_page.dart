

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../main_find_page.dart';
import '../home/home_page.dart';
import '../mine/main_mine_page.dart';
import '../main_sort_page.dart';

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }

}

class MainPageState extends State<MainPage> {

  List<String> tabTitleList = ["首页","分类","发现","我的"];
  List<Widget> pageList = [MainHomePage(),MainSortPage(),MainFindPage(),MainMinePage()];
  List<String> normalIcon = ["sy_01.png","fl_01.png","bk_01.png","mine_01.png"];
  List<String> selectIcon = ["sy_02.png","fl_02.png","bk_02.png","mine_02.png"];
  num selectIndex = 0;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels:true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Image.asset("resources/images/${selectIndex==0?selectIcon[0]:normalIcon[0]}",width: 24,height: 24,),title: Text(tabTitleList[0],style: TextStyle(color: selectIndex==0?Colors.lightBlue:Colors.black),),),
          BottomNavigationBarItem(icon: Image.asset("resources/images/${selectIndex==1?selectIcon[1]:normalIcon[1]}",width: 24,height: 24,),title: Text(tabTitleList[1],style: TextStyle(color: selectIndex==1?Colors.lightBlue:Colors.black),),),
          BottomNavigationBarItem(icon: Image.asset("resources/images/${selectIndex==2?selectIcon[2]:normalIcon[2]}",width: 24,height: 24,),title: Text(tabTitleList[2],style: TextStyle(color: selectIndex==2?Colors.lightBlue:Colors.black),),),
          BottomNavigationBarItem(icon: Image.asset("resources/images/${selectIndex==3?selectIcon[3]:normalIcon[3]}",width: 24,height: 24,),title: Text(tabTitleList[3],style: TextStyle(color: selectIndex==3?Colors.lightBlue:Colors.black),),),
        ],
        onTap: (value){
          setState(() {
            selectIndex = value;
          });
        },
        currentIndex: selectIndex,
      ),
    );
  }
}