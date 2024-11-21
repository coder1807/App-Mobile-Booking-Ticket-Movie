import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool showPasswordFields = false;

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
            _buildInputField('Name', nameController, screenWidth * 0.55),
            _buildInputField('Phone', phoneController, screenWidth * 0.2),
            _buildInputField('Age', ageController, screenWidth * 0.2),
            _buildInputField('Address', addressController, screenWidth * 1),
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
              _buildInputField('Current Password', currentPasswordController,
                  MediaQuery.of(context).size.width * 0.9,
                  showIcon: false),
              const SizedBox(height: 10),
              _buildInputField('New Password', newPasswordController,
                  MediaQuery.of(context).size.width * 0.9,
                  showIcon: false),
              const SizedBox(height: 10),
              _buildInputField('Confirm Password', confirmPasswordController,
                  MediaQuery.of(context).size.width * 0.9,
                  showIcon: false),
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

  Widget _buildInputField(
      String label, TextEditingController controller, double width,
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
}
