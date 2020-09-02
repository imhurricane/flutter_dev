class Selects {
  String value;
  bool isChecked;
  String desc;

  Selects({this.value, this.isChecked, this.desc});

  Selects.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    isChecked = json['isChecked'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['isChecked'] = this.isChecked;
    data['desc'] = this.desc;
    return data;
  }
}