import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/models/slider_model.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/utils/json_list_parser.dart';

part 'home_state.dart';

/// عقل شاشة الهوم: بيجيب 3 حاجات مع بعض من السيرفر
/// (البانر - الكاتيجوريز - المنتجات) عشان يعرضهم كلهم مرة واحدة.
class HomeCubit extends Cubit<HomeState> {
  final ApiClient apiClient;
  HomeCubit(this.apiClient) : super(HomeLoading());

  Future<void> loadHome() async {
    emit(HomeLoading());

    // بنجيب كل حاجة لوحدها في try/catch منفصل، عشان لو endpoint واحد
    // فيه مشكلة (401 مثلا) الباقي يفضل شغال وميقفش الشاشة كلها.
    final sliders = await _safeFetch(ApiConstants.sliders, 'SLIDERS')
        .then((list) => list.map((e) => SliderModel.fromJson(e)).toList());
    final categories = await _safeFetch(ApiConstants.categories, 'CATEGORIES')
        .then((list) => list.map((e) => CategoryModel.fromJson(e)).toList());
    final products = await _safeFetch(ApiConstants.products, 'PRODUCTS')
        .then((list) => list.map((e) => ProductModel.fromJson(e)).toList());

    emit(HomeLoaded(sliders: sliders, categories: categories, products: products));
  }

  /// بتجيب endpoint معين، ولو فشل بتطبع سبب الفشل بالتفصيل في الـ Console
  /// (هتلاقيه باسم مثلا "SLIDERS ERROR") وترجع List فاضية بدل ما توقف
  /// الشاشة كلها عن الظهور.
  Future<List<Map<String, dynamic>>> _safeFetch(String endpoint, String label) async {
    try {
      final response = await apiClient.get(endpoint);
      // ignore: avoid_print
      print('$label RESPONSE (${response.statusCode}): ${response.data}');
      return parseJsonList(response.data);
    } catch (e) {
      // ignore: avoid_print
      print('$label ERROR: $e');
      return [];
    }
  }
}
