import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/Blog/blogs.dart';
import 'package:movie_app/Screens/Client/Main/Views/BlogDetail.dart';
import 'package:movie_app/Themes/app_theme.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _ListBlog();
}

class _ListBlog extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.black, // Đặt màu nền thành màu đen
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBlog(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final blogsData = snapshot.data?.where((blog) {
            return blog['blogPoster'] != null && blog['blogTitle'] != null;
          }).toList() ?? [];

          print("Blog data: ");
          print(blogsData);

          if (blogsData.isEmpty) {
            return Center(
              child: Text(
                'No blogs available',
                style: TextStyle(color: Colors.white), // Màu chữ trắng
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: blogsData.length,
            itemBuilder: (context, index) {
              final blog = blogsData[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogDetail(blogId: blog['id']),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          '${dotenv.env['API']}' + blog['blogPoster']!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, size: 200);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        blog['blogTitle']!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.white, // Màu chữ trắng
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
