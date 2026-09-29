part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
  @override
  List<Object?> get props => [];
}

class ProductsLoading extends ProductsState {}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  const ProductsLoaded(this.products);
  @override
  List<Object?> get props => [products];
}
