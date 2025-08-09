import 'package:flutter/material.dart';
import 'package:waseembrayani/core/utils/consts.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text("Favorites", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          // final ProductModel items = favouriteItems[index];
          return Stack(
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
                      Container(
                        width: 110,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://www.borenos.com/wp-content/uploads/2025/04/Double-Signature-Burger.png',
                            ),
                            fit: BoxFit.cover,
                          ),
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
                                'Saqib',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Text('burger'),
                            Text(
                              "\$ ${40}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.pink,
                              ),
                            ),
                            /////wemrlqwjfqwihfiqwhfkoqfkjqiofqwui
                            ///rjw
                            // rjqek,
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
                  child: Icon(Icons.delete, color: red, size: 25),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:waseembrayani/core/models/product_model.dart';
// import 'package:waseembrayani/core/utils/consts.dart';

// final supabase = Supabase.instance.client;

// class FavouriteScreen extends StatefulWidget {
//   const FavouriteScreen({super.key});

//   @override
//   State<FavouriteScreen> createState() => _FavouriteScreenState();
// }

// class _FavouriteScreenState extends State<FavouriteScreen> {
//   final userId = supabase.auth.currentUser?.id;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       body: userId == null
//           ? Center(child: Text("please loging to view favourites"))
//           : StreamBuilder<List<Map<String, dynamic>>>(
//               stream: supabase
//                   .from("favourites")
//                   .stream(primaryKey: ['id'])
//                   .eq('user_id', userId!)
//                   .map((data) => data.cast<Map<String, dynamic>>()),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 final favourites = snapshot.data!;
//                 if (favourites.isEmpty) {
//                   return Center(child: Text('No favourites yet'));
//                 }
//                 return FutureBuilder(
//                   future: _fetchFavouriteItems(favourites),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     final favouriteItems = snapshot.data!;
//                     if (favouriteItems.isEmpty) {
//                       return Center(child: Text('No favourites yet'));
//                     }
//                     return ListView.builder(
//                       itemCount: favouriteItems.length,
//                       itemBuilder: (context, index) {
//                         final ProductModel items = favouriteItems[index];
//                         return Stack(
//                           children: [
//                             Padding(
//                               padding: EdgeInsetsGeometry.symmetric(
//                                 horizontal: 15,
//                                 vertical: 5,
//                               ),
//                               child: Container(
//                                 padding: EdgeInsets.all(10),
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 110,
//                                       height: 90,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                         image: DecorationImage(
//                                           image: NetworkImage(items.imageUrl),
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsetsGeometry.only(
//                                               right: 20,
//                                             ),
//                                             child: Text(
//                                               items.name,
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 17,
//                                               ),
//                                             ),
//                                           ),
//                                           Text(items.categoryName),
//                                           Text(
//                                             "\$ ${items.price.toString()}",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.pink,
//                                             ),
//                                           ),
//                                           /////wemrlqwjfqwihfiqwhfkoqfkjqiofqwui
//                                           ///rjw
//                                           // rjqek,
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             Positioned(
//                               child: GestureDetector(
//                                 child: Icon(Icons.delete, color: red, size: 25),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }

//   Future<List<ProductModel>> _fetchFavouriteItems(
//     List<Map<String, dynamic>> favorites,
//   ) async {
//     final List<String> productName = favorites
//         .map((fav) => fav['product_id'].toString())
//         .toList();
//     if (productName.isEmpty) return [];
//     try {
//       final response = await supabase
//           .from("food_product")
//           .select()
//           .inFilter('name', productName);

//       if (response.isEmpty) {
//         return [];
//       }
//       return response.map((data) => ProductModel.fromJson(data)).toList();
//     } catch (e) {
//       print('error found in the fetchfavourite items $e');
//     }
//     return [];
//   }
// }
