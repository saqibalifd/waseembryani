import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/categories_model.dart';
import 'package:waseembrayani/core/models/product_model.dart';
import 'package:waseembrayani/core/models/user_model.dart';
import 'package:waseembrayani/pages/user/app_main_screen.dart';
import 'package:waseembrayani/pages/user/view_all_screen.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/service/categories_services.dart';
import 'package:waseembrayani/service/product_services.dart';
import 'package:waseembrayani/service/user_services.dart';
import 'package:waseembrayani/widgets/banner_card.dart';
import 'package:waseembrayani/widgets/categories_card.dart';
import 'package:waseembrayani/widgets/product_card.dart';
import 'package:waseembrayani/widgets/shimmer/categoris_card_shimmer.dart';
import 'package:waseembrayani/widgets/shimmer/product_grid_card_shimmer.dart';
import 'package:waseembrayani/widgets/shimmer/product_horizontal_cardShimmer.dart';

/// Home Screen of the app.
/// Displays banner, categories, popular products, and all products.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// --- Services for API Calls ---
  final CategoriesServices _categoriesServices = CategoriesServices();
  final ProductServices _productServices = ProductServices();
  final UserServices _userServices = UserServices();

  /// --- Future variables to fetch data ---
  late Future<List<CategoryModel>> futureCategories = _categoriesServices
      .fetchCategories();
  late Future<List<ProductModel>> futureFoodProducts = Future.value([]);
  late Future<List<ProductModel>> futurePopularProducts = Future.value([]);
  late Future<List<UserModel>> futureUserInfo = Future.value([]);

  /// --- State variables ---
  List<CategoryModel> categories = []; // list of all categories
  String? slectedCategorie; // currently selected category
  final bool? isAdmin = false; // check if user is admin
  final String userId = Supabase.instance.client.auth.currentUser!.id
      .toString(); // logged in user id

  @override
  void initState() {
    super.initState();
    _intilizeData(); // fetch categories, products, and user info
  }

  /// Initialize categories, products, and user info
  void _intilizeData() async {
    try {
      final categories = await futureCategories;
      if (categories.isNotEmpty) {
        setState(() {
          this.categories = categories;
          slectedCategorie =
              categories.first.name; // select first category by default

          // Fetch products based on the first category
          futureFoodProducts = _productServices.fetchFoodProducts(
            slectedCategorie!,
          );
          futurePopularProducts = _productServices.fetchPopularProducts(
            slectedCategorie!,
          );
          futureUserInfo = _userServices.fetchUserInfo();
        });
      }
    } catch (e) {
      print('error in intilizing data : $e');
    }
  }

  /// Add product to favourite table in Supabase
  Future addToFavourite(ProductModel productModel) async {
    try {
      EasyLoading.show(status: 'loading...');

      await Supabase.instance.client
          .from('favourite')
          .insert(productModel.toJson());

      EasyLoading.dismiss();
      print('add to favourite success');
    } catch (e) {
      print('Error in Adding to favourite products : $e');
      EasyLoading.dismiss();
      return [];
    }
  }

  /// Check if a product is already in favourites for current user
  Future<bool> checkIsFavourite(int productId) async {
    try {
      final String userId = Supabase.instance.client.auth.currentUser!.id;

      final response = await Supabase.instance.client
          .from('favourite')
          .select()
          .eq('favUserId', userId)
          .eq('id', productId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking favourite: $e');
      return false;
    }
  }

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// Custom AppBar (shows user info if available)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _buildAppBar(),
      ),

      /// Body with scrollable content
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            /// --- Banner section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BannerCard(
                firstText: 'The Fastest In Delivery',
                secondText: ' Food',
                button: _orderNowButton(),
                image: Image.asset(
                  'assets/images/3drider.webp',
                  height: 110,
                  width: 110,
                ),
              ),
            ),

            /// --- Categories section ---
            _heading('Categories', false, () {}, isAdmin: isAdmin),
            _buildCategoriesList(),

            /// --- Popular products ---
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
            _buildPopularProducts(),

            /// --- All products ---
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
            _buildAllProducts(),
          ],
        ),
      ),
    );
  }

  /// ---------------- Widgets ----------------

  /// "Order Now" button inside the banner
  Widget _orderNowButton() {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewAllScreen()),
        );
      },
      color: red,
      height: 45,
      minWidth: 110,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: const Text(
        'Order Now',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  /// Build AppBar (shows user address and profile pic if logged in)
  Widget _buildAppBar() {
    return FutureBuilder(
      future: futureUserInfo,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final hasError =
            snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty;

        if (isLoading || hasError) {
          return _defaultAppBar();
        }

        final data = snapshot.data!.first;
        final bool isAdmin = data.isAdmin;

        return AppBar(
          leading: _appLogo(),
          centerTitle: true,
          forceMaterialTransparency: true,
          title: Text(
            data.adress,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppMainScreen(getIndex: 2),
                  ),
                );
              },
              child: _profileAvatar(data.profileImage),
            ),
          ],
        );
      },
    );
  }

  /// Default AppBar (used when user data is not available)
  AppBar _defaultAppBar() {
    return AppBar(
      leading: _appLogo(),
      centerTitle: true,
      forceMaterialTransparency: true,
      title: const Text(
        'Address',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [_profileAvatar(null)],
    );
  }

  /// App logo on the left side of AppBar
  Widget _appLogo() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Image.asset(
        'assets/images/appiconLogo.png',
        height: 10,
        width: 10,
      ),
    );
  }

  /// Profile avatar on right side of AppBar
  Widget _profileAvatar(String? profileImage) {
    if (profileImage == null || profileImage.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(right: 10),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 20,
          child: Icon(Icons.person_outline, size: 30),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 20,
        backgroundImage: NetworkImage(profileImage),
      ),
    );
  }

  /// Categories horizontal list
  Widget _buildCategoriesList() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        height: 60,
        child: FutureBuilder(
          future: futureCategories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CategorisCardShimmer();
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(child: Text('Something went wrong'));
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
                      // Update products when category is changed
                      slectedCategorie = category.name;
                      futureFoodProducts = _productServices.fetchFoodProducts(
                        category.name,
                      );
                      futurePopularProducts = _productServices
                          .fetchPopularProducts(category.name);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: CategoriesCard(
                      isSelected: isSelected,
                      categoryName: category.name,
                      categoryImage: category.image,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Horizontal list of popular products
  Widget _buildPopularProducts() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        height: 280,
        child: FutureBuilder(
          future: futurePopularProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ProductHorizontalCardshimmer();
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            final products = snapshot.data ?? [];
            if (products.isEmpty) return const SizedBox.shrink();

            return ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final product = products[index];
                return _favouriteWrapper(product);
              },
            );
          },
        ),
      ),
    );
  }

  /// Grid of all products (based on selected category)
  Widget _buildAllProducts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
        future: futureFoodProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show shimmer while loading
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6, // placeholder shimmer count
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .6,
              ),
              itemBuilder: (_, __) => ProductGridCardShimmer(),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) return const SizedBox.shrink();

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .6,
            ),
            itemBuilder: (context, index) => _favouriteWrapper(products[index]),
          );
        },
      ),
    );
  }

  /// Wrapper for product card with favourite check
  Widget _favouriteWrapper(ProductModel product) {
    return FutureBuilder<bool>(
      future: checkIsFavourite(product.id),
      builder: (context, favSnapshot) {
        final isFav = favSnapshot.data;
        return ProductCard(
          isFavourite: isFav,
          onTap: () {
            setState(() {
              addToFavourite(product);
            });
          },
          productModel: product,
        );
      },
    );
  }
}

/// ---------------- Reusable Heading Widget ----------------
Widget _heading(
  String title,
  bool? isMoreButton,
  VoidCallback? onTap, {
  bool? isAdmin,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Section title
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        /// "View All" button OR "Add" button for admin
        if (isMoreButton == true)
          isAdmin == true
              ? GestureDetector(
                  onTap: onTap,
                  child: CircleAvatar(
                    backgroundColor: red,
                    radius: 20,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                )
              : Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: orange,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.navigate_next_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
      ],
    ),
  );
}
