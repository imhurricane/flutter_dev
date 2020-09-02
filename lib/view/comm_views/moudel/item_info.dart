
class ListViewItem {
  String detailPageId;
  String listTitle;
  ItemListViewContent itemListViewContent;
  String dataType;
  String icon;
  Map<String,dynamic> params;

  ListViewItem(
      {this.detailPageId,
        this.listTitle,
        this.itemListViewContent,
        this.dataType,
        this.icon,
        this.params});

  ListViewItem.fromJson(Map<String, dynamic> json) {
    detailPageId = json['detailPageId'];
    listTitle = json['listTitle'];
    itemListViewContent = json['itemListViewContent'] != null
        ? new ItemListViewContent.fromJson(json['itemListViewContent'])
        : null;
    dataType = json['dataType'];
    icon = json['icon'];
    params = json['params'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['detailPageId'] = this.detailPageId;
    data['listTitle'] = this.listTitle;
    if (this.itemListViewContent != null) {
      data['itemListViewContent'] = this.itemListViewContent.toJson();
    }
    data['dataType'] = this.dataType;
    data['icon'] = this.icon;
    data['params'] = this.params;
    return data;
  }
}

class ItemListViewContent {
  String subTitle;
  String describe;
  String id;
  String note;
  String title;

  ItemListViewContent({this.subTitle, this.describe, this.id, this.title});

  ItemListViewContent.fromJson(Map<String, dynamic> json) {
    subTitle = json['subTitle'];
    describe = json['describe'];
    id = json['id'];
    note = json['note'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subTitle'] = this.subTitle;
    data['describe'] = this.describe;
    data['id'] = this.id;
    data['title'] = this.title;
    data['note'] = this.note;
    return data;
  }
}