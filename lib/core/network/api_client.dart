import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'token_storage.dart';



class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) {
    return _dio.get(path, queryParameters: query);
  }

  Future<Response> postForm(String path, Map<String, dynamic> data) {
    final formData = FormData.fromMap(data);
    return _dio.post(path, data: formData);
  }

  Future<Response> postJson(String path, Map<String, dynamic> data) {
    return _dio.post(path, data: data);
  }

  Future<Response> putForm(String path, Map<String, dynamic> data) {
    final formData = FormData.fromMap(data);
    return _dio.put(path, data: formData);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
