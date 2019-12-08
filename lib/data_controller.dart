import 'dart:convert';
import 'package:firebase/firestore.dart';
import 'package:flutter/services.dart';
import 'package:portfolio3/custom_makers/model_maker.dart';
import 'package:portfolio3/datamaps.dart' as datamaps;
import 'package:googleapis_auth/auth_browser.dart' as auth;
import 'package:googleapis/drive/v2.dart' as drive;
import 'package:googleapis/calendar/v3.dart' as calendar;
import "package:googleapis/sheets/v4.dart" as sheets;
import "package:googleapis/slides/v1.dart" as slides;
import 'package:googleapis/docs/v1.dart' as docs;
import 'package:portfolio3/secrets.dart';

import 'package:http/http.dart' as http;

class DataController  {
  //Map<String, dynamic> dataMap = datamaps.dataMap;
  Map<String,dynamic> firebaseModels={};
  Map<String,dynamic> apiModels={};
  Map<String,dynamic> googleAPIModels={};
  auth.AutoRefreshingAuthClient googleAuthClient;

  Firestore db;
  bool initialized = false;

  DataController();

  Future<dynamic> getJsonResult({String url = "", Uri uri}) async {
    if (url != "") {
      http.Response res = await http.get(url);
      return json.decode(res.body);
    }
    return null;
  }
  initialize({Firestore firestoredb}){
    if(firestoredb!=null){db=firestoredb;initialized=true;}
    print("hey");
    datamaps.dataMap.forEach((key, data){
      if(data["type"]=="firebase")
          firebaseModels[key]=CustomModel.fromMap(data);
      else if(data["type"]=="api")
          apiModels[key]=CustomModel.fromMap(data);
      else if(data["type"]=="googleAPI")
          googleAPIModels[key]=CustomModel.fromMap(data);
    });
  //  if(initialized)getAllFirebaseData();
    
  }

  authorizeGoogleUser() async {
    final identifier = new auth.ClientId(
     secrets["googleClientID"],
     secrets["googleAPIKey"]);
    final scopes = [drive.DriveApi.DriveScope, calendar.CalendarApi.CalendarScope, sheets.SheetsApi.SpreadsheetsScope,docs.DocsApi.DocumentsScope ];
    auth.createImplicitBrowserFlow(identifier, scopes).then((onValue){
      onValue.clientViaUserConsent().then((client) {
        googleAuthClient=client;
        googleAPIModels["googleDocs"].calls["getData"]({"client":googleAuthClient});
  }).catchError((error) {
    if (error is auth.UserConsentException) {
      print("You did not grant access :(");
    } else {
      print("An unknown error occured: $error");
    }
  });
    });

  }
    Future<List<CustomModel>> getDataList(String modelName, String source) async{
      List<CustomModel> em = [];
      String data = await rootBundle.loadString(source);
      final jsonData = json.decode(data);
      jsonData.forEach((item){
        CustomModel cm = CustomModel.fromLib(modelName);
        cm.calls["fromMap"](item);
        em.add(cm);
      });
      return em;
    }

  Future<void> _addToDB(CustomModel cm, CollectionReference collection) async {
      await collection.add(cm.calls["toMap"]());
  }
  Future<void> getAllFirebaseData(){
      if(!initialized)return null;
      print("y");
      firebaseModels.forEach((key, firebaseModel) async{

       await firebaseModel.calls["getData"]({"firestore":db});
      });
      print("j");
      return null;
  }
 
  Future<List<drive.File>> searchTextDocuments(drive.DriveApi api,
                                             int max,
                                             String query) {
  var docs = [];
  Future next(String token) {
    print("\n\nDocs\n\n");
    // The API call will only return a subset of the results. It is possible
    // to query through the whole result set via "paging".
    return api.files.list(q: query, pageToken: token, maxResults: max)
        .then((results) {
          print(results.toJson());
      docs.addAll(results.items);
      if (docs.length < max && results.nextPageToken != null) {
        return next(results.nextPageToken);
      }
      return docs;
    });
  }
  return next(null);
}
}
class FirebaseManager {
  Firestore fs;
  

}class GoogleManager {

}


        //  db.collection(firebaseModel.vars[""])
        //               .onSnapshotMetadata
        //               .listen((onData) {
        //             onData.docs.forEach((dataItem) {
        //               print(dataItem.data());
                       
        //             });
        //           });
       // print(key);
       // await 