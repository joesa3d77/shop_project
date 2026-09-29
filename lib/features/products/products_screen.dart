import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/api_client.dart';
import '../../core/widgets/app_loading.dart';
import '../../core/widgets/product_card.dart';
import '../../core/models/product_model.dart';
import '../favorites/cubit/favorites_cubit.dart';
import 'cubit/products_cubit.dart';
import 'product_details_screen.dart';

class ProductsScreen extends StatelessWidget {
  final String title;
  final String endpoint;
  const ProductsScreen({super.key, required this.title, required this.endpoint});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit(ApiClient())..loadProducts(endpoint),
      child: Scaffold(
        appBar: AppBar(title: Text(title), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) return const AppLoading();
            if (state is ProductsError) return Center(child: Text(state.message));
            final products = (state as ProductsLoaded).products;
            if (products.isEmpty) return const Center(child: Text('no prod'));

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return BlocBuilder<FavoritesCubit, List<ProductModel>>(
                  builder: (context, favorites) {
                    final favCubit = context.read<FavoritesCubit>();
                    return ProductCard(
                      product: product,
                      isFavorite: favCubit.isFavorite(product.id),
                      onFavoriteTap: () => favCubit.toggleFavorite(product),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
