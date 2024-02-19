import 'package:flutter/material.dart';
import 'package:mn_641463003/Login&Regis/Login.dart';

import 'package:mn_641463003/Menu/tram/list_tram.dart';
import 'package:mn_641463003/Menu/place/list_place.dart';
import 'location/all_location.dart';
import 'package:mn_641463003/Menu/shop/list_shop.dart';
import 'package:mn_641463003/Menu/product/list_product.dart';
import 'package:mn_641463003/Menu/route/list_route.dart';

class MenuPage extends StatelessWidget {
  final List<MenuButtonModel> menuItems = [
    MenuButtonModel('ข้อมูลรถราง', 'image/menu_tram.png'),
    MenuButtonModel('ข้อมูลสถานที่ท่องเที่ยว', 'image/menu_place.png'),
    MenuButtonModel('เส้นทางเดินรถ', 'image/menu_tracking.png'),
    MenuButtonModel('ข้อมูลร้านค้า', 'image/shop.png'),
    MenuButtonModel('ข้อมูลสินค้า', 'image/menu_product.png'),
    MenuButtonModel('จุดท่องเที่ยว', 'image/mark.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Digital Twins',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 126, 21, 192),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: menuItems.length,
          padding: EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, int index) {
            return CustomMenuButton(
              label: menuItems[index].label,
              imagePath: menuItems[index].imagePath,
              onPressed: () {
                navigateToPage(context, menuItems[index].label);
              },
            );
          },
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, String label) {
    switch (label) {
      case 'ข้อมูลรถราง':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TramListPage()),
        );
        break;
      case 'ข้อมูลสถานที่ท่องเที่ยว':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlaceListPage()),
        );
        break;
      case 'เส้นทางเดินรถ':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RouteListPage()),
        );
        break;
      case 'ข้อมูลร้านค้า':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShopListPage()),
        );
        break;
      case 'ข้อมูลสินค้า':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductListPage()),
        );
        break;
      case 'จุดท่องเที่ยว':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GPSTracking()),
        );
        break;
      default:
        print('Invalid menu label: $label');
    }
  }
}

class MenuButtonModel {
  final String label;
  final String imagePath;

  MenuButtonModel(this.label, this.imagePath);
}

class CustomMenuButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;

  const CustomMenuButton({
    required this.label,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 75, 132, 255).withOpacity(0.9),
              Color.fromARGB(255, 75, 132, 255).withOpacity(0.5),
            ],
          ),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
