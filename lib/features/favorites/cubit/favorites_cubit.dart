import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/models/product_model.dart';


class FavoritesCubit extends Cubit<List<ProductModel>> {
  final ApiClient apiClient;
  FavoritesCubit(this.apiClient) : super([]);

  bool isFavorite(int productId) => state.any((p) => p.id == productId);

  Future<void> toggleFavorite(ProductModel product) async {
    final items = List<ProductModel>.from(state);
    final exists = items.any((p) => p.id == product.id);

    if (exists) {
      items.removeWhere((p) => p.id == product.id);
      emit(items);
    } else {
      items.add(product);
      emit(items);
      try {
        await apiClient.postForm(ApiConstants.addToFavorite, {
          'product_id': product.id.toString(),
        });
      } catch (_) {
      }
    }
  }
}
