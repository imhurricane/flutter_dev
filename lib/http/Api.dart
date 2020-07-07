import 'data_helper.dart';
import 'http_manager.dart';
import 'address.dart';
class Api {

  ///示例请求
  static request(String param) {
    var params = DataHelper.getBaseMap();
    params['param'] = param;
    params['platform1']="2";
    return HttpManager.getInstance().get(Address.BASE_URL, params);
  }
}