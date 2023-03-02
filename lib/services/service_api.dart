import 'package:dio/dio.dart';

class ServiceAPI {
  final baseURL = 'http://34.105.224.254';
  final dio = Dio();

  void getWasteById(String id) async {
    final response = await dio.get('$baseURL/wastes/$id');
    print(response);
  }



}
