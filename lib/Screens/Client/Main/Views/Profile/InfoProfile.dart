import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/manager/UserProvider.dart';
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
  String dbDate = "";

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
    nameController = TextEditingController(text: user?.fullname ?? '');
    phoneController = TextEditingController(text: user?.phone ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    addressController = TextEditingController(text: user?.address ?? '');

    // Định dạng birthday nếu có
    if (user?.birthday != null) {
      birthdayController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(user!.birthday!),
      );
      dbDate = DateFormat('yyyy-MM-dd').format(user.birthday!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _headerPage(),
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
        Spacer(),
        Text(
          'Personal Profile',
          style: TextStyle(
            color: AppTheme.colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        Spacer(),
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
                'Name', nameController, nameFocusNode, screenWidth * 1),
            _buildInputField(
                'Phone', phoneController, phoneFocusNode, screenWidth * 0.5),
            _buildInputField('Birthday', birthdayController, birthdayFocusNode,
                screenWidth * 0.5),
            _buildInputField('Address', addressController, addressFocusNode,
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
        GestureDetector(
          onTap: () {
            setState(() {
              showPasswordFields = !showPasswordFields;
            });
          },
          child: Text(
            'Update Password',
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
        const SizedBox(height: 10),
        if (showPasswordFields)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildPasswordField('Current Password', currentPasswordController,
                  MediaQuery.of(context).size.width * 0.9, 'currentPassword'),
              const SizedBox(height: 10),
              _buildPasswordField('New Password', newPasswordController,
                  MediaQuery.of(context).size.width * 0.9, 'newPassword'),
              const SizedBox(height: 10),
              _buildPasswordField('Confirm Password', confirmPasswordController,
                  MediaQuery.of(context).size.width * 0.9, 'confirmPassword'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("Updating Password");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors.buttonColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        "Update",
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
          ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      FocusNode focusNode, double width,
      {bool showIcon = true}) {
    return Container(
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
            obscureText: label.contains('Password'),
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
              suffixIcon: showIcon
                  ? IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: AppTheme.colors.white,
                      ),
                      onPressed: () {
                        focusNode.requestFocus();
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
    return Container(
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
}
