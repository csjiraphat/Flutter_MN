import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/shop/list_shop.dart';

class DeleteShopPage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteShopPage({required this.data});

  @override
  _DeleteShopPageState createState() => _DeleteShopPageState();
}

class _DeleteShopPageState extends State<DeleteShopPage> {
  late TextEditingController shopCodeController;
  late TextEditingController shopNameController;

  @override
  void initState() {
    super.initState();
    shopCodeController =
        TextEditingController(text: widget.data['shop_code'].toString());
    shopNameController =
        TextEditingController(text: widget.data['shop_name'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'ลบร้านค้า',
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
                    'image/shop.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildReadOnlyField('รหัสร้านค้า', shopCodeController),
                buildReadOnlyField('ชื่อร้านค้า', shopNameController),
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
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบร้านค้านี้'),
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
                await deletePlace();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deletePlace() async {
    String updatedShopCode = shopCodeController.text;

    String apiUrl = 'http://localhost/mn/place/shop.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'shop_code': updatedShopCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลร้านค้าเรียบร้อยแล้ว");
      } else {
        showErrorDialog(context, "ลบข้อมูลร้านค้าไม่สำเร็จ. ${response.body}");
      }
    } catch (error) {
      showErrorDialog(context, 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $error');
    }
  }

  @override
  void dispose() {
    shopCodeController.dispose();
    shopNameController.dispose();
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
