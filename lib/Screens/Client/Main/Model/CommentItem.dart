class CommentItem {
  final int commentId;
  final String commentContent;
  final String commentDayCreate;
  final int blogId;
  final int userId;

  const CommentItem({
    required this.commentId,
    required this.commentContent,
    required this.commentDayCreate,
    required this.blogId,
    required this.userId,
  });

  // Hàm chuyển đổi từ JSON sang đối tượng CommentItem
  factory CommentItem.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'commentId': int commentId,
      'commentContent': String commentContent,
      'commentDayCreate': String commentDayCreate,
      'blogId': int blogId,
      'userId': int userId,
      } =>
          CommentItem(
            commentId: commentId,
            commentContent: commentContent,
            commentDayCreate: commentDayCreate,
            blogId: blogId,
            userId: userId,
          ),
      _ => throw const FormatException('Failed to load comment item.'),
    };
  }

  // Hàm chuyển đối tượng CommentItem sang JSON
  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'commentContent': commentContent,
      'commentDayCreate': commentDayCreate,
      'blogId': blogId,
      'userId': userId,
    };
  }
}
