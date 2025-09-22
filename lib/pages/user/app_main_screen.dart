import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:waseembrayani/core/models/user_model.dart';
import 'package:waseembrayani/pages/screens/admin_home_screen.dart';
import 'package:waseembrayani/pages/user/cart_screen.dart';
import 'package:waseembrayani/pages/user/home_screen.dart';
import 'package:waseembrayani/pages/user/profile_screen.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/pages/user/orders_screen.dart';
import 'package:waseembrayani/service/user_services.dart';

class AppMainScreen extends StatefulWidget {
  final int? getIndex;
  const AppMainScreen({super.key, this.getIndex});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  final UserServices _userServices = UserServices();
  final List<Widget> _pages = [
    HomeScreen(),
    OrdersScreen(),
    ProfileScreen(),
    CartScreen(),
  ];
  late int currentIndex;
  late Future<List<UserModel>> futureUserInfo = Future.value([]);
  @override
  void initState() {
    super.initState();
    _userServices.fetchUserInfo();
    currentIndex = widget.getIndex ?? 0;
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
                _buildNavItem(Iconsax.receipt, 'B', 1),
                SizedBox(width: 10),
                _buildNavItem(Icons.person_outline, 'C', 2),
                SizedBox(width: 10),

                Stack(
                  children: [
                    _buildNavItem(Iconsax.shopping_cart, 'D', 3),
                    Positioned(
                      left: 8,
                      right: 0,
                      top: 14,
                      child: PersistentShoppingCart().showCartItems(
                        cartItemsBuilder: (context, cartItems) {
                          if (cartItems.isEmpty) return SizedBox.shrink();
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
      floatingActionButton: FutureBuilder(
        future: _userServices.fetchUserInfo(),
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
