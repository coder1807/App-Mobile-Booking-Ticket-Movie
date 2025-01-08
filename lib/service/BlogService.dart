import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/Blog/blogs.dart';
import 'package:movie_app/Screens/Client/Main/local_notification.dart';

class BlogService {
  static int lastFetchedBlogId = 0; // Lưu ID của bài blog mới nhất đã lấy

  Future<List<Map<String, dynamic>>> fetchBlogService() async {
    try {
      final response = await http.get(Uri.parse('${dotenv.env['API_URL']}/blogs'));
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> blogs = List<Map<String, dynamic>>.from(json.decode(response.body));
        return blogs;
      } else {
        print('Failed to fetch blogs. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching blogs: $e');
      return [];
    }
  }

  // Hàm kiểm tra blog mới và hiển thị thông báo nếu có blog mới
  Future<void> checkForNewBlog() async {
    try {
      List<Map<String, dynamic>> blogs = await fetchBlog();

      if (blogs.isNotEmpty) {
        int latestBlogId = blogs.first['id'];

        if (latestBlogId > lastFetchedBlogId) {
          lastFetchedBlogId = latestBlogId;
          String blogTitle = blogs.first['blogTitle'];

          LocalNotification.showSimpleNotification(
            title: 'New Blog Added',
            body: blogTitle,
            payload: 'Blog details',
          );
        }
      }
    } catch (e) {
      print('Error checking for new blogs: $e');
    }
  }
}
