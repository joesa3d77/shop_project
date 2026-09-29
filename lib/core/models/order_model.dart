class OrderModel {
  final int id;
  final String status;
  final double total;
  final String? createdAt;

  OrderModel({
    required this.id,
    required this.status,
    required this.total,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      status: (json['status'] ?? 'active').toString().toLowerCase(),
      total: double.tryParse('${json['total'] ?? json['order_total'] ?? 0}') ??
          0,
      createdAt: json['created_at']?.toString(),
    );
  }
}
