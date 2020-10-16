
import 'dart:collection';

import 'entry_model.dart';

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

