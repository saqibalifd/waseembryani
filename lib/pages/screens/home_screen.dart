import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/categories_model.dart';
import 'package:waseembrayani/core/models/product_model.dart';
import 'package:waseembrayani/core/models/user_model.dart';
import 'package:waseembrayani/pages/screens/view_all_screen.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/widgets/banner_card.dart';
import 'package:waseembrayani/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CategoryModel>> futureCategories = fetchCategories();
  late Future<List<ProductModel>> futureFoodProducts = Future.value([]);
  late Future<List<ProductModel>> futurePopularProducts = Future.value([]);
  late Future<List<UserModel>> futureUserInfo = Future.value([]);
  List<CategoryModel> categories = [];
  String? slectedCategorie;
  final bool? isAdmin = false;
  @override
  void initState() {
    super.initState();
    _intilizeData();
  }

  void _intilizeData() async {
    try {
      final categories = await futureCategories;
      if (categories.isNotEmpty) {
        setState(() {
          this.categories = categories;
          slectedCategorie = categories.first.name;
          futureFoodProducts = fetchFoodProducts(slectedCategorie!);
          futurePopularProducts = fetchPopularProducts(slectedCategorie!);
          futureUserInfo = fetchUserInfo();
        });
      }
    } catch (e) {
      print('error in intilizing data : $e');
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await Supabase.instance.client
          .from('category_item')
          .select();
      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error in fetching categories : $e');
      return [];
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

  Future<List<ProductModel>> fetchFoodProducts(String categoryName) async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('categoryName', categoryName);
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error in fetching products : $e');
      return [];
    }
  }

  Future<List<ProductModel>> fetchPopularProducts(String categoryName) async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('isPopular', true)
          .eq('categoryName', categoryName);
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error in fetching popular products : $e');
      return [];
    }
  }

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // this is app bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          kToolbarHeight,
        ), // standard AppBar height
        child: FutureBuilder(
          future: futureUserInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!.first;
            isAdmin == data.isAdmin;

            return _appBAr(data.adress, data.profileImage);
          },
        ),
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              //this is order now card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BannerCard(
                  firstText: 'The Fatest In Delivery',
                  secondText: ' Food',
                  button: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAllScreen(),
                        ),
                      );
                    },

                    color: red,
                    height: 45,
                    minWidth: 110,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Order Now',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),

                  image: Image.asset(
                    'assets/images/3drider.webp',
                    height: 110,
                    width: 110,
                  ),
                ),
              ),

              _heading('Categories', true, () {}, isAdmin: isAdmin),
              //categoryies list view
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  height: 60,
                  child: FutureBuilder(
                    future: futureCategories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(color: red),
                        );
                      }
                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Center(child: Text('Some thing went wrong'));
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = category.name == slectedCategorie;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                slectedCategorie = category.name;
                                futureFoodProducts = fetchFoodProducts(
                                  category.name,
                                );
                                futurePopularProducts = fetchPopularProducts(
                                  category.name,
                                );
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: catregoryCard(
                                isSelected,
                                category.image,
                                category.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              _heading('Popular Now', true, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewAllScreen(
                      isPopular: true,
                      categoryName: slectedCategorie!,
                    ),
                  ),
                );
              }),
              //popular now list view card
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  height: 280,
                  child: FutureBuilder(
                    future: futurePopularProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(color: red),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Some thing went wrong'));
                      }
                      final foodProduct = snapshot.data ?? [];
                      if (foodProduct.isEmpty) {
                        return Center(
                          child: Text('this item is currently not available'),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final ProductModel passProduct =
                              snapshot.data![index];
                          return ProductCard(productModel: passProduct);
                        },
                      );
                    },
                  ),
                ),
              ),
              _heading('All Products', true, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewAllScreen(
                      isPopular: false,
                      categoryName: slectedCategorie!,
                    ),
                  ),
                );
              }),
              //all product card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                  future: futureFoodProducts,
                  builder: (context, snapshot) {
                    return GridView.builder(
                      itemCount: snapshot.data!.length,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .6,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(color: red),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Some thing went wrong'));
                        }
                        final foodProduct = snapshot.data ?? [];

                        if (foodProduct.isEmpty) {
                          return Center(
                            child: Text('this item is currently not available'),
                          );
                        }
                        final ProductModel passProduct = snapshot.data![index];
                        return ProductCard(productModel: passProduct);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//custom widgets
Widget _heading(
  String title,
  bool? isMoreButton,
  VoidCallback? onTap, {
  bool? isAdmin,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        isMoreButton == true
            ? isAdmin == true
                  ? GestureDetector(
                      onTap: onTap,
                      child: CircleAvatar(
                        backgroundColor: red,
                        radius: 20,
                        child: Center(
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: orange,
                          ),
                        ),
                        SizedBox(width: 5),

                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.navigate_next_rounded,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
            : SizedBox(),
      ],
    ),
  );
}

PreferredSizeWidget _appBAr(String adress, String profileImageUrl) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Image.asset(
        'assets/images/appiconLogo.png',
        height: 10,
        width: 10,
      ),
    ),
    centerTitle: true,
    forceMaterialTransparency: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: 20),
            Text(
              adress,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.location_on_outlined, size: 14, color: red),
            SizedBox(width: 5),

            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: orange),
          ],
        ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(profileImageUrl),
        ),
      ),
    ],
  );
}

Widget catregoryCard(
  bool isSelected,
  String categoryImage,
  String categoryName,
) {
  return Container(
    height: 60,
    width: 130,
    decoration: BoxDecoration(
      color: isSelected ? red : grey1,
      borderRadius: BorderRadius.circular(50),
      border: Border.all(
        color: isSelected ? Colors.white : Colors.transparent,
        width: 2,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          categoryImage,
          height: 40,
          width: 40,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.fastfood),
        ),
        SizedBox(width: 5),
        Text(
          categoryName ?? '',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ],
    ),
  );
}
