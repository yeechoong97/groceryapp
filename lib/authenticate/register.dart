import 'package:ecommerce/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = new AuthService();
  String email = "";
  String password = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: bodyRegistration(),
    );
  }

  void registerAccount() async {
    if (password != confirmPassword)
      _showToast(context);
    else {
      var result = await _auth.register(email, password);
      if (result != null) Navigator.pop(context);
    }
  }

  void setEmail(value) {
    setState(() {
      email = value;
    });
  }

  void setPassword(value) {
    setState(() {
      password = value;
    });
  }

  void setConfirmPassword(value) {
    setState(() {
      confirmPassword = value;
    });
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: const Text("Password & Confirm Password not match"),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      ),
    );
  }

  Widget bodyRegistration() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) => setEmail(value),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              labelText: 'Email',
              contentPadding: EdgeInsets.all(8.0),
            ),
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: TextField(
              onChanged: (value) => setPassword(value),
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Pasword',
                contentPadding: EdgeInsets.all(8.0),
              ),
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: TextField(
              onChanged: (value) => setConfirmPassword(value),
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                labelText: 'Confirm Pasword',
                contentPadding: EdgeInsets.all(8.0),
              ),
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: registerAccount,
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.all(12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
