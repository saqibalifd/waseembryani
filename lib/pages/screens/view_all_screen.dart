import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waseembrayani/core/models/product_model.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/widgets/product_card.dart';

class ViewAllScreen extends StatefulWidget {
  final bool? isPopular;
  final String? categoryName;
  const ViewAllScreen({super.key, this.isPopular, this.categoryName});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  late Future<List<ProductModel>> futureFoodProducts;
  late Future<List<ProductModel>> futurePopularProducts;
  late Future<List<ProductModel>> futureAllProducts;

  @override
  void initState() {
    super.initState();
    futureFoodProducts = fetchFoodProducts();
    futurePopularProducts = fetchPopularProducts();
    futureAllProducts = fetcAllProducts();
  }

  Future<List<ProductModel>> fetchFoodProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('categoryName', widget.categoryName!);
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
          .eq('categoryName', widget.categoryName!);
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error in fetching popular products : $e');
      return [];
    }
  }

  Future<List<ProductModel>> fetcAllProducts() async {
    try {
      final response = await Supabase.instance.client.from('products').select();
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error in fetching popular products : $e');
      return [];
    }
  }

  Future addToFavourite(ProductModel productModel) async {
    try {
      EasyLoading.show(status: 'loading...');

      await Supabase.instance.client
          .from('favourite')
          .insert(productModel.toJson());
      //add to favourite
      EasyLoading.dismiss();
      print('add to favourite success');
    } catch (e) {
      print('Error in Adding to favourite products : $e');
      EasyLoading.dismiss();
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print('papular status is this ');
    print(widget.isPopular);
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
            : widget.isPopular == false
            ? futureFoodProducts
            : futureAllProducts,
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
                  onTap: () {
                    ProductModel productModel = ProductModel(
                      id: product.id,
                      name: product.name,
                      description: product.description,
                      price: product.price,
                      imageUrl: product.imageUrl,
                      categoryName: product.categoryName,
                    );
                    addToFavourite(productModel);
                  },
                  productModel: product,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
