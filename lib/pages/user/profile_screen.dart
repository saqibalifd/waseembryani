import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waseembrayani/models/user_model.dart';
import 'package:waseembrayani/pages/auth/login_screen.dart';
import 'package:waseembrayani/pages/policies/privacy_policy_screen.dart';
import 'package:waseembrayani/pages/policies/terms_conditions_screen.dart';
import 'package:waseembrayani/pages/user/account_setting_screen.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/service/user_services.dart';
import 'package:waseembrayani/utils/consts.dart';
import 'package:waseembrayani/utils/failure.dart';
import 'package:waseembrayani/utils/snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Future variable to hold user information
  late Future<List<UserModel>> futureUserInfo = Future.value([]);

  // Auth service for login/logout functionality
  final AuthService _authService = AuthService();

  // User service to fetch user info from backend
  final UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    _intilizeData(); // fetch user info on screen load
  }

  // method to initialize and set future user data
  void _intilizeData() async {
    try {
      setState(() {
        futureUserInfo = userServices.fetchUserInfo();
      });
    } catch (e) {
      print('error in intilizing data');
    }
  }

  // method to handle logout process
  void _logout() async {
    try {
      // show loading animation when logging out
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );

      // call logout service
      await _authService.logout(context);

      // after logout → navigate to Login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      // handle error cases
      if (e is Failure) {
        showSnackBar(context, e.message.toString());
      } else {
        showSnackBar(context, 'Unexpected error');
      }
    } finally {
      // dismiss loading indicator
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 AppBar with title
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
      ),

      body: Column(
        children: [
          // 🔹 Display user info using FutureBuilder
          Center(
            child: FutureBuilder(
              future: futureUserInfo,
              builder: (context, snapshot) {
                // 1️⃣ Loading state → show placeholder avatar & text
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 25),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 50,
                        child: Icon(Icons.person_outline, size: 50),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'email@gmail.com',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  );
                }

                // 2️⃣ Error or empty state → show fallback message
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Center(child: Text('Some thing went wrong'));
                }

                // 3️⃣ Success state → show actual user info
                final data = snapshot.data!.first;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25),

                    // Profile image (fallback if null/empty)
                    data.profileImage == null || data.profileImage == ''
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person_outline, size: 50),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(data.profileImage),
                          ),
                    SizedBox(height: 15),

                    // User name
                    Text(
                      data.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),

                    // User email
                    Text(
                      data.email,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 20),

          // 🔹 Navigation options
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountSettingScreen()),
              );
            },
            leading: Icon(Icons.person_outline, color: red),
            title: Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            trailing: Icon(Icons.navigate_next, color: red),
          ),

          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
            leading: Icon(Icons.lock_outline, color: red),
            title: Text(
              'Privacy Policy',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            trailing: Icon(Icons.navigate_next, color: red),
          ),

          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsConditionsScreen(),
                ),
              );
            },
            leading: Icon(Icons.file_copy_outlined, color: red),
            title: Text(
              'Terms and Conditions',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            trailing: Icon(Icons.navigate_next, color: red),
          ),

          Divider(color: red),

          // 🔹 Logout option
          ListTile(
            onTap: _logout,
            leading: Icon(Icons.logout, color: red),
            title: Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}
