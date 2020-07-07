import 'dart:core';

class ItemHome {

  ViewType viewType;

  List<Map<String, String>> gridData;

  List<dynamic> reportData;

  ItemHome.grid(this.viewType, this.gridData);

  ItemHome.report(this.viewType, this.reportData);
}
enum ViewType{
  gridView,
  reportView,
}
