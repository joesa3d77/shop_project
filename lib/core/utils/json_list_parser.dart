List<Map<String, dynamic>> parseJsonList(dynamic data) {
  if (data is List) {
    return data.cast<Map<String, dynamic>>();
  }

  if (data is Map) {
    if (data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    for (final value in data.values) {
      if (value is List) {
        return value.cast<Map<String, dynamic>>();
      }
    }
  }

  return [];
}
