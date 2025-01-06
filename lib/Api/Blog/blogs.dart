import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<Map<String, dynamic>>> fetchBlog() async {
  final String? baseUrl = dotenv.env['MY_URL'];
  if (baseUrl == null || baseUrl.isEmpty) {
    throw Exception('API URL is not defined in .env file');
  }

  final String apiUrl = '$baseUrl/blogs';
  print('Fetching from: $apiUrl');

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        print('Unexpected data format: $data');
        return [];
      }
    } else {
      print('Failed to fetch blogs. Status Code: ${response.statusCode}');
      return [];
    }
  } catch (error) {
    print('Error occurred: $error');
    return [];
  }
}


Future<Map<String, dynamic>> fetchBlogDetailByID(int blogID) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/blogs/$blogID';

  if (apiUrl.isEmpty) {
    throw Exception('API URL is not defined in .env file');
  }

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Kiểm tra nếu dữ liệu trả về là List, bạn có thể lấy phần tử đầu tiên trong List
      if (data is List) {
        if (data.isNotEmpty) {
          return data[0]; // Trả về phần tử đầu tiên của List (giả sử blogID tương ứng với phần tử đầu tiên)
        } else {
          throw Exception('Blog not found');
        }
      } else if (data is Map<String, dynamic>) {
        return data; // Trả về dữ liệu nếu là Map
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } else {
      throw Exception('Failed to load blog detail, Status Code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error occurred: $error');
    throw Exception('Failed to fetch blog detail');
  }
}
