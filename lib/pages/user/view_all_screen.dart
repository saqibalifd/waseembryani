import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/models/product_model.dart';
import 'package:waseembrayani/service/product_services.dart';
import 'package:waseembrayani/utils/product_card.dart';
import 'package:waseembrayani/widgets/shimmer/product_grid_card_shimmer.dart';

/// ViewAllScreen
/// Displays a grid of products based on:
/// - Popular products
/// - Category-specific products
/// - All products
/// Supports adding to favourites using Supabase.

class ViewAllScreen extends StatefulWidget {
  final bool? isPopular; // If true → show only popular products
  final String? categoryName; // If provided → show products of this category

  const ViewAllScreen({super.key, this.isPopular, this.categoryName});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  final ProductServices _productServices = ProductServices();

  // Step 1: Define Future variables for different queries
  // - Popular products
  // - Category products
  // - All products
  late Future<List<ProductModel>> futureFoodProducts;
  late Future<List<ProductModel>> futurePopularProducts;
  late Future<List<ProductModel>> futureAllProducts;

  @override
  void initState() {
    super.initState();
    _initilizeData(); // Step 2: Initialize product data depending on widget flags
  }

  /// Step 2a: Initialize data for products
  /// - If categoryName provided → fetch food products
  /// - Always load popular + all products as fallback
  void _initilizeData() {
    futureFoodProducts = _productServices.fetchFoodProducts(
      widget.categoryName.toString(),
    );
    futurePopularProducts = _productServices.fetchPopularProducts(
      widget.categoryName.toString(),
    );
    futureAllProducts = _productServices.fetcAllProducts();
  }

  /// Step 3: Add product to Supabase "favourite" table
  /// - Show loading indicator with EasyLoading
  /// - Insert product as JSON
  /// - Handle errors gracefully
  Future addToFavourite(ProductModel productModel) async {
    try {
      EasyLoading.show(status: 'loading...');

      await Supabase.instance.client
          .from('favourite')
          .insert(productModel.toJson()); // insert product as favourite

      EasyLoading.dismiss();
      print('add to favourite success');
    } catch (e) {
      print('Error in Adding to favourite products : $e');
      EasyLoading.dismiss();
      return [];
    }
  }

  /// Step 4: Check if a product is already favourite
  /// - Match by current userId and product id
  /// - Return true/false
  Future<bool> checkIsFavourite(int productId) async {
    try {
      final String userId = Supabase.instance.client.auth.currentUser!.id;

      final response = await Supabase.instance.client
          .from('favourite')
          .select()
          .eq('favUserId', userId) // filter by current logged in user
          .eq('id', productId) // check product id
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking favourite: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug logs to check status
    print('popular status is this ');
    print(widget.isPopular);

    return Scaffold(
      backgroundColor: Colors.white,

      /// Step 5: AppBar setup
      /// - Title text depends on isPopular flag
      /// - Transparent look, light blue background
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[50],

        title: Text(
          widget.isPopular == true ? 'Popular Products' : 'All Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      /// Step 6: FutureBuilder to load products dynamically
      /// - Handles 4 states: loading, error, empty, success
      body: FutureBuilder<List<ProductModel>>(
        // Decide which products to show:
        future: widget.isPopular == true
            ? futurePopularProducts // popular products
            : widget.isPopular == false
            ? futureFoodProducts // category products
            : futureAllProducts, // all products
        builder: (context, snapshot) {
          // --- Loading state ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ProductGridCardShimmer(); // shimmer effect while loading
          }

          // --- Error state ---
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          // --- Empty data state ---
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink(); // return empty widget
          }

          // --- Success state ---
          final foodProduct = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),

            /// Step 7: GridView.builder
            /// - Displays list of products in 2-column grid
            /// - Each item wrapped in a FutureBuilder to check favourite status
            child: GridView.builder(
              itemCount: foodProduct.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns in grid
                childAspectRatio: .6, // aspect ratio for card size
              ),
              itemBuilder: (context, index) {
                final product = foodProduct[index];

                // Step 8: Wrap product card in FutureBuilder
                // - Fetch favourite status asynchronously
                return FutureBuilder<bool>(
                  future: checkIsFavourite(product.id),
                  builder: (context, favSnapshot) {
                    final isFav = favSnapshot.data;

                    // Step 9: ProductCard widget
                    // - Displays product details
                    // - Shows heart icon depending on isFav
                    // - OnTap → toggle favourite
                    return ProductCard(
                      productModel: product,
                      isFavourite: isFav, // update UI if favourite

                      onTap: () {
                        // Step 10: Handle add/remove favourite
                        // - Create ProductModel object
                        // - Call addToFavourite
                        ProductModel productModel = ProductModel(
                          id: product.id,
                          name: product.name,
                          description: product.description,
                          price: product.price,
                          imageUrl: product.imageUrl,
                          categoryName: product.categoryName,
                        );
                        setState(() {
                          addToFavourite(productModel);
                        });
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// ----------------------------
/// Step-by-step implementation:
/// 1. Setup ProductServices to fetch all/popular/category products.
/// 2. Initialize Future variables in initState → call _initilizeData.
/// 3. Create addToFavourite → handles Supabase insert with EasyLoading.
/// 4. Create checkIsFavourite → checks if product exists in 'favourite' table.
/// 5. Build UI with AppBar title changing based on isPopular flag.
/// 6. Use FutureBuilder to load and handle states (loading, error, empty, success).
/// 7. Show products in GridView with 2 columns.
/// 8. Wrap each ProductCard with FutureBuilder<bool> for favourite check.
/// 9. Pass isFavourite flag into ProductCard for UI update.
/// 10. Handle onTap → call addToFavourite and update UI with setState.
