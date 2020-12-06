import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutScreen extends StatefulWidget {
  static const String id = 'about_screen';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFBE4D4),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('About Us', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25),),
          backgroundColor: Color(0xFFFBE4D4),
        ),
        body: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/Images/32180115.jpg'),
                    radius: 100.0,
                  ),
                  InkWell(
                    child: Text('Daniel 32180115',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
                    ),
                    onTap: () async {
                      if (await canLaunch("https://www.instagram.com/daniel_niel_05/")) {
                        await launch("https://www.instagram.com/daniel_niel_05/");
                      }
                    }
                  ),

                  CircleAvatar(
                    backgroundImage: NetworkImage('https://student.ubm.ac.id/images/foto/32180085.jpg'),
                    radius: 100.0,
                  ),
                  InkWell(
                    child: Text('Kalingga 32180085',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
                    ),
                      onTap: () async {
                        if (await canLaunch("https://www.instagram.com/kalingga_kg/")) {
                          await launch("https://www.instagram.com/kalingga_kg/");
                        }
                      }
                  ),

                  CircleAvatar(
                    backgroundImage: AssetImage('assets/Images/32180009.jpg'),
                    radius: 100.0,
                  ),

                  InkWell(
                    child: Text('Yogi 32180009',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
                    ),
                      onTap: () async {
                        if (await canLaunch("https://www.instagram.com/yogitan00/")) {
                          await launch("https://www.instagram.com/yogitan00/");
                        }
                      }
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

