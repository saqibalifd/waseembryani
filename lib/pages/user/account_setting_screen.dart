import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waseembrayani/models/user_model.dart';
import 'package:waseembrayani/pages/auth/forgot_password_screen.dart';
import 'package:waseembrayani/pages/auth/login_screen.dart';
import 'package:waseembrayani/pages/user/app_main_screen.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/service/user_services.dart';
import 'package:waseembrayani/utils/consts.dart';
import 'package:waseembrayani/utils/failure.dart';
import 'package:waseembrayani/utils/snackbar.dart';

/// Account Setting Screen
/// - Displays user info (name, email, address, profile image)
/// - Allows updating user details
/// - Provides password reset option
/// - Supports account deletion
class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  /// Step 1: Create instances of required services
  final UserServices _userServices = UserServices();
  final AuthService _authService = AuthService();

  /// Step 2: Text controllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  /// Step 3: Profile image url (empty initially)
  String profileImage = '';

  @override
  void initState() {
    super.initState();

    /// Step 4: Load user info when screen initializes
    _loadUserInfo();
  }

  /// Step 5: Fetch user info from API and set data into controllers
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

  /// Step 6: Update user info (name + address)
  void _updateUserInfo() async {
    try {
      // Show loading overlay
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );

      // Call update API
      await _userServices.updateUserInfo(
        nameController.text,
        addressController.text,
      );

      // Navigate back to main screen (Account tab)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppMainScreen(getIndex: 2)),
      );

      // Show success snackbar
      showSnackBar(context, 'User Profile is updated');
    } catch (e) {
      // Handle error properly
      print(e.toString());
      if (e is Failure) {
        showSnackBar(context, e.message.toString());
      } else {
        showSnackBar(context, 'Unexpected error');
      }
    } finally {
      EasyLoading.dismiss(); // Close loader
    }
  }

  /// Step 7: Delete user account
  void _deleteUserAccount() async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        indicator: LoadingAnimationWidget.stretchedDots(
          size: 30,
          color: Colors.white,
        ),
      );

      // Delete account via AuthService
      await _authService.deleteUser();

      // Redirect to Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

      // Show confirmation
      showSnackBar(context, "User account deleted successfully");
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
      /// Step 8: AppBar
      appBar: AppBar(
        title: Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        forceMaterialTransparency: false,
        automaticallyImplyLeading: false,
      ),

      /// Step 9: Scrollable body with profile + form fields
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 25),

              /// --- Profile Picture with overlay button ---
              SizedBox(
                height: 110,
                child: Stack(
                  children: [
                    // Display profile image or placeholder
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

                    // Overlay to change image
                    GestureDetector(
                      onTap: () => showImagePickerBottomSheet(context),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: .6),
                        radius: 50,
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          color: red,
                          size: 25,
                        ),
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

              /// --- Email field (read only) ---
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

              /// --- Change Password option ---
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ForgotPasswordScreen(email: emailController.text),
                    ),
                  );
                },
                leading: Icon(Iconsax.key, color: red),
                title: Text(
                  'Change Password',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                trailing: Icon(Icons.navigate_next, color: red),
              ),

              /// --- Delete Account option ---
              ListTile(
                tileColor: red,
                onTap: () => showDeleteAccountBottomSheet(context),
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

      /// Step 10: Update button (only visible if email is loaded)
      bottomNavigationBar: emailController.text == ""
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: MaterialButton(
                onPressed: () async {
                  _updateUserInfo();
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

  /// Step 11: Delete Account Confirmation BottomSheet
  void showDeleteAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag indicator
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Iconsax.warning_2, color: Colors.red, size: 60),
              const SizedBox(height: 15),
              const Text(
                "Delete Account?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "This action will permanently delete your account and all your data will be lost forever. Are you sure you want to continue?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 25),

              /// Cancel + Delete buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _deleteUserAccount();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Delete"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Step 12: Image Picker BottomSheet (Camera / Gallery options)
  void showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag indicator
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              const Icon(Iconsax.image, color: Colors.blue, size: 60),
              const SizedBox(height: 15),

              const Text(
                "Choose Image",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Select an image from your gallery or take a new one using the camera.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 25),

              /// Camera + Gallery buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _userServices.pickImageFromCamera();
                      },
                      icon: const Icon(Iconsax.camera),
                      label: const Text("Camera"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _userServices.pickImageFromGallery();
                      },
                      icon: const Icon(Iconsax.gallery),
                      label: const Text("Gallery"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
