import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/product_model.dart';
import 'package:waseembrayani/service/product_services.dart';
import 'package:waseembrayani/widgets/back_button_widget.dart';
import 'package:waseembrayani/widgets/product_card.dart';
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

  // Future lists for different product queries
  late Future<List<ProductModel>> futureFoodProducts;
  late Future<List<ProductModel>> futurePopularProducts;
  late Future<List<ProductModel>> futureAllProducts;

  @override
  void initState() {
    super.initState();
    _initilizeData(); // initialize product data based on category/popularity
  }

  /// Initialize data for products
  void _initilizeData() {
    futureFoodProducts = _productServices.fetchFoodProducts(
      widget.categoryName.toString(),
    );
    futurePopularProducts = _productServices.fetchPopularProducts(
      widget.categoryName.toString(),
    );
    futureAllProducts = _productServices.fetcAllProducts();
  }

  /// Add product to favourite table in Supabase
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

  /// Check if a product is already in favourites for current user
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
    print('popular status is this ');
    print(widget.isPopular);

    return Scaffold(
      backgroundColor: Colors.white,

      /// AppBar title changes depending on isPopular flag
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

      /// FutureBuilder for product list
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
            return ProductGridCardShimmer();
          }

          // --- Error state ---
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          // --- Empty data state ---
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }

          // --- Success state ---
          final foodProduct = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              itemCount: foodProduct.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns in grid
                childAspectRatio: .6,
              ),
              itemBuilder: (context, index) {
                final product = foodProduct[index];

                // Check if this product is favourite using another FutureBuilder
                return FutureBuilder<bool>(
                  future: checkIsFavourite(product.id),
                  builder: (context, favSnapshot) {
                    final isFav = favSnapshot.data;

                    return ProductCard(
                      productModel: product,
                      isFavourite: isFav, // update UI if favourite

                      onTap: () {
                        // Add/remove favourite on tap
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
