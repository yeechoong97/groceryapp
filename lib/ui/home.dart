import 'package:ecommerce/services/auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _navigateScreen() {
      Navigator.pushNamed(context, "/category");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () => AuthService().signOut(),
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: TextButton(
          onPressed: _navigateScreen,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: Text(
            "Browse",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
