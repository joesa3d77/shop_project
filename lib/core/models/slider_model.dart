class SliderModel {
  final int id;
  final String title;
  final String? description;
  final String image;

  SliderModel({
    required this.id,
    required this.title,
    this.description,
    required this.image,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      image: json['image_path'] ?? '',
    );
  }
}
