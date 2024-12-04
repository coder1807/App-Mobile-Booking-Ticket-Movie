// ignore: file_names
import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool rememberMe = true;
  bool biometricId = false;
  bool faceId = false;
  bool smsAuthenticator = false;
  bool googleAuthenticator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Security",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.colors.mainBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Remember me",
                        style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.colors.white,
                            fontWeight: FontWeight.w600)),
                    Switch(
                      value: rememberMe,
                      activeTrackColor: AppTheme.colors.orange,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Biometric ID",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white,
                            fontWeight: FontWeight.w600)),
                    Switch(
                      value: biometricId,
                      activeTrackColor: AppTheme.colors.orange,
                      onChanged: (value) {
                        setState(() {
                          biometricId = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Face ID",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white,
                            fontWeight: FontWeight.w600)),
                    Switch(
                      value: faceId,
                      activeTrackColor: AppTheme.colors.orange,
                      onChanged: (value) {
                        setState(() {
                          faceId = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SMS Authenticator",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white,
                            fontWeight: FontWeight.w600)),
                    Switch(
                      value: smsAuthenticator,
                      activeTrackColor: AppTheme.colors.orange,
                      onChanged: (value) {
                        setState(() {
                          smsAuthenticator = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Google Authenticator",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white,
                            fontWeight: FontWeight.w600)),
                    Switch(
                      value: googleAuthenticator,
                      activeTrackColor: AppTheme.colors.orange,
                      onChanged: (value) {
                        setState(() {
                          googleAuthenticator = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
