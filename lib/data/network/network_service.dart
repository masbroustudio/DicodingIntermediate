import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../local/app_preferences.dart';
import 'custom_exception.dart';

class NetworkService {
  static dynamic compileResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(generateError(response.body));
      case 401:
        AppPreferences.clearSession();
        throw UnauthorisedException(generateError(response.body));
      case 402:
        throw UnauthorisedException(generateError(response.body));
      case 403:
        throw UnauthorisedException(generateError(response.body));
      case 409:
        throw ConflictException(generateError(response.body));
      case 404:
        throw NotFoundException(generateError(response.body));
      case 500:
        throw InternalServerErrorException(generateError(response.body));

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  static dynamic generateError(String responseBody) {
    Map<String, dynamic> errorBody = json.decode(responseBody);

    return errorBody['message'];
  }

  static Future<dynamic> get(
    String baseUrl,
    String url, {
    required Map<String, String> headers,
    Map<String, String>? queryParameters,
    bool withToken = false,
    bool isHttps = true,
  }) async {
    final uri = isHttps
        ? Uri.https(baseUrl, url, queryParameters)
        : Uri.http(baseUrl, url, queryParameters);

    try {
      if (withToken) {
        final token = await AppPreferences.getToken();
        headers.addAll({'Authorization': 'Bearer $token'});
      }

      headers.addAll({'Accept': 'application/json'});

      log('GET: ${uri.toString()}');
      log('PARAMS: ${queryParameters.toString()}');
      log('HEADERS: ${headers.toString()}');

      final response = await http.get(uri, headers: headers);

      return compileResponse(response);
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    } on FormatException {
      throw const FormatException('unauthorized');
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> post(
    String baseUrl,
    String url, {
    required Map<String, String> headers,
    required Map<String, String> data,
    bool withToken = false,
    bool isHttps = true,
  }) async {
    var uri = isHttps ? Uri.https(baseUrl, url) : Uri.http(baseUrl, url);

    try {
      headers.addAll({'Accept': 'application/json'});
      if (withToken) {
        final token = await AppPreferences.getToken();
        headers.addAll({'Authorization': 'Bearer $token'});
      }

      log('POST: ${uri.toString()}', name: 'NETWORK SERVICE');
      log('PARAMS: ${data.toString()}', name: 'NETWORK SERVICE');
      log('HEADERS: ${headers.toString()}', name: 'NETWORK SERVICE');

      final response = await http.post(uri, body: data, headers: headers);
      return compileResponse(response);
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    } on NotFoundException {
      throw NotFoundException('Akun tidak terdaftar');
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> delete(
    String baseUrl,
    String url, {
    Map<String, String> headers = const {},
    Map<String, String> data = const {},
    bool withToken = true,
    bool isHttps = true,
  }) async {
    var uri = isHttps ? Uri.https(baseUrl, url) : Uri.http(baseUrl, url);

    try {
      headers.addAll({'Accept': 'application/json'});
      if (withToken) {
        final token = await AppPreferences.getToken();
        headers.addAll({'Authorization': 'Bearer $token'});
      }

      log('DELETE: ${uri.toString()}', name: 'NETWORK SERVICE');
      log('PARAMS: ${data.toString()}', name: 'NETWORK SERVICE');
      log('HEADERS: ${headers.toString()}', name: 'NETWORK SERVICE');

      final response = await http.delete(uri, body: data, headers: headers);
      return compileResponse(response);
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    } on NotFoundException {
      throw NotFoundException('Akun tidak terdaftar');
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> put(
    String baseUrl,
    String url, {
    bool withToken = false,
    bool isHttps = true,
    Map<String, String> data = const {},
    Map<String, String> headers = const {},
  }) async {
    var uri = isHttps ? Uri.https(baseUrl, url) : Uri.http(baseUrl, url);

    try {
      headers.addAll({'Accept': 'application/json'});
      if (withToken) {
        final token = await AppPreferences.getToken();
        headers.addAll({'Authorization': 'Bearer $token'});
      }
      log('PUT: ${uri.toString()}', name: 'NETWORK SERVICE');
      log('PARAMS: ${data.toString()}', name: 'NETWORK SERVICE');
      log('HEADERS: ${headers.toString()}', name: 'NETWORK SERVICE');

      final response = await http.put(uri, body: data, headers: headers);
      return compileResponse(response);
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    } on NotFoundException {
      throw NotFoundException('Akun tidak terdaftar');
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> postWithImage(
    String baseUrl,
    String url, {
    bool isHttps = true,
    bool withToken = true,
    bool isResponseJson = true,
    Map<String, File> images = const {},
    Map<String, String> data = const {},
    Map<String, String> headers = const {},
  }) async {
    try {
      var uri = isHttps ? Uri.https(baseUrl, url) : Uri.http(baseUrl, url);

      var request = http.MultipartRequest('POST', uri);

      Map<String, String> contentType = {"Content-type": "multipart/form-data"};
      request.headers.addAll(contentType);
      request.headers.addAll({'Accept': 'application/json'});

      if (withToken) {
        final token = await AppPreferences.getToken();
        headers.addAll({'Authorization': 'Bearer $token'});
      }

      log(uri.toString(), name: 'POST WITH IMAGES');
      log(request.headers.toString(), name: 'POST WITH IMAGES');
      log(data.toString(), name: 'POST WITH IMAGES');
      log(images.values.toString(), name: 'POST WITH IMAGES');

      images.forEach((key, image) {
        request.files.add(
          http.MultipartFile(
            key,
            image.readAsBytes().asStream(),
            image.lengthSync(),
            filename: image.uri.pathSegments.last,
            contentType: MediaType(
              'image',
              'jpeg',
            ),
          ),
        );
      });

      request.headers.addAll(headers);
      request.fields.addAll(data);

      var res = await request.send();
      final response = await http.Response.fromStream(res);

      if (isResponseJson) {
        return compileResponse(response);
      }
      return response;
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    }
  }

  static Future<dynamic> putWithImage(
    String baseUrl,
    String url, {
    bool isHttps = true,
    bool withToken = true,
    bool isResponseJson = true,
    Map<String, File> images = const {},
    Map<String, String> data = const {},
    Map<String, String> headers = const {},
  }) async {
    try {
      var uri = isHttps ? Uri.https(baseUrl, url) : Uri.http(baseUrl, url);

      var request = http.MultipartRequest('PUT', uri);

      Map<String, String> contentType = {"Content-type": "multipart/form-data"};
      request.headers.addAll(contentType);
      request.headers.addAll({'Accept': 'application/json'});

      if (withToken) {
        final token = await AppPreferences.getToken();
        headers.addAll({'Authorization': 'Bearer $token'});
      }

      log(uri.toString(), name: 'PUT WITH IMAGES');
      log(request.headers.toString(), name: 'PUT WITH IMAGES');
      log(data.toString(), name: 'PUT WITH IMAGES');
      log(images.values.toString(), name: 'PUT WITH IMAGES');

      images.forEach((key, image) {
        request.files.add(
          http.MultipartFile(
            key,
            image.readAsBytes().asStream(),
            image.lengthSync(),
            filename: image.uri.pathSegments.last,
            contentType: MediaType(
              'image',
              'jpeg',
            ),
          ),
        );
      });

      request.headers.addAll(headers);
      request.fields.addAll(data);

      var res = await request.send();
      final response = await http.Response.fromStream(res);

      if (isResponseJson) {
        return compileResponse(response);
      }
      return response;
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    }
  }
}
