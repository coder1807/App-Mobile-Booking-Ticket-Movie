import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/Blog/blogs.dart';
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
                    '${dotenv.env['API']}' + blogDetail['blogPoster']!,
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
                  blogDetail['blogTitle']!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: AppTheme.colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  blogDetail['blogContent']!,
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
                // Kiểm tra nếu có bình luận
                if (blogDetail['comments'] != null && blogDetail['comments'].isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: blogDetail['comments'].length,
                    itemBuilder: (context, index) {
                      final comment = blogDetail['comments'][index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          comment,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.colors.white,
                          ),
                        ),
                      );
                    },
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'No comments available.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}