import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/Food/foods.dart';
import 'package:movie_app/Themes/app_theme.dart';

class ListFood extends StatefulWidget {
  const ListFood({super.key});

  @override
  State<ListFood> createState() => _ListFood();
}

class _ListFood extends State<ListFood> {
  late Future<List<Map<String, dynamic>>> foods;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppTheme.colors.mainBackground,
      //   title: Text(
      //     'Foods',
      //     style: TextStyle(
      //         fontFamily: 'Poppins',
      //         color: AppTheme.colors.white,
      //         fontSize: 18,
      //         fontWeight: FontWeight.w600),
      //   ),
      //   centerTitle: true,
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       size: 25,
      //       color: AppTheme.colors.white,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: Stack(
        children: [
          // Màu nền cho toàn bộ body
          Container(
            decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Thêm phần header vào đầu màn hình
                  _headerPage(),

                  SizedBox(height: 20),
                  // Hiển thị danh sách các món ăn
                  _FoodItem(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _FoodItem() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchFoods(), // Lấy danh sách món ăn từ API
      builder: (context, snapshot) {
        // Nếu đang đợi dữ liệu
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Nếu có lỗi khi tải dữ liệu
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Dữ liệu món ăn đã được tải về
        final foodsData = snapshot.data ?? [];

        return Wrap(
          spacing: 10, // Khoảng cách giữa các cột
          runSpacing: 10, // Khoảng cách giữa các hàng
          children: foodsData.map((food) {
            return GestureDetector(
              onTap: () {
                // Hiển thị modal khi người dùng nhấn vào hình ảnh
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.black.withOpacity(0.8), // Màu nền tối
                      title: Text(
                        food['name']!,
                        style: TextStyle(color: Colors.white), // Màu chữ trắng cho tiêu đề
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thông tin bên phải (giá và mô tả)
                            Text(
                              'Price: ${food['price']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white, // Màu chữ trắng
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              food['description']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white, // Màu chữ trắng
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(color: Colors.white), // Màu chữ trắng cho nút đóng
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: SizedBox(
                width: (MediaQuery.of(context).size.width - 30) / 2, // Mỗi item chiếm nửa chiều rộng màn hình
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        '${dotenv.env['API']}' + food['poster']!,
                        width: double.infinity,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 30) / 2,
                      child: Text(
                        food['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: AppTheme.colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _headerPage() {
    return Column(
      children: [
        Text(
          'Food',
          style: TextStyle(
            color: AppTheme.colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _buildPromotionBanner(),
      ],
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/Poster/poster4.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}