import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/product/list_product.dart';

class DeleteProductPage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteProductPage({required this.data});

  @override
  _DeleteProductPageState createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  late TextEditingController productCodeController;
  late TextEditingController productNameController;

  @override
  void initState() {
    super.initState();
    productCodeController =
        TextEditingController(text: widget.data['product_code'].toString());
    productNameController =
        TextEditingController(text: widget.data['product_name'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'ลบสินค้า',
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.asset(
                    'image/product.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildReadOnlyField('รหัสสินค้า', productCodeController),
                buildReadOnlyField('ชื่อสินค้า', productNameController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showConfirmationDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('image/delete1.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('ลบข้อมูล'),
                    ],
                  ),
                ),
              ],
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

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteProduct();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteProduct() async {
    String updatedProductCode = productCodeController.text;

    String apiUrl = 'http://localhost/mn/product/product.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'product_code': updatedProductCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลสินค้าเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(context, "ลบข้อมูลสินค้าไม่สำเร็จ. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(
          context, 'เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $error');
    }
  }

  @override
  void dispose() {
    productCodeController.dispose();
    productNameController.dispose();
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
