import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/api_client.dart';
import '../../core/widgets/app_loading.dart';
import '../../core/widgets/product_card.dart';
import '../../core/models/product_model.dart';
import '../favorites/cubit/favorites_cubit.dart';
import '../products/product_details_screen.dart';
import 'cubit/search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(ApiClient()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();
  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final controller = TextEditingController();
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchCubit>().search(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: TextField(
          controller: controller,
          onChanged: _onChanged,
          decoration: const InputDecoration(
            hintText: 'Search any Product',
            border: InputBorder.none,
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(child: Text('write an prod'));
          }
          if (state is SearchLoading) return const AppLoading();
          if (state is SearchError) return Center(child: Text(state.message));

          final products = (state as SearchLoaded).products;
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
    );
  }
}
