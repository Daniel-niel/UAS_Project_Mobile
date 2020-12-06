import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:titans_note/helper/TransisiScale.dart';
import 'package:titans_note/helper/constant.dart';
import 'package:titans_note/screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);
  static const String id = 'register_screen';


  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  String namadepan;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _registerFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('Register',textAlign: TextAlign.center, style: TextStyle(
                          color: Colors.green,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w800,
                        ),),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          decoration: TextDecos.copyWith(
                              labelText: 'First Name*', hintText: "John"),
                          controller: firstNameInputController,
                          validator: (value) {
                            if (value.length < 3) {
                              return "Please enter a valid first name.";
                            } else {
                              namadepan = firstNameInputController.text;
                            } return null;
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            decoration: TextDecos.copyWith(
                                labelText: 'Last Name*', hintText: "Doe"),
                            controller: lastNameInputController,
                            validator: (value) {
                              if (value.length < 3) {
                                return "Please enter a valid last name.";
                              } return null;
                            }),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: TextDecos.copyWith(
                              labelText: 'Email*', hintText: "john.doe@gmail.com"),
                          controller: emailInputController,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: TextDecos.copyWith(
                              labelText: 'Password*', hintText: "********"),
                          controller: pwdInputController,
                          obscureText: true,
                          validator: pwdValidator,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: TextDecos.copyWith(
                              labelText: 'Confirm Password*', hintText: "********"),
                          controller: confirmPwdInputController,
                          obscureText: true,
                          validator: pwdValidator,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          child: Text("Register"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            if (_registerFormKey.currentState.validate()) {
                              if (pwdInputController.text ==
                                  confirmPwdInputController.text) {
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                    .then((currentUser) => FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(currentUser.user.uid)
                                    .set({
                                  "uid": currentUser.user.uid,
                                  "fname": firstNameInputController.text,
                                  "surname": lastNameInputController.text,
                                  "email": emailInputController.text,
                                })
                                    .then((result) => {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      TransisiScale(
                                          page: HomeScreen(
                                            title: namadepan + "'s Tasks",
                                            uid: currentUser.user.uid,
                                          )),
                                          (_) => false),
                                  firstNameInputController.clear(),
                                  lastNameInputController.clear(),
                                  emailInputController.clear(),
                                  pwdInputController.clear(),
                                  confirmPwdInputController.clear()
                                })
                                    .catchError((err) => print(err)))
                                    .catchError((err) => print(err));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text("The passwords do not match"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Text("Already have an account?"),
                        RaisedButton(
                          child: Text("Login here!"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                ))));
  }
}
