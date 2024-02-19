import 'package:flutter/material.dart';

class RouteDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  RouteDetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'ข้อมูลเส้นทาง',
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
                    'image/menu_tracking.png', // เปลี่ยนเส้นทางรูปภาพเพื่อตรงกับรูปภาพของเส้นทาง
                    width: 50,
                    height: 50,
                  ),
                ),
                buildDetailField('รหัสสถานที่', data['place_code']),
                buildDetailField('เวลา', data['time']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailField(String labelText, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$labelText: $value',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
