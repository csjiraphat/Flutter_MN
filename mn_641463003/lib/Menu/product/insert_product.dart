import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463003/Menu/product/list_product.dart';

class InsertProductPage extends StatefulWidget {
  @override
  _InsertProductPageState createState() => _InsertProductPageState();
}

class _InsertProductPageState extends State<InsertProductPage> {
  late TextEditingController productNameController;
  late TextEditingController unitController;
  late TextEditingController priceController;
  late List<Map<String, dynamic>> shopData = [];
  String? selectedShopCode;

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController();
    unitController = TextEditingController();
    priceController = TextEditingController();
    fetchShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        title: Text(
          'เพิ่มสินค้า',
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
                    'image/menu_product.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildTextField('ชื่อสินค้า', productNameController),
                buildTextField('หน่วย', unitController),
                buildTextField('ราคา', priceController),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'รหัสร้านค้า',
                  ),
                  value: selectedShopCode,
                  items: shopData.map((shop) {
                    return DropdownMenuItem<String>(
                      value: shop['shop_code'].toString(),
                      child: Text(shop['shop_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedShopCode = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    String productName = productNameController.text;
                    String unit = unitController.text;
                    String price = priceController.text;

                    if (selectedShopCode != null) {
                      String apiUrl =
                          'http://localhost/mn/product/product.php?case=POST';

                      try {
                        var response = await http.post(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'shop_code': selectedShopCode,
                            'product_name': productName,
                            'unit': unit,
                            'price': price,
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลสินค้าเรียบร้อยแล้ว.",
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลสินค้าได้. ${response.body}",
                          );
                        }
                      } catch (error) {
                        print('Error: $error');
                      }
                    } else {
                      print('Please select a shop');
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
    productNameController.dispose();
    unitController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void fetchShops() async {
    String apiUrl = 'http://localhost/mn/shop/shop.php?case=GET';
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['data'];
        setState(() {
          shopData = responseData.map((item) {
            return {
              'shop_code': item['shop_code'],
              'shop_name': item['shop_name']
            };
          }).toList();
        });
      } else {
        print("Failed to fetch shop data: ${response.statusCode}");
      }
    } catch (error) {
      print('Error: $error');
    }
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
                    builder: (context) => ProductListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการสินค้า'),
            ),
          ],
        );
      },
    );
  }
}
