import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/models/categories_model.dart';
import 'package:waseembrayani/models/product_model.dart';
import 'package:waseembrayani/models/user_model.dart';
import 'package:waseembrayani/pages/user/app_main_screen.dart';
import 'package:waseembrayani/pages/user/view_all_screen.dart';
import 'package:waseembrayani/service/auth_service.dart';
import 'package:waseembrayani/service/categories_services.dart';
import 'package:waseembrayani/service/product_services.dart';
import 'package:waseembrayani/service/user_services.dart';
import 'package:waseembrayani/utils/consts.dart';
import 'package:waseembrayani/utils/product_card.dart';
import 'package:waseembrayani/widgets/banner_card.dart';
import 'package:waseembrayani/widgets/categories_card.dart';
import 'package:waseembrayani/widgets/shimmer/categoris_card_shimmer.dart';
import 'package:waseembrayani/widgets/shimmer/product_grid_card_shimmer.dart';
import 'package:waseembrayani/widgets/shimmer/product_horizontal_cardShimmer.dart';

/// Home Screen of the app.
/// Displays:
/// - Banner
/// - Categories
/// - Popular products
/// - All products
/// Supports favourites and navigation to ViewAllScreen.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// --- Step 1: Setup Services for API calls ---
  final CategoriesServices _categoriesServices = CategoriesServices();
  final ProductServices _productServices = ProductServices();
  final UserServices _userServices = UserServices();

  /// --- Step 2: Setup Future variables to fetch data ---
  /// These will be used with FutureBuilder
  late Future<List<CategoryModel>> futureCategories = _categoriesServices
      .fetchCategories();
  late Future<List<ProductModel>> futureFoodProducts = Future.value([]);
  late Future<List<ProductModel>> futurePopularProducts = Future.value([]);
  late Future<List<UserModel>> futureUserInfo = Future.value([]);

  /// --- Step 3: State variables ---
  List<CategoryModel> categories = []; // store categories
  String? slectedCategorie; // currently selected category
  final bool? isAdmin = false; // admin flag (used for heading button)
  final String userId = Supabase.instance.client.auth.currentUser!.id
      .toString(); // current logged in user id

  @override
  void initState() {
    super.initState();
    _intilizeData(); // Step 4: Initialize data
  }

  /// Step 4a: Initialize categories, products, and user info
  /// - Fetch categories
  /// - Select the first category by default
  /// - Fetch products based on that category
  void _intilizeData() async {
    try {
      final categories = await futureCategories;
      if (categories.isNotEmpty) {
        setState(() {
          this.categories = categories;
          slectedCategorie = categories.first.name;

          // Fetch products for default category
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

  /// Step 5: Add product to favourite table in Supabase
  /// - Shows EasyLoading spinner
  /// - Inserts product JSON in "favourite"
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

  /// Step 6: Check if product already exists in favourites
  /// - Uses currentUser id + product id
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

  /// AuthService instance for logout or auth checks if needed
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// Step 7: Custom AppBar
      /// - Shows user address and profile if logged in
      /// - Otherwise shows default app bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _buildAppBar(),
      ),

      /// Step 8: Scrollable body with multiple sections
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            /// Banner section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BannerCard(
                firstText: 'The Fastest In Delivery',
                secondText: ' Food',
                button: _orderNowButton(), // CTA → ViewAllScreen
                image: Image.asset(
                  'assets/images/3drider.webp',
                  height: 110,
                  width: 110,
                ),
              ),
            ),

            /// Categories section
            _heading('Categories', false, () {}, isAdmin: isAdmin),
            _buildCategoriesList(),

            /// Popular products section
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

            /// All products section
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

  /// Step 9: "Order Now" button inside banner
  /// - Navigates to ViewAllScreen with all products
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

  /// Step 10: Build AppBar dynamically with FutureBuilder
  /// - Shows user data if available
  Widget _buildAppBar() {
    return FutureBuilder(
      future: futureUserInfo,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final hasError =
            snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty;

        if (isLoading || hasError) {
          return _defaultAppBar(); // fallback
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
                // Navigate to profile tab in AppMainScreen
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

  /// Step 11: Default AppBar when user data is unavailable
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

  /// Step 12: Logo widget for AppBar
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

  /// Step 13: Profile avatar widget (with placeholder if no image)
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

  /// Step 14: Horizontal list of categories
  /// - Updates food + popular products on selection
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
                      // Step 14a: update products when category changes
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

  /// Step 15: Horizontal list of popular products
  /// - Wraps product card with favourite check
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

  /// Step 16: Grid of all products for selected category
  /// - Uses shimmer while loading
  Widget _buildAllProducts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
        future: futureFoodProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Shimmer for loading
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6, // shimmer placeholder
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

  /// Step 17: Wrapper to check favourite status for a product
  /// - Uses FutureBuilder<bool>
  /// - Passes `isFavourite` into ProductCard
  Widget _favouriteWrapper(ProductModel product) {
    return FutureBuilder<bool>(
      future: checkIsFavourite(product.id),
      builder: (context, favSnapshot) {
        final isFav = favSnapshot.data;
        return ProductCard(
          isFavourite: isFav,
          onTap: () {
            setState(() {
              addToFavourite(product); // add product to favourites
            });
          },
          productModel: product,
        );
      },
    );
  }
}

/// ---------------- Reusable Heading Widget ----------------
/// Step 18: Used in sections (Categories, Popular, All products)
/// - Shows title
/// - If isAdmin → shows add button
/// - Otherwise shows "View All"
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

        /// Right-side button
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

/// ---------------- Final Checklist ----------------
/// 1. Setup services and Future variables.
/// 2. Initialize categories, products, user info in initState.
/// 3. Build custom AppBar (dynamic with user info).
/// 4. Add banner section with CTA button.
/// 5. Show categories with horizontal scroll and selection.
/// 6. Show popular products horizontally with favourite check.
/// 7. Show all products grid with favourite check.
/// 8. Wrap ProductCard with _favouriteWrapper for add-to-fav feature.
/// 9. Reusable _heading widget for sections.
/// 10. Future improvement: Add removeFromFavourite to toggle instead of only add.
