import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463003/Menu/place/list_place.dart';

class InsertPlacePage extends StatefulWidget {
  @override
  _InsertPlacePageState createState() => _InsertPlacePageState();
}

class _InsertPlacePageState extends State<InsertPlacePage> {
  late TextEditingController placeNameController;
  late TextEditingController latitudeController;
  late TextEditingController longtitudeController;

  @override
  void initState() {
    super.initState();
    placeNameController = TextEditingController();
    latitudeController = TextEditingController();
    longtitudeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'เพิ่มสถานที่ท่องเที่ยว',
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
                    'image/menu_place.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildTextField('ชื่อสถานที่', placeNameController),
                buildTextField('ละติจูด', latitudeController),
                buildTextField('ลองติจูด', longtitudeController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String placeName = placeNameController.text;
                    String latitude = latitudeController.text;
                    String longtitude = longtitudeController.text;

                    String apiUrl =
                        'http://localhost/mn/place/place.php?case=POST';

                    try {
                      var response = await http.post(
                        Uri.parse(apiUrl),
                        body: json.encode({
                          'place_name': placeName,
                          'latitude': latitude,
                          'longtitude': longtitude,
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
    placeNameController.dispose();
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
