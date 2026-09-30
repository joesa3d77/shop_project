import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/token_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiClient apiClient;
  AuthCubit(this.apiClient) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final response = await apiClient.postForm(ApiConstants.login, {
        'email': email,
        'password': password,
      });

      final data = response.data;
      final token = _extractToken(data);

      if (token != null) {
        await TokenStorage.saveToken(token);
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure(
            'error'));
      }
    } catch (e) {
      emit(AuthFailure(_errorMessage(e)));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(AuthLoading());
    try {
      await apiClient.postForm(ApiConstants.register, {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(_errorMessage(e)));
    }
  }

  String? _extractToken(dynamic data) {
    if (data is Map) {
      if (data['access_token'] != null) return data['access_token'].toString();
      if (data['token'] != null) return data['token'].toString();
      if (data['data'] is Map) {
        final inner = data['data'] as Map;
        if (inner['access_token'] != null) return inner['access_token'].toString();
        if (inner['token'] != null) return inner['token'].toString();
      }
    }
    return null;
  }

  String _errorMessage(Object e) {
    print('AUTH ERROR: $e');

    if (e is DioException && e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        final message = data['message'] ?? data['error'] ?? data['msg'];
        if (message != null) return message.toString();
      }
      return ' error  (${e.response?.statusCode}): ${e.response?.data}';
    }
    return 'error';
  }
}
