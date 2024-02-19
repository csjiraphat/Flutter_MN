import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ลงทะเบียน',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> registerUser(BuildContext context) async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validate input fields
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      print('All fields are required');
      return;
    }

    // URL of the API you want to call (replace with your actual API URL)
    String apiUrl = 'http://localhost/mn/register.php';

    // Create the body of the request to send data
    Map<String, dynamic> requestBody = {
      'firstname': firstName,
      'lastname': lastName,
      'phone': phone,
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
        print('Registration Successful');

        // Navigate to MenuPage on successful registration
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        // );

        showSuccessDialog(context, 'ลงทะเบียนสำเร็จแล้ว');
      } else if (response.statusCode == 500) {
        // Handle unsuccessful registration
        print('Registration Error');
        showErrorDialog(context, 'error');
      }
    } catch (error) {
      // Handle connection error
      print('Connection Error: $error');
      showErrorDialog(context, 'Connection error');
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ผิดพลาด'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog box
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('สำเร็จแล้ว'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // Close the dialog box
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
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return false; // Prevent default behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('ลงทะเบียน'),
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

                // First Name TextField with image icon
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อ',
                    prefixIcon: Image.asset('image/profile.png',
                        height: 20.0, width: 20.0),
                  ),
                ),
                SizedBox(height: 16.0),

                // Last Name TextField with image icon
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'นามสกุล',
                    prefixIcon: Image.asset('image/profile.png',
                        height: 20.0, width: 20.0),
                  ),
                ),
                SizedBox(height: 16.0),

                // Phone TextField with image icon
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'โทรศัพท์',
                    prefixIcon: Image.asset('image/telephone.png',
                        height: 20.0, width: 20.0),
                  ),
                ),
                SizedBox(height: 16.0),

                // Email TextField with image icon
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    prefixIcon: Image.asset('image/email.png',
                        height: 20.0, width: 20.0),
                  ),
                ),
                SizedBox(height: 16.0),

                // Password TextField with image icon
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    prefixIcon: Image.asset('image/password.png',
                        height: 20.0, width: 20.0),
                  ),
                ),
                SizedBox(height: 16.0),

                // Register Button
                ElevatedButton(
                  onPressed: () {
                    String firstName = _firstNameController.text;
                    String lastName = _lastNameController.text;
                    String email = _emailController.text;
                    String phone = _phoneController.text;
                    String password = _passwordController.text;

                    if (firstName.isEmpty ||
                        lastName.isEmpty ||
                        email.isEmpty ||
                        phone.isEmpty ||
                        password.isEmpty) {
                      // Show error borders around empty fields
                      if (firstName.isEmpty) {
                        _firstNameController.clear();
                      }
                      if (lastName.isEmpty) {
                        _lastNameController.clear();
                      }
                      if (email.isEmpty) {
                        _emailController.clear();
                      }
                      if (phone.isEmpty) {
                        _phoneController.clear();
                      }
                      if (password.isEmpty) {
                        _passwordController.clear();
                      }

                      print('Registration Error');
                      showErrorDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
                    } else {
                      // Submit the registration data
                      registerUser(context);
                    }
                  },
                  child: Text('ลงทะเบียน'),
                ),

                // Cancel Button
                TextButton(
                  onPressed: () {
                    // Navigate back to the login page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('ยกเลิก'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
