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


class DataController  {
  Map<String, dynamic> dataMap = datamaps.dataMap;
  Firestore db;
  bool initialized = false;

  DataController();
  initialize(Firestore _db){
    db=_db;
    initialized=true;
  }

  initializeGoogle() async {
    final identifier = new auth.ClientId(
     secrets["googleClientID"],
     secrets["googleAPIKey"]);
    
    final scopes = [drive.DriveApi.DriveScope, calendar.CalendarApi.CalendarScope, sheets.SheetsApi.SpreadsheetsScope,docs.DocsApi.DocumentsScope ];
    auth.createImplicitBrowserFlow(identifier, scopes).then((onValue){
      onValue.clientViaUserConsent().then((client) {
        print("HEY");
        var myDocs = docs.DocsApi(client);
        myDocs.documents.get("16wLizatyKJVH4x0Zpz2wVoeUYAcxbmsvJ2xJsAKOBfE").then((docData){
          var str = docData.body.toString();
          print(str.length);
          print(str);        }).catchError((onError){
            print("EEEEERRR");
          });

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
      dataMap.forEach((key, infoMap) {// print("\n\n$key\n\n");infoMap["collection_name"]
        infoMap["models"] = getFirebaseData(infoMap["collection_name"]);
    });
  }
  Future<dynamic> getFirebaseData(String collectionName, {bool toCustomModel=true}){
      if(!initialized)return null;
      db
          .collection(collectionName)
          .onSnapshotMetadata
          .listen((onData) {
        var l = [];
        onData.docs.forEach((dataItem) {
          if(toCustomModel){
            try {
              l.add(CustomModel.fromLib({"name": collectionName, "vars": dataItem.data()}));
            } catch (e) {
              print(dataItem.data());
              print("err");}
          }
          else l.add(dataItem.data());
        });
        return l;
      });
      
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



    // var api = new drive.DriveApi(client);
    // var calendarApi = new calendar.CalendarApi(client);
    // var sheetsApi = new sheets.SheetsApi(client);
    // print("\n\nSheets\n\n");
    // print(sheetsApi.spreadsheets.sheets);
    //     calendarApi.events.list("primary").then((_events) {
    //       print("\n\nEvents\n\n");
    //       print(_events.toJson());
    // });
    // var query;
    // searchTextDocuments(api, 20, query).then((List<drive.File> files) {

    // }).catchError((error) {
    //   print('An error occured: $error');
    // }).whenComplete(() {
    //   client.close();
    // });

    /*

I Have A Dream - 1-0TRJYy0dsDTbzXZHVEBRVOC8BiWv9_34IgyrX7Zn8w
   Battle Of Britain - 1WOx1ro53mE8YiOH_iOfMY0UqiOD3KAIV3mGovb_ZE2o
   Gettysburg Address - 16wLizatyKJVH4x0Zpz2wVoeUYAcxbmsvJ2xJsAKOBfE
   Declaration of Ind 1mtPVlFVytbsYJ8VONrRGfEXnzFfEavF9dbQQmakYOWg
    */