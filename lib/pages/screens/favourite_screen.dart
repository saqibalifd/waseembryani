import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:waseembrayani/core/models/favourite_product_model.dart';
import 'package:waseembrayani/core/models/product_model.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/pages/screens/detail_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late Future<List<FavouriteProductModel>> futureFavProducts = Future.value([]);
  @override
  void initState() {
    super.initState();
    _intilizeData();
  }

  void _intilizeData() async {
    try {
      setState(() {
        futureFavProducts = fetchFavouriteProduct();
      });
    } catch (e) {
      print('error in intilizing data : $e');
    }
  }

  Future<List<FavouriteProductModel>> fetchFavouriteProduct() async {
    try {
      final String userId = Supabase.instance.client.auth.currentUser!.id
          .toString();
      final response = await Supabase.instance.client
          .from('favourite')
          .select()
          .eq('favUserId', userId);
      return (response as List)
          .map((json) => FavouriteProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error in fetching products : $e');
      return [];
    }
  }

  Future deleteFavourite() async {
    try {
      print('delete favourite tap');
    } catch (e) {
      print('Error in fetching products : $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,

        title: Text("Favorites", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder(
        future: futureFavProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(child: Text('Some thing went wrong'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data![index];

              // final data = snapshot.data![index];
              return InkWell(
                onTap: () {
                  final ProductModel productModel = ProductModel(
                    id: data.id,
                    name: data.name,
                    description: data.description,
                    price: data.price,
                    imageUrl: data.imageUrl,
                    categoryName: data.categoryName,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(productModel: productModel),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 110,
                              height: 90,
                              child: Image.network(
                                data.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.fastfood, size: 40);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(right: 20),
                                    child: Text(
                                      data.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Text(data.categoryName),
                                  Text(
                                    "\$ ${data.price}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      right: 10,
                      top: 10,
                      child: GestureDetector(
                        onTap: deleteFavourite,
                        child: Icon(Icons.delete, color: red, size: 25),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
