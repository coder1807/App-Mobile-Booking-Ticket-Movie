class ScheduleItem {
  final int scheduleId;
  final int? filmId; // Thêm ? để cho phép null
  final DateTime? start;
  final int roomId;

  ScheduleItem(
      {required this.scheduleId,
      required this.roomId,
      required this.filmId,
      required this.start});

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      scheduleId: json['scheduleId'],
      filmId: json['filmId'] != null ? json['filmId'] as int : null,
      start: json['start'] != null ? DateTime.parse(json['start']) : null,
      roomId: json['roomId'] as int,
    );
  }
}
