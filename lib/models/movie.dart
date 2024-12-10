class Movie {
  final int id;
  final String name;
  final String trailer;
  final String description;
  final String poster;
  final String director;
  final List<String> actors;
  final DateTime openingDay;
  final String subtitle;
  final int duration;
  final String limitAge;
  final String quality;
  final String countryName;
  final List<Map<String, dynamic>> categories;

  Movie(
    this.id,
    this.name,
    this.trailer,
    this.description,
    this.poster,
    this.director,
    this.actors,
    this.openingDay,
    this.subtitle,
    this.duration,
    this.limitAge,
    this.quality,
    this.countryName,
    this.categories,
  );

  Movie.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        trailer = json['trailer'],
        description = json['description'],
        poster = json['poster'],
        director = json['director'],
        actors =
            (json['actor'] as String).split(',').map((e) => e.trim()).toList(),
        openingDay = DateTime.parse(json['openingday']),
        subtitle = json['subtitle'],
        duration = json['duration'],
        limitAge = json['limit_age'],
        quality = json['quanlity'],
        countryName = json['countryName'],
        categories = (json['categories'] as List)
            .map((category) => category as Map<String, dynamic>)
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'trailer': trailer,
      'description': description,
      'poster': poster,
      'director': director,
      'actor': actors.join(', '),
      'openingday': openingDay.toIso8601String(),
      'subtitle': subtitle,
      'duration': duration,
      'limit_age': limitAge,
      'quanlity': quality,
      'countryName': countryName,
      'categories':
          categories.map((category) => {'categoryName': category}).toList(),
    };
  }
}
