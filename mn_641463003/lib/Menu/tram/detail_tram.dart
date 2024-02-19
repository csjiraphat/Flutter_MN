import 'package:flutter/material.dart';

class TramDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  TramDetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'ข้อมูลรถราง',
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
                    'image/tram.png', // ตั้งค่ารูปภาพเพื่อตรงกับรถราง
                    width: 50,
                    height: 50,
                  ),
                ),
                buildDetailField('รหัส', data['code']),
                buildDetailField('รหัสรถราง', data['tram_code']),
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
