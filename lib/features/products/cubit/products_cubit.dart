
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/network/api_client.dart';
import '../../../core/models/product_model.dart';
import '../../../core/utils/json_list_parser.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ApiClient apiClient;
  ProductsCubit(this.apiClient) : super(ProductsLoading());

  Future<void> loadProducts(String endpoint) async {
    emit(ProductsLoading());
    try {
      final response = await apiClient.get(endpoint);
      // ignore: avoid_print
      print('PRODUCTS RESPONSE (${response.statusCode}): ${response.data}');
      final list = parseJsonList(response.data);
      final products = list.map((e) => ProductModel.fromJson(e)).toList();
      emit(ProductsLoaded(products));
    } catch (e) {
      // ignore: avoid_print
      print('PRODUCTS ERROR: $e');
      emit(const ProductsError('تعذر تحميل المنتجات'));
    }
  }
}