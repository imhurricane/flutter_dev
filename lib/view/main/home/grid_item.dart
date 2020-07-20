
import 'dart:collection';

class ItemGrid {
  List<EntryModel> entryModels;

  ItemGrid({this.entryModels});

  ItemGrid.fromJson(Map<String, dynamic> json) {
    if (json['entryModels'] != null) {
      entryModels = new List<EntryModel>();
      json['entryModels'].forEach((v) {
        entryModels.add(new EntryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.entryModels != null) {
      data['entryModels'] = this.entryModels.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EntryModel {
  String xtm;
  String dataType;
  String icon;
  String title;
  String toPage;
  bool isHtml;
  bool secondLevel;
  HashMap params;

  EntryModel(
      {this.xtm,
        this.dataType,
        this.icon,
        this.title,
        this.toPage,
        this.isHtml,
        this.params,
        this.secondLevel});

  EntryModel.fromJson(Map<String, dynamic> json) {
    xtm = json['xtm'];
    dataType = json['dataType'];
    icon = json['icon'];
    title = json['title'];
    toPage = json['toPage'];
    isHtml = json['isHtml'];
    secondLevel = json['secondLevel'];
    params = json['params'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xtm'] = this.xtm;
    data['dataType'] = this.dataType;
    data['icon'] = this.icon;
    data['title'] = this.title;
    data['toPage'] = this.toPage;
    data['isHtml'] = this.isHtml;
    data['secondLevel'] = this.secondLevel;
    data['params'] = this.params;
    return data;
  }
}