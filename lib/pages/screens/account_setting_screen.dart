import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:waseembrayani/core/models/user_model.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/pages/screens/app_main_screen.dart';
import 'package:waseembrayani/service/user_services.dart';
import 'package:waseembrayani/widgets/snackbar.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  final UserServices _userServices = UserServices();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String profileImage = '';
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final List<UserModel> users = await _userServices.fetchUserInfo();

    if (users.isNotEmpty) {
      final userinfo = users.first; // take first user
      setState(() {
        nameController.text = userinfo.name ?? "";
        addressController.text = userinfo.adress ?? "";
        emailController.text = userinfo.email ?? "";
        profileImage = userinfo.profileImage ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        forceMaterialTransparency: false,
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 25),
              SizedBox(
                height: 110,
                child: Stack(
                  children: [
                    profileImage == null || profileImage == ''
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 50),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(profileImage),
                          ),
                    CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: .6),
                      radius: 50,
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: red,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// --- Name field ---
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == '' || value!.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              /// --- Email field ---
              TextFormField(
                readOnly: true,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == '' || value!.isEmpty) {
                    return 'Please enter email';
                  }

                  // Regex validation for email format
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              /// --- Address field ---
              TextFormField(
                controller: addressController,
                keyboardType: TextInputType.streetAddress,
                validator: (value) {
                  if (value == '' || value!.isEmpty) {
                    return 'Please enter adress';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: red),
              const SizedBox(height: 10),

              ListTile(
                onTap: () {},
                leading: Icon(Iconsax.key, color: red),
                title: Text(
                  'Change Password',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),

                trailing: Icon(Icons.navigate_next, color: red),
              ),
              ListTile(
                tileColor: red,
                onTap: () {},
                leading: Icon(Iconsax.profile_delete, color: Colors.white),
                title: Text(
                  'Delete Account',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: emailController.text == ""
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: MaterialButton(
                onPressed: () async {
                  showSnackBar(context, 'User Profile is updated');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppMainScreen(getIndex: 2),
                    ),
                  );
                },
                color: red,
                height: 60,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
    );
  }
}
