import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mn_641463003/Menu/route/insert_route.dart';
import 'package:mn_641463003/Menu/route/edit_route.dart';
import 'package:mn_641463003/Menu/route/delete_route.dart';
import 'package:mn_641463003/Menu/route/detail_route.dart';

class RouteListPage extends StatefulWidget {
  @override
  _RouteListPageState createState() => _RouteListPageState();
}

class _RouteListPageState extends State<RouteListPage> {
  bool isHovered = false;
  late Future<List<Map<String, dynamic>>> _routeData;

  Future<List<Map<String, dynamic>>> _fetchRouteData() async {
    final response = await http
        .get(Uri.parse('http://localhost/mn/route/route.php?case=GET'));

    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);

      if (parsed is Map<String, dynamic>) {
        if (parsed.containsKey("data") && parsed["data"] is List<dynamic>) {
          return parsed["data"].cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid format for route data');
        }
      } else if (parsed is List<dynamic>) {
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid format for route data');
      }
    } else {
      throw Exception('Failed to fetch route data');
    }
  }

  @override
  void initState() {
    super.initState();
    _routeData = _fetchRouteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'รายการการเดินรถ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _routeData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No route data available');
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20.0,
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    dataRowColor: MaterialStateColor.resolveWith((states) {
                      return Colors.blue.withOpacity(0.1);
                    }),
                    columns: <DataColumn>[
                      DataColumn(label: Text('เลขที่')),
                      DataColumn(label: Text('รหัสสถานที่')),
                      DataColumn(label: Text('เวลา')),
                      DataColumn(label: Text('เพิ่มเติม')),
                      DataColumn(label: Text('แก้ไข')),
                      DataColumn(label: Text('ลบ')),
                    ],
                    rows: snapshot.data!.map((data) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(
                              data['no']?.toString() ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              data['place_code']?.toString() ?? '',
                            ),
                          ),
                          DataCell(
                            Text(
                              data['time']?.toString() ?? '',
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RouteDetailPage(data: data),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'image/ss.png',
                                width: 27,
                                height: 27,
                              ),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditRoutePage(data: data),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RouteDeleteProductPage(data: data),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to the page for adding route data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsertRoutePage(),
              ),
            );
          },
          child: isHovered
              ? Text(
                  'เพิ่ม',
                  style: TextStyle(),
                )
              : Icon(Icons.add),
          hoverColor: Colors.blue,
          foregroundColor: Colors.white,
          backgroundColor: isHovered ? Colors.blue[800] : Colors.blue,
          elevation: isHovered ? 8 : 4,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RouteListPage(),
  ));
}
