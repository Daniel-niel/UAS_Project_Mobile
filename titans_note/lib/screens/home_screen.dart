import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:titans_note/screens/about_screen.dart';
import 'package:titans_note/helper/app_color.dart';
import 'package:titans_note/helper/widget_background.dart';
import 'package:titans_note/screens/create_task_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:titans_note/screens/login_screen.dart';
import 'package:titans_note/helper/TransisiSlide.dart';


class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  HomeScreen({Key key, this.title, this.uid}) : super(key: key);
  //update the constructor to include the uid
  final String title;
  final String uid; //include this

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppColor appColor = AppColor();
  User currentUser;


  @override
  initState() {
    //taskTitleInputController = new TextEditingController();
    //taskDescripInputController = new TextEditingController();
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      backgroundColor: appColor.colorPrimary,

      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25),),
        backgroundColor: Color(0xFFFBE4D4),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.power_settings_new),
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((result) =>
                  Navigator.pushReplacementNamed(context, LoginScreen.id))
                  .catchError((err) => print(err));
            },
          )
        ],
      ),

      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            _buildWidgetListTodo(widthScreen, heightScreen, context),
          ],
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: FloatingActionButton(
              heroTag: null,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () async {
                Navigator.push(context, TransisiSlide(page: AboutScreen()));
              },
              backgroundColor: appColor.colorTertiary,
            ),
          ),

          FloatingActionButton(
            heroTag: null,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              // TODO: fitur tambah task
              bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTaskScreen(isEdit: false, uid: widget.uid)));
              if (result != null && result) {
                scaffoldState.currentState.showSnackBar(SnackBar(
                  content: Text('Aktivitas telah berhasil dibuat'),
                ));
                setState(() {});
              }
            },
            backgroundColor: appColor.colorTertiary,
          ),

        ],
      ),
    );
  }

  Container _buildWidgetListTodo(double widthScreen, double heightScreen, BuildContext context) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          /*
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              '[UAS-TIH01] To Do List',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          */
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('users').doc(widget.uid).collection('tasks').orderBy('date').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data.docs[index];
                    Map<String, dynamic> task = document.data();
                    String strDate = task['date'];
                    return Card(
                      child: ListTile(
                        title: Text(task['name']),
                        subtitle: Text(
                          task['description'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        isThreeLine: false,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                color: appColor.colorSecondary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${int.parse(strDate.split(' ')[0])}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              strDate.split(' ')[1],
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return List<PopupMenuEntry<String>>()
                              ..add(PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ))
                              ..add(PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ));
                          },
                          onSelected: (String value) async {
                            if (value == 'edit') {
                              // TODO: fitur edit task
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return CreateTaskScreen(
                                    isEdit: true,
                                    uid: widget.uid,
                                    documentId: document.id,
                                    name: task['name'],
                                    description: task['description'],
                                    date: task['date'],
                                  );
                                }),
                              );
                              if (result != null && result) {
                                scaffoldState.currentState.showSnackBar(SnackBar(
                                  content: Text('Aktivitas telah berhasil di Update'),
                                ));
                                setState(() {});
                              }
                            } else if (value == 'delete') {
                              // TODO: fitur hapus task
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Apakah kamu yakin ?'),
                                    content: Text('Apakah kamu yakin ingin menghapus file bernama [ ${task['name']} ] ?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Tidak'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Hapus'),
                                        onPressed: () {
                                          document.reference.delete();
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
