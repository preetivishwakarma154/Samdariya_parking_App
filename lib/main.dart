

import 'package:flutter/material.dart';

import 'package:samdriya/SplashScreen.dart';
import 'package:samdriya/Recipt.dart';
import 'package:url_launcher/url_launcher.dart';



Future<void> main() async {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: SplashScreen(),
    );
  }
}





