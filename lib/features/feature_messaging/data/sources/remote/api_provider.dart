import 'package:dio/dio.dart';
import '../../../../../core/utils/http_client.dart';



class ApiProvider {

  Future<Response> isOnline() async {
    return await DioClient.instance.head('https://www.varzesh3.com/');
  }

}