
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/sign_page.dart';
import 'package:image_picker/image_picker.dart';

class CommBottomAction {

  static dynamic result;

  static action(BuildContext context,int buttonType) async{
    print("buttonType:"+buttonType.toString());
    switch (buttonType) {
      case 1001:
        break;
      case 1002:
        RouteUtils.pushPage(context, SignApp());
        break;
      case 1003:
        break;
      case 1004:
        await getLocalImage();
        break;
      case 1005:
        await getImage();
        break;
    }
    return result;
  }

  static getImage() async {
    print("getImage");
    PickedFile image = await ImagePicker().getImage(source: ImageSource.camera);
    if(image != null){
      result = image.path;
    }
  }

  static getLocalImage() async {
    print("getLocalImage");
    PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery);
    if(image != null){
      result = image.path;
    }

  }

}

