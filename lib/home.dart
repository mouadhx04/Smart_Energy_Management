import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authentication/login.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('House').snapshots();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder<QuerySnapshot>(
        stream:
        FirebaseFirestore.instance.collection("House").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {return const Text('Something went wrong');}
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");}
          return Scaffold(
              backgroundColor: Colors.white30,
              appBar: AppBar(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60))
                ),
                toolbarHeight: 150,
                leading: const Icon(Icons.account_circle_rounded),
                actions: const [
                  Icon(Icons.more_vert),
                ],
                leadingWidth: 60,
                actionsIconTheme: const IconThemeData(color: Colors.white, size: 50),
                title: const Text('S E M',
                  style: TextStyle(
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold,
                      decorationColor: Colors.orange,
                      decorationThickness: 2.0,
                      shadows: [
                        Shadow(
                            color: Colors.black,
                            blurRadius: 10.0,
                            offset: Offset(4, 1)
                        )
                      ]
                  ),
                ),
                centerTitle: true,
              ),

              body: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<Object?, dynamic> data = document.data()! as Map<Object?, dynamic>;

                  return ListView(
                    shrinkWrap: true,
                    children: <Widget>[

                      Container(
                        decoration: BoxDecoration(
                            image: const DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/temp.png')
                            ),
                            color: Colors.lightBlue,
                            border: Border.all(
                                color: Colors.blue,
                                width: 2.0,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(50.0))
                        ),
                        padding: EdgeInsets.all(20.0),
                        margin: EdgeInsets.all(15.0),
                        height: 60.0,
                        width: 20.0,
                        child: Text( data['temperature'],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black
                          ),
                        ),
                      ),


                      Container(
                        decoration: BoxDecoration(
                            image: const DecorationImage(fit: BoxFit.fill,
                                image: AssetImage('assets/images/hum.png')
                            ),
                            color: Colors.lightBlue,
                            border: Border.all(
                                color: Colors.blue,
                                width: 2.0,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(50.0))
                        ),
                        padding: EdgeInsets.all(20.0),
                        margin: EdgeInsets.all(15.0),
                        height: 60.0,
                        width: 20.0,
                        child: Text(data['humidity'],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),



                      Container(
                        decoration: BoxDecoration(
                            image: const DecorationImage(fit: BoxFit.fill,
                                image: AssetImage('assets/images/crt.png')
                            ),
                            color: Colors.lightBlue,
                            border: Border.all(
                                color: Colors.blue,
                                width: 2.0,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.all(const Radius.circular(50.0))
                        ),

                        padding: EdgeInsets.all(20.0),
                        margin: EdgeInsets.all(15.0),
                        height: 60.0,
                        width: 20.0,
                        child: Text(data['watts'],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black
                          ),
                        ),
                      ),


                      Container(
                        decoration: BoxDecoration(
                            image: const DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/gaz.png')
                            ),
                            color: Colors.lightBlue,
                            border: Border.all(
                                color: Colors.blue,
                                width: 2.0,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(50.0))
                        ),
                        padding: EdgeInsets.all(20.0),
                        margin: EdgeInsets.all(15.0),
                        height: 60.0,
                        width: 20.0,
                        child: Text( data['gas'],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black
                          ),
                        ),
                      ),



                    ],
                    addAutomaticKeepAlives: true,
                  );
                }).toList(),

              )
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 12.5,
        splashColor: Colors.green,
        backgroundColor: Colors.lightBlue,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(70))
        ),
        onPressed: () {
          auth.signOut();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        label: const Text('Good By!', style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                  color: Colors.black,
                  blurRadius: 3.0,
                  offset: Offset(4, 1)
              )
            ]
        ),
        ),
      ),
    );
  }
}
