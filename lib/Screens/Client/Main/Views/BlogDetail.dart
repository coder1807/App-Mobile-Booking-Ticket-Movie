import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/Blog/blogs.dart';
import 'package:movie_app/Api/Comment/comments.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:provider/provider.dart';

class BlogDetail extends StatefulWidget {
  final int blogId;

  const BlogDetail({super.key, required this.blogId});

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  TextEditingController _commentController = TextEditingController();

  // Hàm submit comment
  void _submitComment() async {
    if (_commentController.text.isEmpty) {
      return;
    }
    final user = Provider.of<UserProvider>(context, listen: false).user;


    final commentDTO = {
      'blogId': widget.blogId,
      'userId': user!.id, // Đặt ID người dùng hiện tại.
      'content': _commentController.text,

    };


    // Gọi hàm submitComment để gửi dữ liệu lên server
    await submitComment(commentDTO);
    setState(() {
      // Xóa nội dung đã nhập sau khi submit
      _commentController.clear();
    });
  }

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
        iconTheme: IconThemeData(
          color: Colors.white, // Thiết lập màu trắng cho nút trở về
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchBlogDetailByID(widget.blogId), // Hàm API lấy chi tiết blog theo id
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
                  future: fetchCommentsByBlogID(widget.blogId), // Lấy bình luận theo blogId
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
                // Phần nhập comment của người dùng
                const SizedBox(height: 20),
                TextField(
                  controller: _commentController,
                  style: TextStyle(color: AppTheme.colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your comment...',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Màu nền của nút
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    ' Comment ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: AppTheme.colors.white,
                      fontWeight: FontWeight.bold,
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
