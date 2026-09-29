import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/colors/app_colors.dart';
import '../../core/models/product_model.dart';
import '../../core/widgets/custom_button.dart';
import '../cart/cubit/cart_cubit.dart';
import '../favorites/cubit/favorites_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
              actions: [
                BlocBuilder<FavoritesCubit, List<ProductModel>>(
                  builder: (context, favorites) {
                    final favCubit = context.read<FavoritesCubit>();
                    final isFav = favCubit.isFavorite(product.id);
                    return IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.primary),
                      onPressed: () => favCubit.toggleFavorite(product),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.fieldBackground,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(product.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.star, size: 18),
                        const SizedBox(width: 4),
                        Text('${product.rating}'),
                        if (product.bestSeller) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Best Seller',
                                style: TextStyle(color: AppColors.primary, fontSize: 11)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (product.description != null && product.description!.isNotEmpty)
                      Text(product.description!, style: const TextStyle(color: AppColors.grey)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text('\$${(product.price * quantity).toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        const Spacer(),
                        _QuantitySelector(
                          quantity: quantity,
                          onIncrease: () => setState(() => quantity++),
                          onDecrease: () => setState(() {
                            if (quantity > 1) quantity--;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: 'Add To Cart',
                onPressed: () {
                  context.read<CartCubit>().addToCart(product, quantity: quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('added ')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  const _QuantitySelector({
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _roundIcon(Icons.remove, onDecrease),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        _roundIcon(Icons.add, onIncrease, filled: true),
      ],
    );
  }

  Widget _roundIcon(IconData icon, VoidCallback onTap, {bool filled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: filled ? AppColors.primary : AppColors.fieldBackground,
        child: Icon(icon, size: 18, color: filled ? Colors.white : Colors.black),
      ),
    );
  }
}
