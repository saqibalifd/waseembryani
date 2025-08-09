import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/user_model.dart';
import 'package:waseembrayani/pages/screens/add_product_screen.dart';
import 'package:waseembrayani/pages/screens/cart_screen.dart';
import 'package:waseembrayani/pages/screens/home_screen.dart';
import 'package:waseembrayani/pages/screens/profile_screen.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/pages/screens/favourite_screen.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  final List<Widget> _pages = [
    HomeScreen(),
    FavouriteScreen(),
    ProfileScreen(),
    CartScreen(),
  ];
  int currentIndex = 0;
  late Future<List<UserModel>> futureUserInfo = Future.value([]);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Iconsax.home_15, 'A', 0),
                SizedBox(width: 10),
                _buildNavItem(Iconsax.heart, 'B', 1),
                SizedBox(width: 10),
                _buildNavItem(Icons.person_outline, 'C', 2),
                SizedBox(width: 10),

                _buildNavItem(Iconsax.shopping_cart, 'D', 3),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: fetchUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox.shrink();
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return SizedBox.shrink();
          }
          final isAdmin = snapshot.data!.first.isAdmin;

          return isAdmin == true
              ? Positioned(
                  bottom: 25,
                  left: 50,
                  child: GestureDetector(
                    onTap: () {
                      print('On tap is pressed');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProductScreen(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: red,
                      radius: 35,
                      child: Icon(
                        CupertinoIcons.add,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink();
        },
      ),
    );
  }

  //helper method to build each navigation item
  Widget _buildNavItem(IconData icon, String lable, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: currentIndex == index ? red : Colors.grey,
          ),
          SizedBox(height: 3),
          CircleAvatar(
            radius: 3,
            backgroundColor: currentIndex == index ? red : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
