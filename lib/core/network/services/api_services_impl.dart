import 'dart:io';
import 'package:butterfly/utils/app_exception.dart';
import 'package:butterfly/core/network/services/api_services.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends IApiServices {

  @override
  Future getDeleteApiResponse(String url) {
    throw UnimplementedError("getDeleteApiResponse is not implemented yet.");
  }

  @override
  Future getGetApiResponse(String url) async {

    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url),  headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }).timeout(Duration(seconds: 10));
      responseJson = returnHttpResponse(response);
    } on SocketException {
        throw FetchDataException("No Internet Connection");
    }

    return responseJson;

  }

  @override
  Future getPostApiResponse(String url, data) async {

    AppLogger.showError("Login API Called");

    dynamic responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: data,
      headers: {
        'Accept': 'application/json',
      }
      ).timeout(Duration(seconds: 10));

      AppLogger.showError("Login API in Network Service: $url, Data: $data");

      responseJson = returnHttpResponse(response);
    } on SocketException {
        AppLogger.showError("Login API Error in Network Service:");
        throw FetchDataException("No Internet Connection");
    }
     AppLogger.showError("Login API Response in Network Service: $url, Response: ${responseJson.toString()}");
    return responseJson;
  }

  @override
  Future getPutApiResponse(String url, data) {
    throw UnimplementedError();
  }


  dynamic returnHttpResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }

}
