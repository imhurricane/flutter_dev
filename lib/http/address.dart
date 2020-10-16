class Address {

  //http://111.61.125.153:10001
  //http://192.168.1.170:7001
  static const String MENU_ID="zhsk_nav_app";
  static const String BASE_URL = "http://192.168.1.170:7001";
  static const String BASE_PACKAGE = "/appservlet/?requestdir=app.base.http&requesttype=";
  static const String OFFLINE_PACKAGE = "/appservlet/?requestdir=app.offline&requesttype=";
  static const String LOGIN_URL = "/appservlet/?requesttype=login";
  static const String HOME_URL = BASE_PACKAGE + "MainMenuServlet";
  static const String DownloadTaskList_URL = OFFLINE_PACKAGE + "DownloadTaskListServlet";
  static const String DownloadTask_URL = OFFLINE_PACKAGE + "DownloadTaskServlet";
  static const String BaseImageURL = BASE_URL + "/app/images/";
  static const String MenuItemUrl = BASE_PACKAGE + "MenuItemServlet";
  static const String SecondMenuItemUrl = BASE_PACKAGE + "SecondLevelMenu";
  static const String MenuItemDetailUrl = BASE_PACKAGE + "MenuItemDetailServlet";
  static const String MenuItemListUrl = BASE_PACKAGE + "MenuItemList";
  // 图片上传URL
  static const String DetailPageIconUrl = BASE_URL + "/attachfileuploadservlet/?requesttype=sig";
}
