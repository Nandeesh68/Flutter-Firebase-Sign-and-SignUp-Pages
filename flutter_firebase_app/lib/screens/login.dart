import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/components/background.dart';
import 'package:flutter_firebase_app/components/formValidation.dart';
import 'package:flutter_firebase_app/screens/home.dart';
import 'package:flutter_firebase_app/screens/register.dart';
import 'package:flutter_firebase_app/service/service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FormValidator formValidator = FormValidator();
  Service service = Service();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _forgotPassword = TextEditingController();

  bool _obscureText = true;

  Future<Null> showAlertDialog(BuildContext context) async {
    Widget okButton = ElevatedButton(
      child: Text("Ok"),
      onPressed: () async {
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

        _firebaseAuth.sendPasswordResetEmail(email: _forgotPassword.text);
        _forgotPassword.clear();
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text('Please enter your E-mail'),
      contentPadding: EdgeInsets.all(5.0),
      content: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _forgotPassword,
          autofocus: false,
          decoration: InputDecoration(
            labelText: 'E-mail',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            formValidator.validateEmail(value!);
          },
        ),
      ),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(child: alert);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 70, 0, 5),
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36),
                  ),
                ),
                Container(
                  child: Text(
                    "Log into your account",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
                SizedBox(height: 50.0),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    validator: (value) {
                      formValidator.validateEmail(_email.text);
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: TextFormField(
                    autofocus: false,
                    controller: _password,
                    obscureText: _obscureText,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          semanticLabel:
                              _obscureText ? 'show password' : 'hide password',
                        ),
                      ),
                    ),
                    validator: (value) {
                      formValidator.validatePassword(_password.text);
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: TextButton(
                    onPressed: () {
                      showAlertDialog(context);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA)),
                    ),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: _email.text, password: _password.text);
                        if (userCredential.user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          service.showAlertDialog(
                              'No user found for that email.', context);
                        } else if (e.code == 'wrong-password') {
                          service.showAlertDialog(
                              'Wrong password provided for that user.',
                              context);
                        } else {
                          service.showAlertDialog('Data base error!!', context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: size.width * 0.5,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: new LinearGradient(colors: [
                            Color.fromARGB(255, 255, 136, 34),
                            Color.fromARGB(255, 255, 177, 41)
                          ])),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "Log in",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                    },
                    child: Text(
                      "Don't Have an Account? Sign up",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
