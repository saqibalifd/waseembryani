import 'package:flutter/material.dart';
import 'package:waseembrayani/models/order_item_model.dart';
import 'package:waseembrayani/service/orders_services.dart';
import 'package:waseembrayani/utils/consts.dart';
import 'package:waseembrayani/widgets/shimmer/shimmer_tile.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Service to fetch orders from API or database
  final OrderService _orderService = OrderService();

  // Future variable to hold fetched orders list
  late Future<List<OrderItemModel>> futureOrders = Future.value([]);

  @override
  void initState() {
    super.initState();
    _intilizeData(); // fetch orders when screen initializes
  }

  // method to load orders into the futureOrders variable
  void _intilizeData() async {
    try {
      setState(() {
        futureOrders = _orderService.fetchOrders();
      });
    } catch (e) {
      print('error in intilizing data : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 AppBar with title
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text("Orders", style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      // 🔹 FutureBuilder to handle order data loading states
      body: FutureBuilder(
        future: futureOrders,
        builder: (context, snapshot) {
          // 1️⃣ While fetching data → show shimmer loading effect
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerTile();
          }

          // 2️⃣ If there’s an error → show error message
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 3️⃣ If no data found → show empty state message
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          }

          // 4️⃣ If data is available → display in ListView
          print('Orders length: ${snapshot.data!.length}');

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data![index]; // get each order item

              return Padding(
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

                  // 🔹 Order item row layout
                  child: Row(
                    children: [
                      // Order product image
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

                      // Order details (name, price, status)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name
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
                            SizedBox(height: 10),

                            // Price and Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$ ${data.price}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: red,
                                  ),
                                ),
                                Text(
                                  data.status,
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
