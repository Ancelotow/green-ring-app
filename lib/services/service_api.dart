import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:green_ring/models/garbage.dart';
import 'package:green_ring/models/user.dart';
import 'package:green_ring/models/product.dart';
import 'package:green_ring/models/waste.dart';

class ServiceAPI {
  final String baseURL = "http://146.59.237.29:7790";
  final dio = Dio();

  Future<List<Waste>> getWastesByBarcode(String barcode) async {
    List<Waste> wastes = [];
    final response = await dio.get('$baseURL/wastes/$barcode');
    if(response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      wastes = data.map((json) => Waste.fromJson(json)).toList();
    }
    return wastes;
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


  /// USERS
  Future<List<User>> getUsers() async {
    List<User> users = [];
    final response = await dio.get('$baseURL/users/');
    if(response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      users = data.map((json) => User.fromJson(json)).toList();
    }
    return users;
  }
  Future<User?> getUser(String userId) async {
    final response = await dio.get('$baseURL/users/$userId');
    if(response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<User?> addUser(User user) async {
    final response = await dio.post('$baseURL/users/create', data: user.toJson());
    if(response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<User?> addCoin(String userId) async {
    final response = await dio.get('$baseURL/users/$userId/addCoin');
    if(response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<String> getRecyclableTrash(XFile file) async {
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.name,
      ),
    });
    final response = await dio.post('http://146.59.237.29:7590/check-recyclable', data: data);
    if(response.statusCode == 200) {
      final data = response.data as String;
      return data;
    } else {
      return "black";
    }
  }

  Future<User?> connection(String login, String password) async {
    final users = await getUsers();
    final usersWithLogin =  users.where((e) => e.login == login);
    if(usersWithLogin == null || usersWithLogin.isEmpty) {
      return null;
    } else {
      return usersWithLogin.first;
    }
  }


}
