import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/colors/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../core/widgets/app_loading.dart';
import '../../core/models/order_model.dart';
import 'cubit/orders_cubit.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit(ApiClient())..loadOrders(),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatefulWidget {
  const _OrdersView();
  @override
  State<_OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<_OrdersView> with SingleTickerProviderStateMixin {
  late final TabController tabController = TabController(length: 3, vsync: this);
  final tabs = const ['active', 'completed', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: 'Active'), Tab(text: 'Completed'), Tab(text: 'Cancelled')],
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) return const AppLoading();
          if (state is OrdersError) return Center(child: Text(state.message));
          final orders = (state as OrdersLoaded).orders;

          return TabBarView(
            controller: tabController,
            children: tabs.map((status) {
              final filtered = orders.where((o) => o.status == status).toList();
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long_outlined, size: 60, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text('You don\'t have any $status orders at this time',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.primary)),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _OrderTile(order: filtered[index]),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderModel order;
  const _OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order No. ${order.id.toString().padLeft(3, '0')}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.grey)),
                ],
              ),
            ),
            Text(order.status, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
