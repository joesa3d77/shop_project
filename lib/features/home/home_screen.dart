import 'package:shop_project/core/assets/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/colors/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../core/widgets/app_loading.dart';
import '../../core/widgets/product_card.dart';
import '../../core/models/product_model.dart';
import '../favorites/cubit/favorites_cubit.dart';
import '../products/product_details_screen.dart';
import '../search/search_screen.dart';
import 'cubit/home_cubit.dart';
import 'widgets/home_banner.dart';
import 'widgets/category_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(ApiClient())..loadHome(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();
  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int selectedCategory = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) return const AppLoading();
            if (state is HomeError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }
            final loaded = state as HomeLoaded;

            final products = selectedCategory == -1
                ? loaded.products
                : loaded.products.where((p) => p.categoryId == selectedCategory).toList();

            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().loadHome(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(AppAssets.logo,width: 70),
                              const SizedBox(width: 8),

                            ],
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SearchScreen()),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.fieldBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.search, color: AppColors.grey),
                                  SizedBox(width: 8),
                                  Text('Search any Product', style: TextStyle(color: AppColors.grey)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: HomeBanner(sliders: loaded.sliders)),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('All Featured', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  if (loaded.categories.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('no ',
                            style: TextStyle(color: AppColors.grey, fontSize: 12)),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: loaded.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final cat = loaded.categories[index];
                          return CategoryItem(
                            category: cat,
                            selected: selectedCategory == cat.id,
                            onTap: () => setState(() {
                              selectedCategory = selectedCategory == cat.id ? -1 : cat.id;
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text('Recommended', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (products.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Text(
                          'لا توجد منتجات حاليا. تأكد إن الـ API بترجع بيانات فعلا\n(شوف الـ Console وابعتلي شكل الرد لو محتاج مساعدة)',
                          style: TextStyle(color: AppColors.grey, fontSize: 12),
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.68,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
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
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailsScreen(product: product),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
