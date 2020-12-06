import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:titans_note/helper/constant.dart';
import 'package:titans_note/screens/home_screen.dart';
import 'package:titans_note/screens/register_screen.dart';
import 'package:titans_note/helper/TransisiSlide.dart';
import 'package:titans_note/helper/TransisiScale.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBE4D4),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
                  key: _loginFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Hero(
                          tag: 'animasilogo',
                          child: Container(
                            margin: EdgeInsets.all(20.0),
                            height: 150.0,
                            width: 150.0,
                            child: Image.asset('assets/Images/UBM.png'),
                          ),
                        ),
                        TextFormField(
                          decoration: TextDecos.copyWith(
                            labelText: 'Email*', hintText: "john.doe@gmail.com",
                          ),
                          controller: emailInputController,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: TextDecos.copyWith(
                              labelText: 'Password*', hintText: "********"),
                          controller: pwdInputController,
                          obscureText: true,
                          validator: pwdValidator,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          child: Text("Login"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            if (_loginFormKey.currentState.validate()) {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                                  .then((currentUser) => FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(currentUser.user.uid)
                                  .get()
                                  .then((DocumentSnapshot result) =>
                                  Navigator.pushReplacement(
                                      context,
                                      TransisiScale(
                                          page:  HomeScreen(
                                            title: result["fname"] +
                                                "'s Tasks",
                                            uid: currentUser.user.uid,
                                          ))))
                                  .catchError((err) => print(err)))
                                  .catchError((err) => print(err));
                            }
                          },
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Text("Don't have an account yet?"),
                        RaisedButton(
                          child: Text("Register here!"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.push(context, TransisiSlide(page: RegisterScreen()));
                          },
                        )
                      ],
                    ),
                  ),
                ))));
  }
}
