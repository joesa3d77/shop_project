part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}

class HomeLoaded extends HomeState {
  final List<SliderModel> sliders;
  final List<CategoryModel> categories;
  final List<ProductModel> products;

  const HomeLoaded({
    required this.sliders,
    required this.categories,
    required this.products,
  });

  @override
  List<Object?> get props => [sliders, categories, products];
}
