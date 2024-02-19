import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/product/list_product.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditProductPage({required this.data});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController productCodeController;
  late TextEditingController productNameController;
  late TextEditingController unitController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    productCodeController = TextEditingController(
        text: widget.data['product_code']?.toString() ?? '');
    productNameController = TextEditingController(
        text: widget.data['product_name']?.toString() ?? '');
    unitController = TextEditingController(
        text: widget.data['unit']?.toString() ??
            ''); // Initialize unit controller
    priceController = TextEditingController(
        text: widget.data['price']?.toString() ??
            ''); // Initialize price controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'แก้ไขข้อมูลสินค้า',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      'image/menu_product.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  buildReadOnlyField('รหัสสินค้า', productCodeController),
                  TextFormField(
                    controller: productNameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อสินค้า',
                    ),
                  ),
                  TextFormField(
                    controller: unitController,
                    decoration: InputDecoration(
                      labelText: 'หน่วย',
                    ),
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'ราคา',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedProductCode = productCodeController.text;
                      String updatedProductName = productNameController.text;
                      String updatedUnit =
                          unitController.text; // Get updated unit
                      String updatedPrice =
                          priceController.text; // Get updated price

                      String apiUrl =
                          'http://localhost/mn/product/product.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'product_code': updatedProductCode,
                            'product_name': updatedProductName,
                            'unit': updatedUnit, // Include updated unit
                            'price': updatedPrice, // Include updated price
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลสินค้าเรียบร้อยแล้ว.",
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลสินค้าได้. ${response.body}",
                          );
                        }
                      } catch (error) {
                        print('Error: $error');
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('บันทึกข้อมูล'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReadOnlyField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  @override
  void dispose() {
    productCodeController.dispose();
    productNameController.dispose();
    unitController.dispose(); // Dispose unit controller
    priceController.dispose(); // Dispose price controller
    super.dispose();
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการสินค้า'),
            ),
          ],
        );
      },
    );
  }
}
