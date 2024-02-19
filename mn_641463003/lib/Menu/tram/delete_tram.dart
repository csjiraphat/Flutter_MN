import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/tram/list_tram.dart';

class DeleteTramPage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteTramPage({required this.data});

  @override
  _DeleteTramPageState createState() => _DeleteTramPageState();
}

class _DeleteTramPageState extends State<DeleteTramPage> {
  late TextEditingController codeController;
  late TextEditingController tramCodeController;

  @override
  void initState() {
    super.initState();
    codeController =
        TextEditingController(text: widget.data['code'].toString());
    tramCodeController =
        TextEditingController(text: widget.data['tram_code'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'ลบข้อมูลรถราง',
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
                    'image/tram.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildReadOnlyField('รหัส', codeController),
                buildReadOnlyField('รหัสรถราง', tramCodeController),
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
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลรถรางนี้'),
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
                await deleteTram();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteTram() async {
    String updatedCode = codeController.text;

    String apiUrl = 'http://localhost/mn/tram/tram.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'code': updatedCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลรถรางเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(context, "ลบข้อมูลรถรางไม่สำเร็จ. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(context, 'Error connecting to the server: $error');
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    tramCodeController.dispose();
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
                    builder: (context) => TramListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการรถราง'),
            ),
          ],
        );
      },
    );
  }
}
