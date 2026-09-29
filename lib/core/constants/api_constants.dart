/// كل روابط الـ API اللي بعتهالي حاططها هنا في مكان واحد.
///
/// !! مهم جدا !!
/// روح غير قيمة baseUrl دي بالـ Link الحقيقي بتاع السيرفر عندك
/// (هو نفسه اللي كان متسجل في Postman باسم base_eco_url)
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://nti-ecommerce-api-production-8a47.up.railway.app/api/';


  static const String register = 'register';
  static const String login = 'login';
  static const String refreshToken = 'refresh_token';
  static const String updateProfile = 'update_profile';
  static const String getUserData = 'get_user_data';
  static const String deleteUser = 'delete_user';
  static const String sliders = 'sliders';
  static const String categories = 'categories';
  static const String products = 'products';
  static const String newProduct = 'new_product';
  static const String productsSearch = 'products/search';
  static const String bestSellerProducts = 'best_seller_products';
  static const String topRatedProducts = 'top_rated_products';
  static const String addToFavorite = 'add_to_favorite';
  static String productById(int id) => 'product/$id';
  static const String placeOrder = 'place_order';
  static const String orders = 'orders';
  static String cancelOrder(int id) => 'orders/cancel/$id';
  static String completeOrder(int id) => 'orders/complete/$id';
}
