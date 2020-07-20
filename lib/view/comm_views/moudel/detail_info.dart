
class DetailPageInfo {
  String detailPageId;
  String dataType;
  String id;
  String preId;
  String nextId;
  Map<String, dynamic> params;

  DetailPageInfo({
    this.detailPageId,
    this.dataType,
    this.preId,
    this.nextId,
    this.params,
  });

  DetailPageInfo.fromJson(Map<String, dynamic> json) {
    detailPageId = json['detailPageId'];
    dataType = json['dataType'];
    preId = json['preId'];
    nextId = json['nextId'];
    params = json['params'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['detailPageId'] = this.detailPageId;
    data['dataType'] = this.dataType;
    data['preId'] = this.preId;
    data['nextId'] = this.nextId;
    data['params'] = this.params;
    return data;
  }
}

class DetailData {
  ItemDetailButtons itemDetailButtons;
  List<ItemDetailColumns> itemDetailColumns;
  IconInfoList iconInfoList;
  String tableName;

  DetailData(
      {this.itemDetailButtons,
      this.itemDetailColumns,
      this.iconInfoList,
      this.tableName});

  DetailData.fromJson(Map<String, dynamic> json) {
    itemDetailButtons = json['itemDetailButtons'] != null
        ? new ItemDetailButtons.fromJson(json['itemDetailButtons'])
        : null;
    if (json['itemDetailColumns'] != null) {
      itemDetailColumns = new List<ItemDetailColumns>();
      json['itemDetailColumns'].forEach((v) {
        itemDetailColumns.add(new ItemDetailColumns.fromJson(v));
      });
    }
    iconInfoList = json['iconInfoList'] != null
        ? new IconInfoList.fromJson(json['iconInfoList'])
        : null;
    tableName = json['tableName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.itemDetailButtons != null) {
      data['itemDetailButtons'] = this.itemDetailButtons.toJson();
    }
    if (this.itemDetailColumns != null) {
      data['itemDetailColumns'] =
          this.itemDetailColumns.map((v) => v.toJson()).toList();
    }
    if (this.iconInfoList != null) {
      data['iconInfoList'] = this.iconInfoList.toJson();
    }
    data['tableName'] = this.tableName;
    return data;
  }
}

class ItemDetailButtons {
  List<ItemDetailButton> itemDetailButtonTopRight;
  List<ItemDetailButton> itemDetailButtonBottom;

  ItemDetailButtons(
      {this.itemDetailButtonTopRight, this.itemDetailButtonBottom});

  ItemDetailButtons.fromJson(Map<String, dynamic> json) {
    if (json['itemDetailButtonTopRight'] != null) {
      itemDetailButtonTopRight = new List<Null>();
      json['itemDetailButtonTopRight'].forEach((v) {
        itemDetailButtonTopRight.add(new ItemDetailButton.fromJson(v));
      });
    }
    if (json['itemDetailButtonBottom'] != null) {
      itemDetailButtonBottom = new List<Null>();
      json['itemDetailButtonBottom'].forEach((v) {
        itemDetailButtonBottom.add(new ItemDetailButton.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.itemDetailButtonTopRight != null) {
      data['itemDetailButtonTopRight'] =
          this.itemDetailButtonTopRight.map((v) => v.toJson()).toList();
    }
    if (this.itemDetailButtonBottom != null) {
      data['itemDetailButtonBottom'] =
          this.itemDetailButtonBottom.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetailColumns {
  String isReadOnlyCol;
  int itemType;
  String pageTitle;
  String columnDes;
  String columnValue;
  String columnName;

  ItemDetailColumns(
      {this.isReadOnlyCol,
      this.itemType,
      this.pageTitle,
      this.columnDes,
      this.columnValue,
      this.columnName});

  ItemDetailColumns.fromJson(Map<String, dynamic> json) {
    isReadOnlyCol = json['isReadOnlyCol'];
    itemType = json['itemType'];
    pageTitle = json['pageTitle'];
    columnDes = json['columnDes'];
    columnValue = json['columnValue'];
    columnName = json['columnName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isReadOnlyCol'] = this.isReadOnlyCol;
    data['itemType'] = this.itemType;
    data['pageTitle'] = this.pageTitle;
    data['columnDes'] = this.columnDes;
    data['columnValue'] = this.columnValue;
    data['columnName'] = this.columnName;
    return data;
  }
}

class IconInfoList {
  List<LocalMedia> localMedia;
  String timeStr;

  IconInfoList({this.localMedia, this.timeStr});

  IconInfoList.fromJson(Map<String, dynamic> json) {
    if (json['localMedia'] != null) {
      localMedia = new List<Null>();
      json['localMedia'].forEach((v) {
        localMedia.add(new LocalMedia.fromJson(v));
      });
    }
    timeStr = json['timeStr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.localMedia != null) {
      data['localMedia'] = this.localMedia.map((v) => v.toJson()).toList();
    }
    data['timeStr'] = this.timeStr;
    return data;
  }
}

class ItemDetailButton {
  int buttonType;
  int buttonPos;
  String description;
  bool isOpenNewPage;
  String openNewPageUrl;

  ItemDetailButton({
    this.buttonType,
    this.buttonPos,
    this.description,
    this.isOpenNewPage,
    this.openNewPageUrl,
  });

  ItemDetailButton.fromJson(Map<String, dynamic> json) {
    buttonType = json['buttonType'];
    buttonPos = json['buttonPos'];
    description = json['description'];
    isOpenNewPage = json['isOpenNewPage'];
    openNewPageUrl = json['openNewPageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buttonType'] = this.buttonType;
    data['buttonPos'] = this.buttonPos;
    data['description'] = this.description;
    data['isOpenNewPage'] = this.isOpenNewPage;
    data['openNewPageUrl'] = this.openNewPageUrl;
    return data;
  }
}

class LocalMedia {
  String mimeType;
  String realPath;
  String path;

  LocalMedia({
    this.mimeType,
    this.realPath,
    this.path,
  });

  LocalMedia.fromJson(Map<String, dynamic> json) {
    mimeType = json['mimeType'];
    realPath = json['realPath'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mimeType'] = this.mimeType;
    data['realPath'] = this.realPath;
    data['path'] = this.path;
    return data;
  }
}
