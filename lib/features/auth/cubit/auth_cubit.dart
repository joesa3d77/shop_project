import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/token_storage.dart';

part 'auth_state.dart';

/// الـ Cubit هو "العقل" بتاع شاشة تسجيل الدخول والتسجيل.
/// هو اللي بيكلم الـ API ويقرر إيه الـ State اللي الشاشة تتغير له.
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

      // السيرفر ممكن يرجع اسم الحقل بشكل مختلف، فبنجرب أكتر من احتمال
      final data = response.data;
      final token = _extractToken(data);

      if (token != null) {
        await TokenStorage.saveToken(token);
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure(
            'الرجاء التأكد من اسم الـ token في رد السيرفر (شوف التعليق جوه login في auth_cubit.dart)'));
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

  /// دالة صغيرة بتدور على التوكن جوه رد السيرفر
  /// جربنا أكتر من اسم شائع (access_token / token / data.access_token)
  /// TODO: لو التوكن راجع باسم مختلف، ضيفه هنا
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
    // بنطبع الخطأ الحقيقي بالكامل في الـ Console عشان تقدر تشوف
    // السيرفر رد بإيه بالظبط (هتلاقيه تحت في تبويب "Run")
    // ignore: avoid_print
    print('AUTH ERROR: $e');

    // ولو السيرفر رجع رسالة خطأ واضحة (زي "email already exists")
    // بنحاول نطلعها ونعرضها لليوزر بدل رسالة عامة مش مفيدة
    if (e is DioException && e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        final message = data['message'] ?? data['error'] ?? data['msg'];
        if (message != null) return message.toString();
      }
      return 'خطأ من السيرفر (${e.response?.statusCode}): ${e.response?.data}';
    }
    return 'حصل خطأ، اتأكد من اتصالك بالنت ومن البيانات اللي داخلها';
  }
}
