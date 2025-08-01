import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/product_model.dart';
import 'package:waseembrayani/pages/screens/detail_screen.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/widgets/product_card.dart';

class ViewAllScreen extends StatefulWidget {
  final bool? isPopular;
  final String categoryName;
  const ViewAllScreen({super.key, this.isPopular, required this.categoryName});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  late Future<List<ProductModel>> futureFoodProducts;
  late Future<List<ProductModel>> futurePopularProducts;

  @override
  void initState() {
    super.initState();
    futureFoodProducts = fetchFoodProducts();
    futurePopularProducts = fetchPopularProducts();
  }

  Future<List<ProductModel>> fetchFoodProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('categoryName', widget.categoryName);
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error in fetching products : $e');
      return [];
    }
  }

  Future<List<ProductModel>> fetchPopularProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('isPopular', true)
          .eq('categoryName', widget.categoryName);
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error in fetching popular products : $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          widget.isPopular == true ? 'Popular Products' : 'All Products',
        ),
        backgroundColor: Colors.blue[50],
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: widget.isPopular == true
            ? futurePopularProducts
            : futureFoodProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: red));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('This item is currently not available'));
          }

          final foodProduct = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              itemCount: foodProduct.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .6,
              ),
              itemBuilder: (context, index) {
                final product = foodProduct[index];
                return ProductCard(
                  onCardTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(productModel: product),
                    ),
                  ),
                  image: Image.network(
                    product.imageUrl,
                    height: 160,
                    errorBuilder: (context, error, stackTrace) => Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Icon(Icons.food_bank, size: 80),
                    ),
                  ),
                  title: product.name,
                  subtitle: product.categoryName,
                  price: product.price.toString(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
