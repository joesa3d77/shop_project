class CategoryModel {
  final int id;
  final String title;
  final String? description;
  final String? image;

  CategoryModel({
    required this.id,
    required this.title,
    this.description,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'],
      image: json['image_path'],
    );
  }
}
