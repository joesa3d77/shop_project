import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/cart_item_model.dart';
import '../../../core/models/product_model.dart';

class CartCubit extends Cubit<List<CartItemModel>> {
  CartCubit() : super([]);

  void addToCart(ProductModel product, {int quantity = 1}) {
    final items = List<CartItemModel>.from(state);
    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      items[index].quantity += quantity;
    } else {
      items.add(CartItemModel(product: product, quantity: quantity));
    }
    emit(items);
  }

  void increaseQuantity(int productId) {
    final items = List<CartItemModel>.from(state);
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      items[index].quantity++;
      emit(items);
    }
  }

  void decreaseQuantity(int productId) {
    final items = List<CartItemModel>.from(state);
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
      emit(items);
    }
  }

  void removeFromCart(int productId) {
    final items = List<CartItemModel>.from(state)
      ..removeWhere((item) => item.product.id == productId);
    emit(items);
  }

  void clearCart() => emit([]);

  double get subtotal => state.fold(0, (sum, item) => sum + item.totalPrice);
}
