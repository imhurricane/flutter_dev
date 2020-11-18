
import 'package:flutter/cupertino.dart';

class MineItem{
  ButtonType type;
  String description;
  IconData icon;
  Color iconColor;

  MineItem({
    @required
    this.type,
    this.icon,
    this.iconColor,
    this.description});

}

enum ButtonType {
  loginOut,
  aboutAs
}
