/// دالة عامة بتحاول تلاقي الـ List جوه رد السيرفر (response body)
/// أشكال الرد اللي بتدعمها:
///  1) List مباشرة:                [ {...}, {...} ]
///  2) Map فيها مفتاح "data":       { "data": [ {...} ] }
///  3) Map فيها مفتاح باسم المورد:  { "sliders": [ {...} ], "status": true }
///     (أو "products", "categories", "orders", ...)
/// لو مفيش أي List جوه الرد، بترجع List فاضية بدل ما تعمل Exception.
List<Map<String, dynamic>> parseJsonList(dynamic data) {
  if (data is List) {
    return data.cast<Map<String, dynamic>>();
  }

  if (data is Map) {
    // الأولوية لمفتاح "data" لو موجود
    if (data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    // غير كده، دور على أول List موجود جوه الـ Map
    // (زي "sliders" أو "products" أو "categories")
    for (final value in data.values) {
      if (value is List) {
        return value.cast<Map<String, dynamic>>();
      }
    }
  }

  return [];
}
