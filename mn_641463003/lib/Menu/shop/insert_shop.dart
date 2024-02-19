import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/shop/list_shop.dart'; // แก้ไข import นี้

class InsertShopPage extends StatefulWidget {
  @override
  _InsertShopPageState createState() => _InsertShopPageState();
}

class _InsertShopPageState extends State<InsertShopPage> {
  late TextEditingController shopNameController;
  late TextEditingController shopCodeController;

  @override
  void initState() {
    super.initState();
    shopNameController = TextEditingController();
    shopCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'เพิ่มร้านค้า',
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
                    'image/shop.png', // แก้ไขรูปภาพนี้
                    width: 50,
                    height: 50,
                  ),
                ),
                buildTextField('ชื่อร้านค้า', shopNameController),
                buildTextField('รหัสร้านค้า', shopCodeController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String shopName = shopNameController.text;
                    String shopCode = shopCodeController.text;

                    String apiUrl =
                        'http://localhost/mn/shop/shop.php?case=POST'; // แก้ URL นี้

                    try {
                      var response = await http.post(
                        Uri.parse(apiUrl),
                        body: json.encode({
                          'shop_name': shopName,
                          'shop_code': shopCode, // แก้ชื่อฟิลด์ตรงนี้
                        }),
                        headers: {'Content-Type': 'application/json'},
                      );

                      if (response.statusCode == 200) {
                        showSuccessDialog(
                          context,
                          "บันทึกข้อมูลร้านค้าเรียบร้อยแล้ว.",
                        );
                      } else {
                        showErrorDialog(
                          context,
                          "ไม่สามารถบันทึกข้อมูลร้านค้าได้. ${response.body}",
                        );
                      }
                    } catch (error) {
                      print('Error: $error');
                      showErrorDialog(
                        context,
                        "เกิดข้อผิดพลาดในการเชื่อมต่อ: $error",
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('image/insert.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('เพิ่มข้อมูล'),
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

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  @override
  void dispose() {
    shopNameController.dispose();
    shopCodeController.dispose();
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
                    builder: (context) => ShopListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการร้านค้า'),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เกิดข้อผิดพลาด'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }
}
