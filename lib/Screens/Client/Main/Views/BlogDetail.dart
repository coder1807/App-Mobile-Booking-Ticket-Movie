import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/Blog/blogs.dart';
import 'package:movie_app/Api/Comment/comments.dart';
import 'package:movie_app/Themes/app_theme.dart';


class BlogDetail extends StatelessWidget {
  final int blogId;

  const BlogDetail({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Đặt màu nền của Scaffold là màu đen
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        title: Text(
          'News',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: AppTheme.colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchBlogDetailByID(blogId), // Hàm API lấy chi tiết blog theo id
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final blogDetail = snapshot.data;

          if (blogDetail == null) {
            return Center(child: Text('Blog not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sửa lại phần hiển thị ảnh
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    '${dotenv.env['API']}' + (blogDetail['blogPoster'] ?? ''),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 250);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  blogDetail['blogTitle'] ?? 'Untitled', // Kiểm tra null và gán giá trị mặc định
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: AppTheme.colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  blogDetail['blogContent'] ?? 'No content available.', // Kiểm tra null và gán giá trị mặc định
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: AppTheme.colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Comments:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: AppTheme.colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Hiển thị các comment từ hàm fetchCommentsByBlogID
                FutureBuilder<List<dynamic>>(
                  future: fetchCommentsByBlogID(blogId), // Lấy bình luận theo blogId
                  builder: (context, commentSnapshot) {
                    if (commentSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (commentSnapshot.hasError) {
                      return Center(child: Text('Error: ${commentSnapshot.error}'));
                    }

                    final comments = commentSnapshot.data;

                    if (comments == null || comments.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'No comments available.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.colors.white,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment['fullName'] ?? 'Anonymous', // Kiểm tra null và gán giá trị mặc định
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment['commentContent'] ?? 'No content available.', // Kiểm tra null và gán giá trị mặc định
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
