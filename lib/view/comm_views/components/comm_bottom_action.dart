
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/sign_page.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CommBottomAction {

  static dynamic result;

  static action(BuildContext context,int buttonType) async{
    switch (buttonType) {
      case 1001:
        break;
      case 1002:
        RouteUtils.pushPage(context, SignApp());
        break;
      case 1003:
        break;
      case 1004:
        await getImageFromGallery();
        break;
      case 1005:
        await getImageFromCamera();
        break;
    }
    return result;
  }

  static getImageFromCamera() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.camera,imageQuality: 50);
    result=image?.path;
  }

  static getImage() async{
    await MultiImagePicker.pickImages(maxImages: 9,enableCamera: true);

  }

  static getImageFromGallery() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery,imageQuality: 50);
    if(image != null){
      result = image.path;
    }
  }

}

