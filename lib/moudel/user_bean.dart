class User {

  String userName;
  int age;
  int id;

  User fromJson(Map<String, dynamic> data) {
    User user = User();
    user.userName = data["name"];
    user.age = data["age"];
    user.id = data["id"];
    return user;
  }

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> json = Map();
    json["id"] = this.id;
    return json;
  }
}
