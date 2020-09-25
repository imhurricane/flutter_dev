class Address {

  //http://111.61.125.153:10001
  //http://192.168.1.170:7001
  static const String BASE_URL = "http://192.168.1.170:7001";
  static const String BASE_PACKAGE = "/appservlet/?requestdir=app.base.http&requesttype=";
  static const String LOGIN_URL = "/appservlet/?requesttype=login";
  static const String HOME_URL = BASE_PACKAGE + "MainMenuServlet";
  static const String BaseImageURL = BASE_URL + "/app/images/";
  static const String MenuItemUrl = BASE_PACKAGE + "MenuItemServlet";
  static const String MenuItemDetailUrl = BASE_PACKAGE + "MenuItemDetailServlet";
  // 图片上传URL
  static const String DetailPageIconUrl = BASE_URL + "/attachfileuploadservlet/?requesttype=sig";
}
