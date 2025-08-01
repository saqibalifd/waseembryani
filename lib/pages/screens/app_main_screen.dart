import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:waseembrayani/pages/screens/home_screen.dart';
import 'package:waseembrayani/pages/screens/profile_screen.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/pages/screens/user_activity/favourite_screen.dart';

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
    Scaffold(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Iconsax.home_15, 'A', 0),
            SizedBox(width: 10),
            _buildNavItem(Iconsax.heart, 'B', 1),
            SizedBox(width: 90),
            _buildNavItem(Icons.person_outline, 'C', 2),
            SizedBox(width: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildNavItem(Iconsax.shopping_cart, 'D', 3),
                Positioned(
                  right: -7,
                  top: 16,
                  //we will make this numbert of cart item
                  child: CircleAvatar(
                    backgroundColor: red,
                    radius: 10,
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  right: 125,
                  top: -25,
                  child: CircleAvatar(
                    backgroundColor: red,
                    radius: 35,
                    child: Icon(
                      CupertinoIcons.search,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
