import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/place/list_place.dart';

class DeletePlacePage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeletePlacePage({required this.data});

  @override
  _DeletePlacePageState createState() => _DeletePlacePageState();
}

class _DeletePlacePageState extends State<DeletePlacePage> {
  late TextEditingController placeCodeController;
  late TextEditingController placeNameController;

  @override
  void initState() {
    super.initState();
    placeCodeController =
        TextEditingController(text: widget.data['place_code'].toString());
    placeNameController =
        TextEditingController(text: widget.data['place_name'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'ลบสถานที่ท่องเที่ยว',
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
                    'image/menu_place.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildReadOnlyField('รหัสสถานที่', placeCodeController),
                buildReadOnlyField('ชื่อสถานที่', placeNameController),
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
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบสถานที่นี้'),
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
    String updatedPlaceCode = placeCodeController.text;

    String apiUrl = 'http://localhost/mn/place/place.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'placeCode': updatedPlaceCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลสถานที่ท่องเที่ยวเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(
            context, "ลบข้อมูลสถานที่ท่องเที่ยวไม่สำเร็จ. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(context, 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $error');
    }
  }

  @override
  void dispose() {
    placeCodeController.dispose();
    placeNameController.dispose();
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
                    builder: (context) => PlaceListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการสถานที่ท่องเที่ยว'),
            ),
          ],
        );
      },
    );
  }
}
