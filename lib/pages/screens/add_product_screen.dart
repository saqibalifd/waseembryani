import 'package:flutter/material.dart';
import 'package:waseembrayani/core/utils/consts.dart';

class AddProductScreen extends StatefulWidget {
  final bool? isCategory;
  final bool? isUpdate;
  const AddProductScreen({super.key, this.isCategory, this.isUpdate});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text(
          widget.isCategory == true ? "Add Category" : "Add Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  'Add product picture',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all(color: red)),
                  child: Icon(Icons.add_a_photo, size: 80),
                ),
                SizedBox(height: 10),

                Text(
                  'Slect product category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all(color: red)),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Text(
                    'Is Papular',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: Switch(value: false, onChanged: (value) {}),
                ),

                ListTile(
                  leading: Text(
                    'Is Recomended',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: Switch(value: false, onChanged: (value) {}),
                ),
                Divider(color: red),
                SizedBox(height: 10),
                Text(
                  'Product details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Product Detail',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 130),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 33),
        child: MaterialButton(
          onPressed: () {
            // Handle add to cart
          },
          color: red,
          height: 60,
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            widget.isUpdate == true ? 'Update Product' : 'Add Product',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
