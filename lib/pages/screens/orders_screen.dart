import 'package:flutter/material.dart';
import 'package:waseembrayani/core/models/order_model.dart';

import 'package:waseembrayani/service/orders_services.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService _orderService = OrderService();
  late Future<List<OrderModel>> futureOrders = Future.value([]);
  @override
  void initState() {
    super.initState();
    _intilizeData();
  }

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
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text("Orders", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          }

          // 👇 Now it is safe to print and use snapshot.data
          print('Orders length: ${snapshot.data!.length}');

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data![index].adress;

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
                  child: Row(
                    children: [
                      SizedBox(
                        width: 110,
                        height: 90,
                        child: Image.network(
                          data,
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
                                data,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Text(data),
                            Text(
                              "\$ ${data}",
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
              );
            },
          );
        },
      ),
    );
  }
}
