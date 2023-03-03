import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:green_ring/models/garbage.dart';

import '../models/product.dart';


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
      print(data);
      garbages = data.map((json) => Garbage.fromJson(json)).toList();
    } else {

    }
    return garbages;
  }

  Future<Garbage?> addGarbage(Garbage garbage) async {
    final response = await dio.post('$baseURL/trashs/create', data: garbage.toJsonForCreation());
    if(response.statusCode == 200) {
      return Garbage.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<void> deleteGarbage(String id) async {
    final response = await dio.delete('$baseURL/trashs/$id');
  }

  Future<Product?> addProduct(Product product) async {
    final response = await dio.post('$baseURL/products/create', data: product.toJson());
    if(response.statusCode == 200) {
      return Product.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<List<Product>> getRewards() async {
    List<Product> products = [];
    final response = await dio.get('$baseURL/products/');
    if(response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      products = data.map((json) => Product.fromJson(json)).toList();
    } else {

    }
    return products;
  }

  Future<bool> getIsRecyclable(XFile file) async {
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.name,
      ),
    });
    print(file.name);

    final response = await dio.post('http://146.59.237.29:7590/check-recyclable', data: data);
    if(response.statusCode == 200) {
      final data = response.data as String;
      print(data);
      return data == "Recyclable";
    } else {
      return false;
    }
  }
}
