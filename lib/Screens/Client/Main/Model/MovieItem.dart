class MovieItem {
  final int id;
  final String name;
  final String trailer;
  final String description;
  final String poster;
  final String director;
  final String actor;
  final String openingday;
  final String subtitle;
  final int duration;
  final String limit_age;
  final String quanlity;
  final String countryName;
  final List<Category> categories;

  MovieItem({
    required this.id,
    required this.name,
    required this.trailer,
    required this.description,
    required this.poster,
    required this.director,
    required this.actor,
    required this.openingday,
    required this.subtitle,
    required this.duration,
    required this.limit_age,
    required this.quanlity,
    required this.countryName,
    required this.categories,
  });

  factory MovieItem.fromJson(Map<String, dynamic> json) {
    return MovieItem(
      id: json['id'],
      name: json['name'],
      trailer: json['trailer'],
      description: json['description'],
      poster: json['poster'],
      director: json['director'],
      actor: json['actor'],
      openingday: json['openingday'],
      subtitle: json['subtitle'],
      duration: json['duration'],
      limit_age: json['limit_age'],
      quanlity: json['quanlity'],
      countryName: json['countryName'],
      categories: (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList(),
    );
  }
}

class Category {
  final String categoryName;

  Category({required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(categoryName: json['categoryName']);
  }
}
