import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

class ApiClient extends DioForBrowser {
  ApiClient() : super(BaseOptions(baseUrl: 'http://localhost:5000'));
}
