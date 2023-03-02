import 'package:dio/dio.dart';


class ServiceAPI {
  final dio = Dio();

  void getHttp() async {
    final response = await dio.get('http://34.105.224.254/wastes/3596710356287');
    print('HERE');
    print(response);
  }
}
