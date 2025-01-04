class RoomItem {
  final int id;
  final String name;
  final String description;

  RoomItem({required this.id, required this.name, required this.description});

  factory RoomItem.fromJson(Map<String, dynamic> json) {
    return RoomItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
