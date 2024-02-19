import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/place/list_place.dart';

class EditPlacePage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditPlacePage({required this.data});

  @override
  _EditPlacePageState createState() => _EditPlacePageState();
}

class _EditPlacePageState extends State<EditPlacePage> {
  late TextEditingController codePlaceController;
  late TextEditingController namePlaceController;
  late TextEditingController latitudeController;
  late TextEditingController longtitudeController;

  @override
  void initState() {
    super.initState();
    codePlaceController =
        TextEditingController(text: widget.data['place_code'].toString());
    namePlaceController =
        TextEditingController(text: widget.data['place_name'].toString());
    latitudeController =
        TextEditingController(text: widget.data['latitude'].toString());
    longtitudeController =
        TextEditingController(text: widget.data['longtitude'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'แก้ไขสถานที่ท่องเที่ยว',
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
                      'image/menu_place.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  buildReadOnlyField('รหัสสถานที่', codePlaceController),
                  TextFormField(
                    controller: namePlaceController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อสถานที่',
                    ),
                  ),
                  TextFormField(
                    controller: latitudeController,
                    decoration: InputDecoration(
                      labelText: 'ละติจูด',
                    ),
                  ),
                  TextFormField(
                    controller: longtitudeController,
                    decoration: InputDecoration(
                      labelText: 'ลองติจูด',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedCodePlace = codePlaceController.text;
                      String updatedNamePlace = namePlaceController.text;
                      String updatedLatitude = latitudeController.text;
                      String updatedlongtitude = longtitudeController.text;

                      String apiUrl =
                          'http://localhost/mn/place/place.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'place_code': updatedCodePlace,
                            'place_name': updatedNamePlace,
                            'latitude': updatedLatitude,
                            'longtitude': updatedlongtitude,
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลสถานที่ท่องเที่ยวเรียบร้อยแล้ว.",
                          );
                        } else {
                          showErrorDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลสถานที่ท่องเที่ยวได้. ${response.body}",
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
    codePlaceController.dispose();
    namePlaceController.dispose();
    latitudeController.dispose();
    longtitudeController.dispose();
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
