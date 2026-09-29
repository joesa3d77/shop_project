import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/colors/app_colors.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/models/cart_item_model.dart';
import '../../core/widgets/custom_text_field.dart';
import '../orders/orders_screen.dart';
import 'cubit/cart_cubit.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final addressController = TextEditingController();
  bool isLoading = false;
  final apiClient = ApiClient();

  double get tax => 3;
  double get delivery => 2;

  Future<void> _placeOrder(BuildContext context) async {
    final cart = context.read<CartCubit>();
    if (cart.state.isEmpty) return;

    setState(() => isLoading = true);
    try {
      await apiClient.postJson(ApiConstants.placeOrder, {
        'items': cart.state
            .map((item) => {
          'product_id': item.product.id,
          'quantity': item.quantity,
        })
            .toList(),
      });

      cart.clearCart();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('added sucsessfulyii')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(' try again')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<CartCubit, List<CartItemModel>>(
        builder: (context, items) {
          final cart = context.read<CartCubit>();
          final subtotal = cart.subtotal;
          final total = subtotal + tax + delivery;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: addressController,
                  hint: 'Type address here or pick from map',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 24),
                _summaryRow('Subtotal', subtotal),
                _summaryRow('Tax and Fees', tax),
                _summaryRow('Delivery Fee', delivery),
                const Divider(height: 30),
                _summaryRow('Order Total', total, highlight: true),
                const Spacer(),
                CustomButton(
                  text: 'Place Order',
                  isLoading: isLoading,
                  onPressed: () => _placeOrder(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: highlight ? FontWeight.bold : FontWeight.normal)),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: highlight ? AppColors.primary : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
