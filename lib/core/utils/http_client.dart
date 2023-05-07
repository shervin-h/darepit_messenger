
import 'package:dio/dio.dart';

class DioClient {
  static final _dio = Dio();

  static Dio get instance => _dio;
}