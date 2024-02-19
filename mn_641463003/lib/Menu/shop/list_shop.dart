import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mn_641463003/Menu/shop/edit_shop.dart';
import 'package:mn_641463003/Menu/shop/insert_shop.dart';
import 'package:mn_641463003/Menu/shop/delete_shop.dart';
import 'package:mn_641463003/Menu/shop/detail_shop.dart';

class ShopListPage extends StatefulWidget {
  @override
  _ShopListPageState createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  bool isHovered = false;
  late Future<List<Map<String, dynamic>>> _shopData;

  Future<List<Map<String, dynamic>>> _fetchShopData() async {
    final response =
        await http.get(Uri.parse('http://localhost/mn/shop/shop.php?case=GET'));

    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);

      if (parsed is Map<String, dynamic>) {
        if (parsed.containsKey("data") && parsed["data"] is List<dynamic>) {
          return parsed["data"].cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid format for shop data');
        }
      } else if (parsed is List<dynamic>) {
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid format for shop data');
      }
    } else {
      throw Exception('Failed to fetch shop data');
    }
  }

  @override
  void initState() {
    super.initState();
    _shopData = _fetchShopData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'รายการร้านค้า',
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
            future: _shopData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No shop data available');
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
                      DataColumn(label: Text('รหัสร้านค้า')),
                      DataColumn(label: Text('ชื่อร้านค้า')),
                      DataColumn(label: Text('เพิ่มเติม')),
                      DataColumn(label: Text('แก้ไข')),
                      DataColumn(label: Text('ลบ')),
                    ],
                    rows: snapshot.data!.map((data) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(
                              data['shop_code']?.toString() ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              data['shop_name']?.toString() ?? '',
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ShopDetailPage(shopData: data),
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
                                        EditShopPage(data: data),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'image/edit.png',
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
                                        DeleteShopPage(data: data),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'image/delete1.png',
                                width: 27,
                                height: 27,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsertShopPage(),
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
    home: ShopListPage(),
  ));
}
