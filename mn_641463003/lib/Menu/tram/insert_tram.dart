import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/tram/list_tram.dart';

class InsertTramPage extends StatefulWidget {
  @override
  _InsertTramPageState createState() => _InsertTramPageState();
}

class _InsertTramPageState extends State<InsertTramPage> {
  late TextEditingController codeController;
  late TextEditingController tramCodeController;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    tramCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'เพิ่มข้อมูลรถราง',
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
                    'image/tram.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildTextField('รหัส', codeController),
                buildTextField('รหัสรถราง', tramCodeController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String code = codeController.text;
                    String tramCode = tramCodeController.text;

                    String apiUrl =
                        'http://localhost/mn/tram/tram.php?case=POST';

                    try {
                      var response = await http.post(
                        Uri.parse(apiUrl),
                        body: json.encode({
                          'code': code,
                          'tram_code': tramCode,
                        }),
                        headers: {'Content-Type': 'application/json'},
                      );

                      if (response.statusCode == 200) {
                        showSuccessDialog(
                          context,
                          "บันทึกข้อมูลรถรางเรียบร้อยแล้ว.",
                        );
                      } else {
                        showSuccessDialog(
                          context,
                          "ไม่สามารถบันทึกข้อมูลรถรางได้. ${response.body}",
                        );
                      }
                    } catch (error) {
                      print('Error: $error');
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
                // รีเฟรชหน้า List
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
