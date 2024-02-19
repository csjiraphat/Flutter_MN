import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  ProductDetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'ข้อมูลสินค้า',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.asset(
                    'image/menu_product.png', // Set image path to match the product image
                    width: 50,
                    height: 50,
                  ),
                ),
                buildDetailField('รหัสร้านค้า', data['shop_code']),
                buildDetailField('รหัสสินค้า', data['product_code']),
                buildDetailField('ชื่อสินค้า', data['product_name']),
                buildDetailField('หน่วย', data['unit']),
                buildDetailField('ราคา', data['price']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailField(String labelText, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$labelText: $value',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
