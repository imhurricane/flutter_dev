
class RissImages {

  String path;
  String date;
  String yhxtm;
  bool isUpload;

  RissImages({this.path, this.date, this.yhxtm,this.isUpload});

  RissImages.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    date = json['date'];
    yhxtm = json['yhxtm'];
    isUpload = json['isUpload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['date'] = this.date;
    data['yhxtm'] = this.yhxtm;
    data['isUpload'] = this.isUpload;
    return data;
  }
}