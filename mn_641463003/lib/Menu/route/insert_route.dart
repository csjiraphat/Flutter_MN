import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463003/Menu/route/list_route.dart';

class InsertRoutePage extends StatefulWidget {
  @override
  _InsertRoutePageState createState() => _InsertRoutePageState();
}

class _InsertRoutePageState extends State<InsertRoutePage> {
  late TextEditingController timeController;
  late List<Map<String, dynamic>> placeData = [];
  String? selectedPlaceCode;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    timeController = TextEditingController();
    fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'เพิ่มเส้นทาง',
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
                    'image/menu_tracking.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'สถานที่',
                  ),
                  value: selectedPlaceCode,
                  items: placeData.map((place) {
                    return DropdownMenuItem<String>(
                      value: place['place_code'].toString(),
                      child: Text(place['place_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPlaceCode = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text('เวลา'),
                  subtitle: Text(selectedTime != null
                      ? formatTime(selectedTime!)
                      : 'เลือกเวลา'),
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                        timeController.text = formatTime(selectedTime!);
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedPlaceCode != null && selectedTime != null) {
                      String apiUrl =
                          'http://localhost/mn/route/route.php?case=POST';

                      try {
                        var response = await http.post(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'place_code': selectedPlaceCode,
                            'time': formatTime(selectedTime!),
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลเส้นทางเรียบร้อยแล้ว.",
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลเส้นทางได้. ${response.body}",
                          );
                        }
                      } catch (error) {
                        print('Error: $error');
                      }
                    } else {
                      print('กรุณาเลือกสถานที่และเวลา');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
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

  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
  }

  void fetchPlaces() async {
    String apiUrl = 'http://localhost/mn/place/place.php?case=GET';
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['data'];
        setState(() {
          placeData = responseData.map((item) {
            return {
              'place_code': item['place_code'],
              'place_name': item['place_name']
            };
          }).toList();
        });
      } else {
        print("ไม่สามารถเรียกข้อมูลสถานที่ได้: ${response.statusCode}");
      }
    } catch (error) {
      print('เกิดข้อผิดพลาด: $error');
    }
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
                    builder: (context) => RouteListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการเส้นทาง'),
            ),
          ],
        );
      },
    );
  }
}
