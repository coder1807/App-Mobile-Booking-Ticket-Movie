class CinemaItem {
  final String imageUrl;
  final String name;
  final double rating;
  final String reviewCount;
  final String distance;
  final String location;
  bool isFavorite;

  CinemaItem({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.location,
    this.isFavorite = false,
  });
}
