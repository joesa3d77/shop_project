import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/models/order_model.dart';
import '../../../core/utils/json_list_parser.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final ApiClient apiClient;
  OrdersCubit(this.apiClient) : super(OrdersLoading());

  Future<void> loadOrders() async {
    emit(OrdersLoading());
    try {
      final response = await apiClient.get(ApiConstants.orders);
      final list = parseJsonList(response.data);
      emit(OrdersLoaded(list.map((e) => OrderModel.fromJson(e)).toList()));
    } catch (e) {
      emit(const OrdersError('error'));
    }
  }

  Future<void> cancelOrder(int id) async {
    try {
      await apiClient.postJson(ApiConstants.cancelOrder(id), {});
      loadOrders();
    } catch (_) {}
  }
}
