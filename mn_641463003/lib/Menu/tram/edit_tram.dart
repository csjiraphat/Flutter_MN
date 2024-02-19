import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/tram/list_tram.dart';

class EditTramPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditTramPage({required this.data});

  @override
  _EditTramPageState createState() => _EditTramPageState();
}

class _EditTramPageState extends State<EditTramPage> {
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
          'แก้ไขข้อมูลรถราง',
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
                      'image/tram.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  buildReadOnlyField('รหัส', codeController),
                  TextFormField(
                    controller: tramCodeController,
                    decoration: InputDecoration(
                      labelText: 'รหัสรถราง',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedCode = codeController.text;
                      String updatedTramCode = tramCodeController.text;

                      String apiUrl =
                          'http://localhost/mn/tram/tram.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'code': updatedCode,
                            'tram_code': updatedTramCode,
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
