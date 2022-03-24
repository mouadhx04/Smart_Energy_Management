import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:authentication/home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email, _password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))
        ),
        toolbarHeight: 150,

        actionsIconTheme: const IconThemeData(color: Colors.green, size: 40),
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
        children: [
          AnimatedTextKit(
            animatedTexts: [
              ScaleAnimatedText('Check Up', textStyle: const TextStyle(
                  fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
              ScaleAnimatedText('Your', textStyle: const TextStyle(
                  fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
              ScaleAnimatedText('Area!', textStyle: const TextStyle(
                  fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
            ],
            onTap: () {
              print("Tap Event");
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(30)
                  )
                ),
                  hintText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(30)
                    )
                ),
                hintText: 'Password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: Icon(
                Icons.visibility,
              ),
              ),
              onChanged: (value) {
                setState(() {
                  _password = value.trim();
                });
              },
            ),

          ),
          const SizedBox(height: 30.0,),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                RaisedButton(
                    highlightColor: Colors.green,
                    //splashColor: Colors.green,
                    elevation: 20.0,
                    color: Colors.lightBlue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: const Text('Log in',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
    ),
                    onPressed: (){
                      auth.signInWithEmailAndPassword(email: _email, password: _password).then((_){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                      });

                    }),
                RaisedButton(
                  highlightColor: Colors.green,
                  //splashColor: Colors.green,
                  elevation: 20.0,
                  color: Colors.lightBlueAccent,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                  child: const Text('Sign Up',
                    style: TextStyle(
                      fontSize: 15.0,
                    color: Colors.white,
                      fontWeight: FontWeight.bold,
                  ),
                  ),
                  onPressed: (){
                    auth.createUserWithEmailAndPassword(email: _email, password: _password).then((_){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                    });

                  },
                )
              ]
          )
        ],
      ),

    );
  }
}