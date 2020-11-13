
class CurrentCheckInfo{

  String taskXtm;
  int paperPosition;
  int equipmentPosition;

  CurrentCheckInfo(
      {this.taskXtm,
        this.paperPosition,
        this.equipmentPosition,
      });

  CurrentCheckInfo.fromJson(Map<String, dynamic> json) {
    taskXtm = json['taskXtm'];
    paperPosition = json['paperPosition'];
    equipmentPosition = json['equipmentPosition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskXtm'] = this.taskXtm;
    data['paperPosition'] = this.paperPosition;
    data['equipmentPosition'] = this.equipmentPosition;
    return data;
  }
}