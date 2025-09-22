import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:waseembrayani/models/user_model.dart';
import 'package:waseembrayani/pages/admin/admin_home_screen.dart';
import 'package:waseembrayani/pages/user/cart_screen.dart';
import 'package:waseembrayani/pages/user/home_screen.dart';
import 'package:waseembrayani/pages/user/profile_screen.dart';
import 'package:waseembrayani/pages/user/orders_screen.dart';
import 'package:waseembrayani/service/user_services.dart';
import 'package:waseembrayani/utils/consts.dart';

// Main Screen of the app that holds bottom navigation and pages
class AppMainScreen extends StatefulWidget {
  final int? getIndex; // optional parameter to set initial tab
  const AppMainScreen({super.key, this.getIndex});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  final UserServices _userServices = UserServices();

  // List of screens for bottom navigation
  final List<Widget> _pages = [
    HomeScreen(), // index 0
    OrdersScreen(), // index 1
    ProfileScreen(), // index 2
    CartScreen(), // index 3
  ];

  late int currentIndex; // keeps track of selected tab
  late Future<List<UserModel>> futureUserInfo = Future.value([]);

  @override
  void initState() {
    super.initState();
    _userServices.fetchUserInfo(); // fetch user data on load
    currentIndex = widget.getIndex ?? 0; // set default tab (or from getIndex)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show selected page based on currentIndex
      body: _pages[currentIndex],

      // Bottom navigation bar
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Iconsax.home_15, 'A', 0), // Home
                SizedBox(width: 10),
                _buildNavItem(Iconsax.receipt, 'B', 1), // Orders
                SizedBox(width: 10),
                _buildNavItem(Icons.person_outline, 'C', 2), // Profile
                SizedBox(width: 10),

                // Cart with badge for item count
                Stack(
                  children: [
                    _buildNavItem(Iconsax.shopping_cart, 'D', 3), // Cart tab
                    Positioned(
                      left: 8,
                      right: 0,
                      top: 14,
                      child: PersistentShoppingCart().showCartItems(
                        cartItemsBuilder: (context, cartItems) {
                          // if no items → hide badge
                          if (cartItems.isEmpty) return SizedBox.shrink();
                          // badge showing number of items in cart
                          return CircleAvatar(
                            radius: 8,
                            backgroundColor: red,
                            child: Text(
                              cartItems.length.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

      // Floating action button → only visible for Admin users
      floatingActionButton: FutureBuilder(
        future: _userServices.fetchUserInfo(),
        builder: (context, snapshot) {
          // loading → hide button
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox.shrink();
          }
          // error or no user → hide button
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return SizedBox.shrink();
          }

          final isAdmin = snapshot.data!.first.isAdmin;

          // If user is Admin → show red FAB to open AdminHomeScreen
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
                          builder: (context) => AdminHomeScreen(),
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
              : SizedBox.shrink(); // if not Admin → no floating button shown
        },
      ),
    );
  }

  // Helper method to build each navigation item (icon + indicator dot)
  Widget _buildNavItem(IconData icon, String lable, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index; // update selected index on tap
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon changes color when active
          Icon(
            icon,
            size: 28,
            color: currentIndex == index ? red : Colors.grey,
          ),
          SizedBox(height: 3),
          // Small dot below active tab
          CircleAvatar(
            radius: 3,
            backgroundColor: currentIndex == index ? red : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
