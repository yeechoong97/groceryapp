import 'package:ecommerce/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:loading_animations/loading_animations.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = new AuthService();
  String email = "";
  String password = "";
  bool loading = false;

  void signIn() async {
    showLoading(context);
    dynamic user = await _auth.signInEmail(email, password);
    if (user == null)
      _showToast(context, "Invalid Crendetials Entered");
    else if (user.emailVerified == false) {
      _showToast(context, "Please verify your email first");
      AuthService().signOut();
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    showLoading(context);
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    Navigator.pop(context);
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future showLoading(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Center(
            child: LoadingBumpingLine.circle(
              backgroundColor: Colors.lightBlue,
              borderColor: Colors.blue,
              size: 70.0,
              duration: Duration(milliseconds: 1000),
            ),
          );
        });
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

  void navigateRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Text('Sign in'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 32),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: signIn,
                        child: Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.all(12.0),
                        ),
                      ),
                      TextButton(
                        onPressed: navigateRegister,
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  child: SignInButton(
                    Buttons.Google,
                    text: "Sign in with Google",
                    onPressed: signInWithGoogle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(msg),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      ),
    );
  }
}
