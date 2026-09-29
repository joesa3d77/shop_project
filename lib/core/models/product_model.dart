class ProductModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final double rating;
  final bool bestSeller;
  final String image;
  final int categoryId;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.rating,
    required this.bestSeller,
    required this.image,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      price: double.tryParse('${json['price'] ?? 0}') ?? 0,
      rating: double.tryParse('${json['rating'] ?? 0}') ?? 0,
      bestSeller: '${json['best_seller']}' == '1' ||
          json['best_seller'] == true,
      image: json['image_path'] ?? '',
      categoryId: int.tryParse('${json['category_id'] ?? 0}') ?? 0,
    );
  }
}
