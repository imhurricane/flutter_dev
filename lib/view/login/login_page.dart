import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/data_helper.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/login_textfield.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:flutter_dev/view/main/root/main_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  ///正在输入时边框颜色
  Color selectColor = Colors.green;

  ///正常时边框颜色
  Color unSelectColor = Colors.white;
  TextEditingController userTextEditingController;
  TextEditingController pwTextEditingController;
  FocusNode userFocusNode = new FocusNode();
  FocusNode passWordFocusNode = new FocusNode();

  ///RichText手势
  TapGestureRecognizer recognizer1;
  TapGestureRecognizer recognizer2;

  //登录按钮控制器
  AnimationController animationController;
  int code;
  ResultStatus currentStatus = ResultStatus.none;
  bool checkSelect = false;

  ///logo动画控制器
  AnimationController logoAnimationController;
  Animation logoAnimation;

  @override
  void initState() {
    super.initState();
    userTextEditingController = TextEditingController();
    pwTextEditingController = TextEditingController();
    recognizer1 = TapGestureRecognizer();
    recognizer2 = TapGestureRecognizer();

    userFocusNode.addListener(() {
        setState(() {});
    });

    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animationController.addListener(() {
      double value = animationController.value;
//      print("变化率： $value");
//        setState(() {});
    });

    logoAnimationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    logoAnimationController.addListener(() {
      setState(() {});
    });
    logoAnimation =
        Tween(begin: 1.0, end: 0.0).animate(logoAnimationController);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      if(!mounted){
        return;
      }
      setState(() {
        ///获取底部遮挡区域的高度
        double keyBoderHeight = MediaQuery.of(context).viewInsets.bottom;
        if (keyBoderHeight == 0) {
          logoAnimationController.reverse();
        } else {
          logoAnimationController.forward();
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ///构建背景
          buildBgWidget(),

          ///构建阴影层
          buildBlurWidget(),

          ///构建用户信息输入层
          buildLoginInputWidget(),
        ],
      ),
    );
  }

  buildBgWidget() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Image.asset(
        "resources/images/background.jpg",
        fit: BoxFit.fill,
      ),
    );
  }

  buildBlurWidget() {
    return InkWell(
      child: Container(
        color: Color.fromARGB(150, 100, 100, 100),
      ),
      onTap: () {
        userFocusNode.unfocus();
        passWordFocusNode.unfocus();
      },
    );
  }

  buildLoginInputWidget() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(
                  left: 22, right: 22, top: 100 * logoAnimation.value),
            ),
            buildLogoWidget(),
            SizedBox(
              height: 30,
            ),
            buildInputWidget("resources/images/user.png", "请输入用户名",
                userFocusNode, userTextEditingController),
            SizedBox(
              height: 20,
            ),
            buildInputWidget("resources/images/password.png", "请输入密码",
                passWordFocusNode, pwTextEditingController),

            buildAgreementWidget(),
            SizedBox(
              height: 40,
            ),
            buildLoginButton(),
          ],
        ),
      ),
    );
  }

  buildLogoWidget() {
    return ScaleTransition(
      alignment: Alignment.center,
      scale: logoAnimation,
      child: InkWell(
        onTap: () {
          userFocusNode.unfocus();
          passWordFocusNode.unfocus();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 14),

              ///圆角矩形裁切
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                child: Image.asset(
                  "resources/images/logo.png",
                  width: 44,
                  height: 44,
                ),
              ),
            ),

            ///颐达科技
            Text(
              "Flutter Study",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,

                  ///引用原话的自定义字体
                  fontFamily: 'UniTortred'),
            ),
          ],
        ),
      ),
    );
  }

  buildInputWidget(String img, String hintText, FocusNode focusNode,
      TextEditingController controller) {
    return Container(
      height: 44,
      margin: EdgeInsets.only(
        left: 22,
        right: 22,
      ),
      decoration: BoxDecoration(
          color: Color(0x50fafafa),
          borderRadius: BorderRadius.all(Radius.circular(24)),
          border: Border.all(
              color: focusNode.hasFocus ? selectColor : unSelectColor)),
      child: buildRowWidget(img, hintText, focusNode, controller),
    );
  }

  buildRowWidget(String img, String hintText, FocusNode focusNode,
      TextEditingController controller) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset(
            "$img",
            width: 26,
            height: 26,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Container(
            width: 1,
            height: 26,
            color: Color(0xaafafafa),
          ),
        ),
        Expanded(
          child: LoginTextField(
//            text: "asdas",
//            labelText: "123123",
            border: InputBorder.none,
            isShowDeleteBtn:true,
            controller: controller,
            focusNode: focusNode,
            isDense: true,
            keyboardType: focusNode==userFocusNode?TextInputType.visiblePassword:TextInputType.visiblePassword,
//            inputFormatters: [
//              LengthLimitingTextInputFormatter(11),
//            ],
          inputFormatters: [],
            isPwd: focusNode==userFocusNode?false:true,
          ),
        ),
      ],
    );
  }

  buildAgreementWidget() {
    return Container(
      margin: EdgeInsets.only(left: 22, right: 22, top: 10),
      child: Row(
        children: [
          buildCircleCheckBox(),
          SizedBox(
            width: 1,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "同意注册",
                style: TextStyle(color: Color(0xaafafafa)),
                children: [
                  TextSpan(
                    text: "《用户注册协议》",
                    style: TextStyle(color: Colors.orange),
                    recognizer: recognizer1
                      ..onTap = () {
                        print("点击了用户协议");
                      },
                  ),
                  TextSpan(
                    text: "与",
                    style: TextStyle(color: Color(0xaafafafa)),
                  ),
                  TextSpan(
                    text: "《隐私协议》",
                    style: TextStyle(color: Colors.orange),
                    recognizer: recognizer2
                      ..onTap = () {
                        print("点击了隐私协议");
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildCircleCheckBox() {
    return Container(
      padding: EdgeInsets.all(6),
      child: InkWell(
        onTap: () {
          setState(() {
            checkSelect ? checkSelect = false : checkSelect = true;
          });
        },
        child: Image.asset(
          checkSelect
              ? "resources/images/check.png"
              : "resources/images/un_check.png",
          width: 18,
          height: 18,
        ),
      ),
    );
  }

  buildLoginButton() {
    return InkWell(
      onTap: () {
        userFocusNode.unfocus();
        passWordFocusNode.unfocus();
        animationController.forward();
        login();
      },
      child: Stack(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(
                1.0 - animationController.value, 1.0, 1.0),
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 48,
              margin: EdgeInsets.only(left: 22, right: 22),
              decoration: BoxDecoration(
                  color: Color(0x50fafafa),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Text(
                "登录",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: animationController.value,
                child: Container(
                  height: 48,
                  width: 48,
                  padding: EdgeInsets.all(10),
                  child: buildLoadingWidget(),
                  decoration: BoxDecoration(
                      color: Color(0x50fafafa),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildLoadingWidget() {
    Widget loadingWidget = CircularProgressIndicator();
    if (currentStatus == ResultStatus.success) {
      loadingWidget = Icon(
        Icons.check,
        color: Colors.lightBlue,
      );
    } else if (currentStatus == ResultStatus.error) {
      loadingWidget = Icon(
        Icons.close,
        color: Colors.red,
      );
    }
    return loadingWidget;
  }

  login() async {
    currentStatus = ResultStatus.none;
    ResultData result;
    var baseMap = DataHelper.getBaseMap();
    baseMap.clear();
    baseMap['plat'] = "android";
    baseMap['devicetoken'] = "";
    baseMap['isjpush'] = "1";
    baseMap['registrationID'] = "";
    baseMap['appid'] = "";
    baseMap['username'] = userTextEditingController.text.trim();
    baseMap['password'] = pwTextEditingController.text.trim();
    if (userTextEditingController.text.trim().length == 0) {
      FlutterToast.showToast(msg: "用户名不能为空!");
      animationController.reverse();
    } else if (pwTextEditingController.text.trim().length == 0) {
      FlutterToast.showToast(msg: "密码不能为空!");
      animationController.reverse();
    } else {
      result = await HttpManager.getInstance().get(Address.LOGIN_URL, baseMap);

      if (result.code == 200) {
        Map<String, dynamic> json = jsonDecode(result.data);
        LoginUser loginUser = LoginUser.fromJson(json);
        if (loginUser.code.endsWith("1")) {
          currentStatus = ResultStatus.success;
          StorageUtils.saveModel("userInfo", loginUser);
          if(mounted){
            setState((){

            });
          }

          RouteUtils.pushReplacePage(context, MainPage());

        } else if (loginUser.code == "0") {
          Future.delayed(Duration(milliseconds: 1000),(){
            animationController.reverse();
          });
          CommUtils.showDialog(context, "提示", loginUser.msg, false,
              okOnPress: () {});
          if(mounted){
            setState(() {
              currentStatus = ResultStatus.error;
            });
          }
        }
      } else {
        Future.delayed(Duration(milliseconds: 1000),(){
          animationController.reverse();
        });
        if(mounted){
          setState(() {currentStatus = ResultStatus.error;});
        }
        CommUtils.showDialog(context, "提示", "${result.data}", false,
            okOnPress: () {});
      }

    }
  }
}

enum ResultStatus {
  none,
  loading,
  success,
  error,
  rever,
}
