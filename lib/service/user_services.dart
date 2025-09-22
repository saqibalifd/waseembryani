import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/models/user_model.dart';
import 'package:waseembrayani/utils/failure.dart';

class UserServices {
  // Reference to the 'users' table in Supabase
  final supabase = Supabase.instance.client.from('users');

  // Variable to store selected image file
  File? selectedImage;

  // Image picker instance for selecting images
  final ImagePicker _picker = ImagePicker();

  // ========================= PICK IMAGE FROM GALLERY =========================
  Future<void> pickImageFromGallery() async {
    try {
      // Step 1: Open gallery picker
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      // Step 2: If user selects an image, store it in selectedImage
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      }
    } catch (e) {
      // Step 3: Print error if picking fails
      print("Error picking image: $e");
    }
  }

  // ========================= PICK IMAGE FROM CAMERA =========================
  Future<void> pickImageFromCamera() async {
    try {
      // Step 1: Open camera to take a photo
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      // Step 2: If user captures a photo, store it in selectedImage
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      }
    } catch (e) {
      // Step 3: Print error if capturing fails
      print("Error picking image: $e");
    }
  }

  // ========================= STORE USER INFO =========================
  // Function to insert a new user into Supabase 'users' table
  Future<void> storeUserInfo({
    required String email,
    required String name,
    required String adress,
    required AuthResponse res,
    required BuildContext context,
  }) async {
    try {
      // Step 1: Create a UserModel object
      UserModel userModel = UserModel(
        name: name,
        email: email,
        userid: res.user!.id, // get ID from Supabase Auth
        profileImage: '',
        adress: adress,
        isAdmin: false, // default: not admin
      );

      // Step 2: Insert user info into 'users' table
      await supabase.insert(userModel.toJson());
    } catch (e) {
      // Step 3: Handle exceptions
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // ========================= FETCH USER INFO =========================
  // Function to get logged-in user info from Supabase
  Future<List<UserModel>> fetchUserInfo() async {
    try {
      // Step 1: Get current logged-in userId
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();

      // Step 2: Fetch user info where userid = current user's id
      final data =
          await Supabase.instance.client
                  .from('users')
                  .select()
                  .eq('userid', userId)
              as List<dynamic>;

      // Step 3: Convert response to List<UserModel>
      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      // Step 4: On failure, return empty list
      return [];
    }
  }

  // ========================= UPDATE USER INFO =========================
  Future updateUserInfo(String name, String address) async {
    try {
      // Step 1: Get current user ID
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();

      // Step 2: If no new image is selected, update only name & address
      if (selectedImage == null) {
        await supabase
            .update({'name': name, 'adress': address})
            .eq('userid', userId);
      } else {
        // Step 3: Generate unique filename for profile image
        final fileName = "${DateTime.now().millisecondsSinceEpoch}_$userId.jpg";

        // Step 4: Upload selected image to Supabase storage bucket 'profile_images'
        await Supabase.instance.client.storage
            .from('profile_images') // bucket name
            .upload(
              fileName,
              selectedImage!,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );

        // Step 5: Get public download URL for the uploaded image
        final downloadURL = Supabase.instance.client.storage
            .from('profile_images')
            .getPublicUrl(fileName);

        // Step 6: Update user record with new name, address, and profile image URL
        await supabase
            .update({
              'name': name,
              'adress': address,
              'profileImage': downloadURL,
            })
            .eq('userid', userId);
      }
    } catch (e) {
      // Step 7: Handle errors
      print('********* $e');
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // ========================= DELETE USER INFO =========================
  // Function to delete user info from Supabase 'users' table
  Future deleteUserInfo() async {
    try {
      // Step 1: Get current user ID
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();

      // Step 2: Delete user record where userid = current user
      await supabase.delete().eq('userid', userId);
    } catch (e) {
      // Step 3: Handle exceptions
      throw SupabaseExceptionHandler.handle(e);
    }
  }
}
