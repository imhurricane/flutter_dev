
class Autogenerated {
  int id;
  String hitokoto;
  String type;
  String from;
  Null fromWho;
  String creator;
  int creatorUid;
  int reviewer;
  String uuid;
  String createdAt;

  Autogenerated(
      {this.id,
        this.hitokoto,
        this.type,
        this.from,
        this.fromWho,
        this.creator,
        this.creatorUid,
        this.reviewer,
        this.uuid,
        this.createdAt});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hitokoto = json['hitokoto'];
    type = json['type'];
    from = json['from'];
    fromWho = json['from_who'];
    creator = json['creator'];
    creatorUid = json['creator_uid'];
    reviewer = json['reviewer'];
    uuid = json['uuid'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hitokoto'] = this.hitokoto;
    data['type'] = this.type;
    data['from'] = this.from;
    data['from_who'] = this.fromWho;
    data['creator'] = this.creator;
    data['creator_uid'] = this.creatorUid;
    data['reviewer'] = this.reviewer;
    data['uuid'] = this.uuid;
    data['created_at'] = this.createdAt;
    return data;
  }
}
