import 'dart:convert';
import 'package:firebase/firestore.dart';
import 'package:flutter/services.dart';
import 'package:portfolio3/custom_makers/model_maker.dart';

class DataController  {
  DataController();
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
}
