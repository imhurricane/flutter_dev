
import 'package:image_picker/image_picker.dart';

class CommBottomAction {

  static dynamic result;

  static action(int buttonType) {
    switch (buttonType) {
      case 1001:
        break;
      case 1002:
        break;
      case 1003:
        break;
      case 1004:
        getLocalImage();
        break;
      case 1005:
        getImage();
        break;
    }
    return result;
  }

  static getImage() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.camera);
    result = image.path;
  }

  static getLocalImage() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery);
    result = image.path;
  }

}

