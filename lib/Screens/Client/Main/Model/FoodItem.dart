class FoodItem {
  final int combo_id;
  final String combo_name;
  final String description;
  final String combo_poster;
  final double combo_price;

  const FoodItem({
    required this.combo_id,
    required this.combo_name,
    required this.description,
    required this.combo_poster,
    required this.combo_price,
  });

  // Hàm chuyển đổi từ JSON sang đối tượng FoodItem
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'combo_id': int combo_id,
      'combo_name': String combo_name,
      'description': String description,
      'combo_poster': String combo_poster,
      'combo_price': num combo_price,
      } =>
          FoodItem(
            combo_id: combo_id,
            combo_name: combo_name,
            description: description,
            combo_poster: combo_poster,
            combo_price: combo_price.toDouble(), // Đảm bảo combo_price là double
          ),
      _ => throw const FormatException('Failed to load food item.'),
    };
  }

  // Hàm chuyển đối tượng FoodItem sang JSON (tuỳ chọn)
  Map<String, dynamic> toJson() {
    return {
      'combo_id': combo_id,
      'combo_name': combo_name,
      'description': description,
      'combo_poster': combo_poster,
      'combo_price': combo_price,
    };
  }
}
