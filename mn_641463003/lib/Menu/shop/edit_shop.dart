import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/shop/list_shop.dart'; // แก้ไข import นี้

class EditShopPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditShopPage({required this.data});

  @override
  _EditShopPageState createState() => _EditShopPageState();
}

class _EditShopPageState extends State<EditShopPage> {
  late TextEditingController codeShopController;
  late TextEditingController nameShopController;

  @override
  void initState() {
    super.initState();
    codeShopController =
        TextEditingController(text: widget.data['shop_code'].toString());
    nameShopController =
        TextEditingController(text: widget.data['shop_name'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'แก้ไขร้านค้า',
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
                      'image/shop.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  buildReadOnlyField('รหัสร้านค้า', codeShopController),
                  TextFormField(
                    controller: nameShopController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อร้านค้า',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedCodeShop = codeShopController.text;
                      String updatedNameShop = nameShopController.text;

                      String apiUrl =
                          'http://localhost/mn/shop/shop.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'shop_code': updatedCodeShop,
                            'shop_name': updatedNameShop,
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
                        Image.asset('image/edit.png', width: 20, height: 20),
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
      readOnly: true, // Set to true to disable user input
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  @override
  void dispose() {
    codeShopController.dispose();
    nameShopController.dispose();
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
