// ignore: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/Api/auth/login.dart';
import 'package:movie_app/Api/user/update.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:movie_app/models/user.dart';
import 'package:provider/provider.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  late TextEditingController birthdayController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController addressController = TextEditingController();
  late TextEditingController currentPasswordController =
      TextEditingController();
  late TextEditingController newPasswordController = TextEditingController();
  late TextEditingController confirmPasswordController =
      TextEditingController();
  late String dbDate;
  late int id;
  bool isMatching = false;

  bool showPasswordFields = false;
  Map<String, bool> obscurePasswordFields = {
    'currentPassword': true,
    'newPassword': true,
    'confirmPassword': true,
  };

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode birthdayFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    nameController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    emailController.dispose();
    addressController.dispose();

    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    birthdayFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    id = user!.id;
    nameController = TextEditingController(text: user.fullname ?? '');
    phoneController = TextEditingController(text: user.phone ?? '');
    emailController = TextEditingController(text: user.email ?? '');
    addressController = TextEditingController(text: user.address ?? '');

    // Định dạng birthday nếu có
    if (user.birthday != null) {
      birthdayController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(user.birthday!),
      );
      dbDate = DateFormat('yyyy-MM-dd').format(user.birthday!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppTheme.colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Thông tin cá nhân', style: TextStyle(color: AppTheme.colors.white)),
        centerTitle: true,
      ),

      backgroundColor: AppTheme.colors.mainBackground,
      body: _page(),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                /*_headerPage(),*/
                const SizedBox(height: 30),
                _mainPage(),
                const SizedBox(height: 20),
                _updatePasswordSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const Spacer(),
        Text(
          'Thông tin cá nhân',
          style: TextStyle(
            color: AppTheme.colors.white,
            fontSize: 22,
            fontFamily: 'Poppins',
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _mainPage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildInputField(
                'Tên', nameController, nameFocusNode, screenWidth * 1),
            _buildInputField(
                'Số Điện Thoại', phoneController, phoneFocusNode, screenWidth * 0.48),
            _buildInputField('Ngày Sinh', birthdayController, birthdayFocusNode,
                screenWidth * 0.48,
                onTap: () => _pickDate(context), readOnly: true),
            _buildInputField('Địa Chỉ', addressController, addressFocusNode,
                screenWidth * 1),
          ],
        );
      },
    );
  }

  Widget _updatePasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showPasswordFields = !showPasswordFields;
                });
              },
              child: Text(
                'Cập Nhật Mật Khẩu',
                style: TextStyle(
                  color: AppTheme.colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.colors.white,
                  decorationThickness: 2.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (showPasswordFields)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildPasswordField('Mật Khẩu Hiện Tại', currentPasswordController,
                  MediaQuery.of(context).size.width * 0.9, 'currentPassword'),
              const SizedBox(height: 10),
              _buildPasswordField('Mật Khẩu Mới', newPasswordController,
                  MediaQuery.of(context).size.width * 0.9, 'newPassword'),
              const SizedBox(height: 10),
              _buildPasswordField('Xác Nhận Mật Khẩu', confirmPasswordController,
                  MediaQuery.of(context).size.width * 0.9, 'confirmPassword'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: isMatching
                          ? () async {
                              changePassword(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors.buttonColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        "Cập Nhật",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: AppTheme.colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        if (!showPasswordFields)
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    updateInfo(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.colors.buttonColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Cập Nhật",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppTheme.colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    FocusNode focusNode,
    double width, {
    bool showIcon = true,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                color: AppTheme.colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            focusNode: focusNode,
            style: TextStyle(color: AppTheme.colors.white),
            onTap: (!readOnly) ? focusNode.requestFocus : onTap,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle:
                  TextStyle(color: AppTheme.colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: AppTheme.colors.black.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              suffixIcon: showIcon
                  ? IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: AppTheme.colors.white,
                      ),
                      onPressed: () {
                        print('Update $label');
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      double width, String fieldKey) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                color: AppTheme.colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: (_) => validatePasswords(),
            controller: controller,
            obscureText: obscurePasswordFields[fieldKey]!,
            style: TextStyle(color: AppTheme.colors.white),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle:
                  TextStyle(color: AppTheme.colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: AppTheme.colors.black.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePasswordFields[fieldKey]!
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppTheme.colors.white,
                ),
                onPressed: () {
                  setState(() {
                    obscurePasswordFields[fieldKey] =
                        !obscurePasswordFields[fieldKey]!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(dbDate),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal, // Màu tiêu đề và nút "OK"
              onPrimary: Colors.white, // Màu chữ trên nút "OK"
              onSurface: Colors.black, // Màu chữ tiêu đề
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // Màu nút "CANCEL"
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    // Định dạng ngày hiển thị trong UI
    String displayDate = DateFormat('dd/MM/yyyy').format(pickedDate!);
    // Định dạng ngày lưu trữ trong DB
    dbDate = DateFormat('yyyy-MM-dd').format(pickedDate);
    setState(() {
      birthdayController.text = displayDate; // Cập nhật UI
    });
  }

  Future<void> updateInfo(BuildContext context) async {
    try {
      final response = await updateUser(id, nameController.text.trim(),
          phoneController.text.trim(), dbDate, addressController.text.trim());
      if (response["status"] == "SUCCESS") {
        saveLogin(context, User.fromJson(response['data']['user']));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(response['message'] ?? 'Cập nhật thông tin thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Cập nhật thất bại!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> changePassword(BuildContext context) async {
    try {
      final response = await updatePassword(
          id,
          currentPasswordController.text.trim(),
          newPasswordController.text.trim());
      if (response["status"] == "SUCCESS") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(response['message'] ?? 'Thay đổi mật khẩu thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Thay đổi mật khẩu thất bại!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void validatePasswords() {
    setState(() {
      isMatching = newPasswordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          newPasswordController.text == confirmPasswordController.text;
    });
  }
}
