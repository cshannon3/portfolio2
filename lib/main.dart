
import 'package:flutter/material.dart';
import 'package:portfolio3/secrets.dart';
import 'package:portfolio3/state_manager.dart';

import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;

main() async {
  try {
    fb.initializeApp(
    apiKey: secrets["apiKey"],
    authDomain: secrets["authDomain"],
    databaseURL: secrets["databaseURL"],
    projectId: secrets["projectId"],
    storageBucket: secrets["storageBucket"],
    messagingSenderId: secrets["messagingSenderId"],
    );

   // var db = fb.firestore();

    runApp(MyApp());
    
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}

//  main() async {
//    runApp(MyApp());
//  }
class MyApp extends StatelessWidget {
  MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage()//db:db),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,}) : super(key: key);// this.db

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  StateManager stateManager =StateManager();


 @override
  void initState() {
    super.initState();
    stateManager.initialize(
      //fb.firestore()
      );
    stateManager.addListener((){
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    stateManager.screenSize = MediaQuery.of(context).size;
	//	stateManager.w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar:stateManager.getAppBar(),
      body: stateManager.getCurrentScreen()
       );
  }
}



