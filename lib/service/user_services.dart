import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/user_model.dart';
import 'package:waseembrayani/core/utils/failure.dart';

class UserServices {
  final supabase = Supabase.instance.client.from('users');
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Function to pick an image from the gallery
  Future<void> pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> storeUserInfo({
    required String email,
    required String name,
    required String adress,
    required AuthResponse res,
    required BuildContext context,
  }) async {
    try {
      UserModel userModel = UserModel(
        name: name,
        email: email,
        userid: res.user!.id,
        profileImage: '',
        adress: adress,
        isAdmin: false,
      );

      await supabase.insert(userModel.toJson());
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // this functio will fetch user information from supabase
  Future<List<UserModel>> fetchUserInfo() async {
    try {
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();
      final data =
          await Supabase.instance.client
                  .from('users')
                  .select()
                  .eq('userid', userId)
              as List<dynamic>;

      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // update user information
  Future updateUserInfo(String name, String address) async {
    try {
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();

      if (selectedImage == null) {
        // No image selected → update only name & address
        await supabase
            .update({'name': name, 'adress': address})
            .eq('userid', userId);
      } else {
        // Upload new image
        final fileName = "${DateTime.now().millisecondsSinceEpoch}_$userId.jpg";

        await Supabase.instance.client.storage
            .from('profile_images') // 👈 bucket name
            .upload(
              fileName,
              selectedImage!,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            ); // content type

        // Get public URL
        final downloadURL = Supabase.instance.client.storage
            .from('profile_images')
            .getPublicUrl(fileName);

        // Update user record with image url
        await supabase
            .update({
              'name': name,
              'adress': address,
              'profileImage': downloadURL,
            })
            .eq('userid', userId);
      }
    } catch (e) {
      print('********* $e');
      throw SupabaseExceptionHandler.handle(e);
    }
  }

  // this function will delete user information
  Future deleteUserInfo() async {
    try {
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();
      await supabase.delete().eq('userid', userId);
    } catch (e) {
      throw SupabaseExceptionHandler.handle(e);
    }
  }
}
