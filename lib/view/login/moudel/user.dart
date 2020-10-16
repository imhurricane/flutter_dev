
class LoginUser{
  String msg;
  String sitextm;
  String code;
  String issysadmin;
  String jobs;
  String yhxtm;
  String devicextm;
  String usernamecn;
  String orgxtm;
  String deptname;
  Map<String,dynamic> permission;

  LoginUser(
      {this.msg,
        this.sitextm,
        this.code,
        this.issysadmin,
        this.jobs,
        this.yhxtm,
        this.devicextm,
        this.usernamecn,
        this.orgxtm,
        this.deptname,
        this.permission
      });

  LoginUser.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    sitextm = json['sitextm'];
    code = json['code'];
    issysadmin = json['issysadmin'];
    jobs = json['jobs'];
    yhxtm = json['yhxtm'];
    devicextm = json['devicextm'];
    usernamecn = json['usernamecn'];
    orgxtm = json['orgxtm'];
    deptname = json['deptname'];
    permission = json['permission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['sitextm'] = this.sitextm;
    data['code'] = this.code;
    data['issysadmin'] = this.issysadmin;
    data['jobs'] = this.jobs;
    data['yhxtm'] = this.yhxtm;
    data['devicextm'] = this.devicextm;
    data['usernamecn'] = this.usernamecn;
    data['orgxtm'] = this.orgxtm;
    data['deptname'] = this.deptname;
    data['permission'] = this.permission;
    return data;
  }
}