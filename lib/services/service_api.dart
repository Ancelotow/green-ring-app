import 'package:dio/dio.dart';
import 'package:green_ring/models/garbage.dart';


class ServiceAPI {
  final String baseURL = "http://146.59.237.29:7790";
  final dio = Dio();

  void getHttp() async {
    final response = await dio.get('$baseURL/wastes/3596710356287');
    print('HERE');
    print(response);
  }

  Future<List<Garbage>> getGarbages() async {
    List<Garbage> garbages = [];
    final response = await dio.get('$baseURL/trashs/');
    if(response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      garbages = data.map((json) => Garbage.fromJson(json)).toList();
    } else {

    }
    return garbages;
  }
}