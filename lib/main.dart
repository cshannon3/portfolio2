
import 'package:flutter/material.dart';
import 'package:portfolio3/secrets.dart';
import 'package:portfolio3/state_manager.dart';

import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;

// main() async {
//   try {
//     fb.initializeApp(
//     apiKey: secrets["apiKey"],
//     authDomain: secrets["authDomain"],
//     databaseURL: secrets["databaseURL"],
//     projectId: secrets["projectId"],
//     storageBucket: secrets["storageBucket"],
//     messagingSenderId: secrets["messagingSenderId"],
//     );

//    // var db = fb.firestore();

//     runApp(MyApp());
    
//   } on fb.FirebaseJsNotLoadedException catch (e) {
//     print(e);
//   }
// }

 main() async {
   runApp(MyApp());
 }
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
    stateManager.initialize();//fb.firestore());
    stateManager.addListener((){
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    stateManager.h = MediaQuery.of(context).size.height;
		stateManager.w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar:stateManager.getAppBar(),
      body: stateManager.getCurrentScreen()
       );
  }
}

//   Future<List<drive.File>> searchTextDocuments(drive.DriveApi api,
//                                              int max,
//                                              String query) {
//   var docs = [];
//   Future next(String token) {
//     print("\n\nDocs\n\n");
//     // The API call will only return a subset of the results. It is possible
//     // to query through the whole result set via "paging".
//     return api.files.list(q: query, pageToken: token, maxResults: max)
//         .then((results) {
//           print(results.toJson());
//       docs.addAll(results.items);
//       if (docs.length < max && results.nextPageToken != null) {
//         return next(results.nextPageToken);
//       }
//       return docs;
//     });
//   }
//   return next(null);
// }

  //   final identifier = new auth.ClientId(
  //    secrets["googleClientID"],
  //    secrets["googleAPIKey"]);
    
  //   final scopes = [drive.DriveApi.DriveScope, calendar.CalendarApi.CalendarScope, sheets.SheetsApi.SpreadsheetsScope];
  //   var e = [];
  //   auth.createImplicitBrowserFlow(identifier, scopes).then((onValue){
  //     onValue.clientViaUserConsent().then((client) {
  //   var api = new drive.DriveApi(client);
  //   var calendarApi = new calendar.CalendarApi(client);
  //   var sheetsApi = new sheets.SheetsApi(client);
  //   print("\n\nSheets\n\n");
  //   print(sheetsApi.spreadsheets.sheets);
  //       calendarApi.events.list("primary").then((_events) {
  //         print("\n\nEvents\n\n");
  //         print(_events.toJson());
  //   });
  //   var query;
  //   searchTextDocuments(api, 20, query).then((List<drive.File> files) {

  //   }).catchError((error) {
  //     print('An error occured: $error');
  //   }).whenComplete(() {
  //     client.close();
  //   });
  // }).catchError((error) {
  //   if (error is auth.UserConsentException) {
  //     print("You did not grant access :(");
  //   } else {
  //     print("An unknown error occured: $error");
  //   }
  // });
  //   });