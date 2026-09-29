import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/colors/app_colors.dart';
import '../../core/models/order_model.dart';
import '../../core/widgets/custom_button.dart';
import 'cubit/orders_cubit.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isActive = order.status == 'active';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order No. ${order.id.toString().padLeft(3, '0')}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(order.status,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
            if (order.createdAt != null) Text(order.createdAt!, style: const TextStyle(color: AppColors.grey)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Total', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            if (isActive)
              CustomButton(
                text: 'Cancel Order',
                color: Colors.white,
                textColor: AppColors.primary,
                outlined: true,
                onPressed: () {
                  context.read<OrdersCubit>().cancelOrder(order.id);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
