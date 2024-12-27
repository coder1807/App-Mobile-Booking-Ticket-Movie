class CinemaItem {
  final int id;
  // final String imageUrl;
  final String name;
  // final double rating;
  // final String reviewCount;
  // final String distance;
  final String location;
  final String map;
  bool isFavorite;

  CinemaItem({
    required this.id,
    // required this.imageUrl,
    required this.name,
    // required this.rating,
    // required this.reviewCount,
    // required this.distance,
    required this.map,
    required this.location,
    this.isFavorite = false,
  });
  factory CinemaItem.fromJson(Map<String, dynamic> json) {
    return CinemaItem(
      id: json['id'],
      name: json['name'],
      location: json['address'],
      map: json['map'],
    );
  }

  // Phương thức để chuyển CinemaItem thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': location,
      'map': map,
    };
  }
}
