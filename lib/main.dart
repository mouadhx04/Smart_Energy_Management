import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:authentication/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyDJDv_qS736og3sXCZFKX1OoGKgCgfi4x8",
      appId: "1:325918628238:android:e7b2fa8231f60b15f82cdf",
      messagingSenderId: "325918628238-hv3g2v5ejhig7e6bhl14h8qmbtrvhfid.apps.googleusercontent.com",
      projectId: "sound-electron-340217",
    ),
  );
  runApp(const App());
}