import 'package:flutter/material.dart';
import 'package:titans_note/screens/about_screen.dart';
import 'package:titans_note/screens/create_task_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:titans_note/screens/home_screen.dart';
import 'package:titans_note/screens/login_screen.dart';
import 'package:titans_note/screens/register_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAS Pemograman Mobile - To Do List',
      debugShowCheckedModeBanner: false,

        initialRoute: LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          CreateTaskScreen.id: (context) => CreateTaskScreen(isEdit: false),
          AboutScreen.id: (context) => AboutScreen(),
        },
      //),
    );
  }
}

