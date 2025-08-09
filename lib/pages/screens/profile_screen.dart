import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/user_model.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/service/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<UserModel>> futureUserInfo = Future.value([]);
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _intilizeData();
  }

  void _intilizeData() async {
    try {
      setState(() {
        futureUserInfo = fetchUserInfo();
      });
    } catch (e) {
      print('error in intilizing data : $e');
    }
  }

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
      print('Error in fetching user info : $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        forceMaterialTransparency: false,
      ),
      body: Center(
        child: FutureBuilder(
          future: futureUserInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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
                SizedBox(
                  height: 110,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(data.profileImage),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: red,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  data.name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Text(
                  data.email,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.lock_outline, color: red),
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),

                  trailing: Icon(Icons.navigate_next, color: red),
                ),
                ListTile(
                  leading: Icon(Icons.file_copy_outlined, color: red),
                  title: Text(
                    'Terms and Conditions',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),

                  trailing: Icon(Icons.navigate_next, color: red),
                ),
                ListTile(
                  onTap: () {
                    _authService.logout(context);
                  },
                  leading: Icon(Icons.logout, color: red),
                  title: Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
