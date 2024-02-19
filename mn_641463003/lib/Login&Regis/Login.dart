import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Register.dart';
import 'package:mn_641463003/Menu/Menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'เข้าสู่ระบบ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void submitLogin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    // URL of the API you want to call (checklogin.php)
    String apiUrl = 'http://localhost/mn/checklogin.php';

    // Create the body of the request to send data
    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Login Successfully');

        // Navigate to MenuPage1 on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuPage()),
        );
      } else {
        // Handle unsuccessful login
        print('Login Error');
        showErrorDialog(context,
            'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'); // แสดง error ด้วย showDialog
      }
    } catch (error) {
      // Handle connection error
      print('Connection Error: $error');
      showErrorDialog(
          context, 'Connection error'); // แสดง error ด้วย showDialog
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดกล่องข้อความ
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เข้าสู่ระบบ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image(
                image: AssetImage('image/place.png'),
                width: 200.0,
                height: 200.0,
              ),
              SizedBox(height: 16.0),

              // Username TextField with icon
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'อีเมล',
                  prefixIcon: Image.asset(
                    'image/profile.png',
                    height: 20.0,
                    width: 20.0,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Password TextField with icon
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  prefixIcon: Image.asset(
                    'image/password.png',
                    height: 20.0,
                    width: 20.0,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 32.0),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  String username = emailController.text;
                  String password = passwordController.text;

                  if (username.isEmpty || password.isEmpty) {
                    // Show error borders around empty fields
                    if (username.isEmpty) {
                      emailController.clear();
                      passwordController.text = ''; // Trigger the error border
                    }
                    if (password.isEmpty) {
                      emailController.clear();
                      passwordController.text = ''; // Trigger the error border
                    }

                    print('Username and password are required');
                  } else {
                    // Submit the login data
                    submitLogin(context);
                  }
                },
                child: Text(
                  'เข้าสู่ระบบ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: const Color.fromARGB(255, 126, 21, 192),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Register Button
              TextButton(
                onPressed: () {
                  // Navigate to the register page
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Text(
                  'ลงทะเบียน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color.fromARGB(255, 65, 106, 253),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
