import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoapp_fsj/screens/home_screen.dart';
import 'package:todoapp_fsj/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  void _onLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _goToRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  Future<void> _onSignInWithGoogle() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      print(account.email);
      print(account.displayName);
      print(account.photoUrl);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 18),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: _onLogin,
                  child: Text('Masuk'),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  onPressed: _goToRegisterScreen,
                  child: Text('Daftar'),
                ),
              ),
              Divider(),
              RaisedButton(
                onPressed: _onSignInWithGoogle,
                child: Text('Masuk dengan Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
