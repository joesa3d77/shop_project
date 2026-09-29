import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/colors/app_colors.dart';
import '../../core/models/cart_item_model.dart';
import '../../core/widgets/custom_button.dart';
import 'checkout_screen.dart';
import 'cubit/cart_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<CartCubit, List<CartItemModel>>(
        builder: (context, items) {
          if (items.isEmpty) {
            return const Center(child: Text('add products'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) => _CartTile(item: items[index]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal', style: TextStyle(color: AppColors.grey)),
                        Text('\$${context.read<CartCubit>().subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Checkout',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItemModel item;
  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: item.product.image,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(
              width: 64,
              height: 64,
              color: AppColors.fieldBackground,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('\$${item.product.price.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => context.read<CartCubit>().decreaseQuantity(item.product.id),
            ),
            Text('${item.quantity}'),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
              onPressed: () => context.read<CartCubit>().increaseQuantity(item.product.id),
            ),
          ],
        ),
      ],
    );
  }
}
