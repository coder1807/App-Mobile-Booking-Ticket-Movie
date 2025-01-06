class BlogItem {
  final int blogId;
  final String blogContent;
  final String blogDayCreate;
  final String blogPoster;
  final String blogTitle;

  const BlogItem({
    required this.blogId,
    required this.blogContent,
    required this.blogDayCreate,
    required this.blogPoster,
    required this.blogTitle,
  });

  // Hàm chuyển đổi từ JSON sang đối tượng BlogItem
  factory BlogItem.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'blogId': int blogId,
      'blogContent': String blogContent,
      'blogDayCreate': String blogDayCreate,
      'blogPoster': String blogPoster,
      'blogTitle': String blogTitle,
      } =>
          BlogItem(
            blogId: blogId,
            blogContent: blogContent,
            blogDayCreate: blogDayCreate,
            blogPoster: blogPoster,
            blogTitle: blogTitle,
          ),
      _ => throw const FormatException('Failed to load blog item.'),
    };
  }

  // Hàm chuyển đối tượng BlogItem sang JSON
  Map<String, dynamic> toJson() {
    return {
      'blogId': blogId,
      'blogContent': blogContent,
      'blogDayCreate': blogDayCreate,
      'blogPoster': blogPoster,
      'blogTitle': blogTitle,
    };
  }
}

