import 'package:flutter/material.dart';

import 'package:waseembrayani/core/utils/consts.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text("Favorites", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body:
          // FutureBuilder(
          //   future: futureFavProducts,
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(child: CircularProgressIndicator());
          //     }
          //     if (snapshot.hasError ||
          //         !snapshot.hasData ||
          //         snapshot.data!.isEmpty) {
          //       return Center(child: Text('Some thing went wrong'));
          //     }
          //     return
          ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              // final data = snapshot.data![index];

              // final data = snapshot.data![index];
              return InkWell(
                onTap: () {
                  // final ProductModel productModel = ProductModel(
                  //   id: data.id,
                  //   name: data.name,
                  //   description: data.description,
                  //   price: data.price,
                  //   imageUrl: data.imageUrl,
                  //   categoryName: data.categoryName,
                  // );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         DetailScreen(productModel: productModel),
                  //   ),
                  // );
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
                                'https://static.vecteezy.com/system/resources/previews/025/250/367/non_2x/crunchy-and-delicious-fried-potato-chips-clipart-cartoon-illustration-of-tasty-fast-food-snack-generative-ai-png.png',
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
                                      'Chips big pack',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Text('chips'),
                                  Text(
                                    "\$ ${'2'}",
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
                        child: Icon(Icons.delete, color: red, size: 25),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      //   },
      // ),
    );
  }
}
