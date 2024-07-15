import 'dart:convert';

import 'package:app_api/app/model/api_response.dart';
import 'package:app_api/app/model/bill.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/category.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/model/register.dart';
import 'package:app_api/app/model/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "https://huflit.id.vn:4321";

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  API api = API();

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  Future<String> register(Signup user) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.numberID,
        "accountID": user.accountID,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "imageURL": user.imageUrl,
        "birthDay": user.birthDay,
        "gender": user.gender,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
      });
      Response res = await api.sendRequest.post('/Student/signUp',
          options: Options(headers: header('no token')), data: body);
      ApiResponse apiResponse = ApiResponse.fromJson(res.data);
      Logger().d(apiResponse);

      if (apiResponse.data == "AccountID đã tồn tại" && res.statusCode == 200) {
        print("AccountID đã tồn tại");
        return "exists";
      }
      if (apiResponse.data == "Đăng ký thành công" && res.statusCode == 200) {
        Logger().e("ok");
        return "ok";
      } else {
        print("fail");
        return "signup fail";
      }
    } catch (ex) {
      Logger().e(ex);
      rethrow;
    }
  }

  Future<String> login(String accountID, String password) async {
    try {
      final body =
          FormData.fromMap({'AccountID': accountID, 'Password': password});
      Response res = await api.sendRequest.post('/Auth/login',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final tokenData = res.data['data']['token'];
        print("ok login");
        prefs.setString('token', tokenData);
        prefs.setString('accountID', accountID);
        return tokenData;
      } else {
        return "login fail";
      }
    } catch (ex) {
      print("Exception during login: $ex");
      throw Exception("An error occurred during login");
    }
  }

  Future<User> current(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Auth/current', options: Options(headers: header(token)));
      return User.fromJson(res.data);
    } catch (ex) {
      rethrow;
    }
  }

  Future<ApiResponse> forgotPassword(
      String accountID, String numberID, String password) async {
    try {
      final body = FormData.fromMap({
        'accountID': accountID,
        'numberID': numberID,
        'newPass': password,
      });

      Response res = await api.sendRequest.put('/Auth/forgetPass',
          options: Options(headers: header('no token')), data: body);
      return ApiResponse.fromJson(res.data);
    } on DioException catch (ex) {
      if (ex.response?.statusCode == 400) {
        Logger().e("Bad request: ${ex.response?.data}");
        if (ex.response?.data['data'] == null) {
          ex.response?.data['data'] = '';
        }
        return ApiResponse.fromJson(ex.response?.data);
      }
      rethrow;
    }
  }

  Future<ApiResponse> updateProfile(User user, String token) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.idNumber,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "gender": user.gender,
        "birthDay": user.birthDay,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "imageURL": user.imageURL,
      });
      Logger().f(body.fields);
      Response res = await api.sendRequest.put('/Auth/updateProfile',
          options: Options(headers: header(token)), data: body);
      return ApiResponse.fromJson(res.data);
    } on DioException catch (e) {
      Logger().e(e.response?.data);
      if (e.response?.data['data'] == null) {
        e.response?.data['data'] = '';
      }
      return ApiResponse.fromJson(e.response?.data);
    }
  }

  Future<ApiResponse> changePassword(
      String oldPassword, String newPassword, String token) async {
    try {
      final body = FormData.fromMap({
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      });
      Logger().f(body.fields);
      Response res = await api.sendRequest.put('/Auth/ChangePassword',
          options: Options(headers: header(token)), data: body);
      return ApiResponse.fromJson(res.data);
    } on DioException catch (e) {
      Logger().e(e.response?.data);
      return ApiResponse(
          success: false, data: '', error: e.response?.data ?? '');
    }
  }

  Future<List<CategoryModel>> getCategory(
      String accountID, String token) async {
    try {
      Response res = await api.sendRequest.get(
          '/Category/getList?accountID=$accountID',
          options: Options(headers: header(token)));
      return res.data
          .map((e) => CategoryModel.fromJson(e))
          .cast<CategoryModel>()
          .toList();
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getListProductByCatId(
      String accountID, int categoryID) async {
    try {
      Response res = await api.sendRequest.get(
          '/Product/getListByCatId?accountID=$accountID&categoryID=$categoryID');
      return res.data
          .map((e) => ProductModel.fromJson(e))
          .cast<ProductModel>()
          .toList();
    } catch (ex) {
      Logger().e(ex);
      rethrow;
    }
  }

  Future<bool> addCategory(
      CategoryModel data, String accountID, String token) async {
    try {
      final body = FormData.fromMap({
        'name': data.name,
        'description': data.desc,
        'imageURL': data.imageUrl,
        'accountID': accountID
      });
      Response res = await api.sendRequest.post('/addCategory',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok add category");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> updateCategory(int categoryID, CategoryModel data,
      String accountID, String token) async {
    try {
      final body = FormData.fromMap({
        'id': categoryID,
        'name': data.name,
        'description': data.desc,
        'imageURL': data.imageUrl,
        'accountID': accountID
      });
      Response res = await api.sendRequest.put('/updateCategory',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok update category");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> removeCategory(
      int categoryID, String accountID, String token) async {
    try {
      final body =
          FormData.fromMap({'categoryID': categoryID, 'accountID': accountID});
      Response res = await api.sendRequest.delete('/removeCategory',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok remove category");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<ProductModel>> getProduct(String accountID, String token) async {
    try {
      Response res = await api.sendRequest.get(
          '/Product/getList?accountID=$accountID',
          options: Options(headers: header(token)));
      return res.data
          .map((e) => ProductModel.fromJson(e))
          .cast<ProductModel>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductAdmin(
      String accountID, String token) async {
    try {
      Response res = await api.sendRequest.get(
          '/Product/getListAdmin?accountID=$accountID',
          options: Options(headers: header(token)));
      return res.data
          .map((e) => ProductModel.fromJson(e))
          .cast<ProductModel>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> addProduct(ProductModel data, String token) async {
    try {
      final body = FormData.fromMap({
        'name': data.name,
        'description': data.description,
        'imageURL': data.imageUrl,
        'Price': data.price,
        'CategoryID': data.categoryId
      });
      Response res = await api.sendRequest.post('/addProduct',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok add product");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> updateProduct(
      ProductModel data, String accountID, String token) async {
    try {
      final body = FormData.fromMap({
        'id': data.id,
        'name': data.name,
        'description': data.description,
        'imageURL': data.imageUrl,
        'Price': data.price,
        'categoryID': data.categoryId,
        'accountID': accountID
      });
      Response res = await api.sendRequest.put('/updateProduct',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok update product");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> removeProduct(
      int productID, String accountID, String token) async {
    try {
      final body =
          FormData.fromMap({'productID': productID, 'accountID': accountID});
      Response res = await api.sendRequest.delete('/removeProduct',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok remove product");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> addBill(List<Cart> products, String token) async {
    var list = [];
    try {
      for (int i = 0; i < products.length; i++) {
        list.add({
          'productID': products[i].productID,
          'count': products[i].count,
        });
      }
      Response res = await api.sendRequest.post('/Order/addBill',
          options: Options(headers: header(token)), data: list);
      if (res.statusCode == 200) {
        print("add bill ok");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<BillModel>> getHistory(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Bill/getHistory', options: Options(headers: header(token)));
      List<BillModel> billList =
          res.data.map((e) => BillModel.fromJson(e)).cast<BillModel>().toList();
      for (var i in billList) {
        Logger().i(i.dateCreated);
      }
      billList.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

      return billList;
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<BillDetailModel>> getHistoryDetail(
      String billID, String token) async {
    try {
      Response res = await api.sendRequest.post('/Bill/getByID?billID=$billID',
          options: Options(headers: header(token)));
      return res.data
          .map((e) => BillDetailModel.fromJson(e))
          .cast<BillDetailModel>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<dynamic> getListUser() async {
    try {
      final dynamic res = await api.sendRequest.get('/WWAdmin/listUser');
      return res.data;
    } catch (ex) {
      Logger().e(ex);
      rethrow;
    }
  }
}
