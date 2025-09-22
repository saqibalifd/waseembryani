import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waseembrayani/core/models/user_model.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/core/utils/failure.dart';
import 'package:waseembrayani/pages/auth/login_screen.dart';
import 'package:waseembrayani/pages/policies/privacy_policy_screen.dart';
import 'package:waseembrayani/pages/policies/terms_conditions_screen.dart';
import 'package:waseembrayani/pages/user/account_setting_screen.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/service/user_services.dart';
import 'package:waseembrayani/utils/snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<UserModel>> futureUserInfo = Future.value([]);
  final AuthService _authService = AuthService();
  final UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    _intilizeData();
  }

  void _intilizeData() async {
    try {
      setState(() {
        futureUserInfo = userServices.fetchUserInfo();
      });
    } catch (e) {
      print('error in intilizing data');
    }
  }

  void _logout() async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,

        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );
      await _authService.logout(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      if (e is Failure) {
        showSnackBar(context, e.message.toString());
      } else {
        showSnackBar(context, 'Unexpected error');
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Center(
            child: FutureBuilder(
              future: futureUserInfo,
              builder: (context, snapshot) {
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
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Center(child: Text('Some thing went wrong'));
                }
                final data = snapshot.data!.first;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25),
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
                    Text(
                      data.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
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
