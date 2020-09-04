
import 'package:flutter/cupertino.dart';

class DetailPageItem{
  int xh;
  PageItemType itemType;
  bool isShow;

  DetailPageItem({
    @required
    this.xh,
    @required
    this.itemType,
    this.isShow = true,
  });
}
 enum PageItemType{
  column,
  picture,
}