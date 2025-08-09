import 'package:flutter/material.dart';
import 'package:waseembrayani/core/utils/consts.dart';
import 'package:waseembrayani/widgets/cart_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text(
          "Cart Screen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return CartTile(
                  imageUrl:
                      'https://png.pngtree.com/png-clipart/20241129/original/pngtree-delicious-meat-burger-image-png-image_17410912.png',
                  productName: 'Burger',
                  price: '40',
                  quantity: '2',
                  onMinusTap: () {},
                  onPlusTap: () {},
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
            child: paymentDetail('300'),
          ),
        ],
      ),
    );
  }
}

Widget paymentDetail(
  String total, {
  String shippingCharges = '0',
  String discount = '0',
}) {
  return SizedBox(
    height: 160,
    width: double.maxFinite,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '\$$total',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipping Charge',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '\$$shippingCharges ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '\$$discount ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Grand Total',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: red,
              ),
            ),
            Text(
              '\$$total',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: red,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
