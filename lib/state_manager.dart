import 'dart:async';
import 'dart:convert';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:portfolio3/custom_makers/model_maker.dart';
import 'package:portfolio3/custom_makers/w2.dart';
import 'package:portfolio3/data_controller.dart';
import 'package:portfolio3/datamaps.dart' as datamaps;
import 'package:portfolio3/utils/utils.dart';

//import 'package:firebase/firebase.dart' as fb;

class StateManager extends ChangeNotifier {
 // Timer timer;
  StateManager();
  DataController dataController = DataController();
  var controllerMap={
    "scriptText":TextEditingController()
  };
  //TextEditingController textFieldController = TextEditingController();
  CustomWidget2 customWidget;
  Navigation navigation;
  Size screenSize;
  //double h;double w;
  bool initiated = false;
  var routes = {};
  bool editorOpen= true;
  //Map<String,dynamic> apiOptions={};



  initialize(
    {Firestore firestoredb}//_db,
  ) async {
    //db = _db;
    routes = datamaps.routesStr;
    navigation = Navigation(() => notifyListeners(), routes);
    customWidget = CustomWidget2(
        lib: datamaps.myLib["vars"](), calls: datamaps.myLib["functions"](this));
    await dataController.initialize(firestoredb: firestoredb);
    //await dataController.authorizeGoogleUser();
    initiated = true;
    notifyListeners();
  }

  List<Widget> getDataChoices() {
    List<Widget> out = [];
   // dataController.dataMap.forEach((k, v) {
      dataController.firebaseModels.forEach((k, v) {
        print(k);
      out.add(ExpansionTile(
        title: Text(k),
        children: List.generate(v.vars["models"].length, (i) {
          return v.vars["models"][i].calls["toLabel"]();
        }),
      ));
    });
    return out;
  }

  Widget getCurrentScreen() {
    var dat={};
    //List<String> options = apiOptions.isNotEmpty?apiOptions.keys.toList():[""];
    List<String> options = dataController.apiModels.isNotEmpty?dataController.apiModels.keys.toList():[""];
    String dropdownValue = options[0];
    String endpoint =(dropdownValue!="")?dataController.apiModels[dropdownValue].vars["endpoints"][0]:"";
    if (!initiated) return Container();
    controllerMap["scriptText"].text=navigation.getCurrentScreenStr();
   // textFieldController.text = navigation.getCurrentScreenStr();
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        var screenh= MediaQuery.of(context).size.height;
        var screenw= MediaQuery.of(context).size.width;
        //if(editorOpen)screenw=(editorOpen)?screenw*2/3:screenw;
        return Row(
          children: <Widget>[
            Container(
              height: screenSize.height,
              width:  (editorOpen)?screenw*2/3:screenw-30.0,//screenSize.width*14/15,
              child:
                  customWidget // "tm":TextModel(text: "@@bold@@Curently Reading@@bold@@").toRichText()}
                      .toWidget(dataStr: controllerMap["scriptText"].text, screenH:screenh, screenW:(editorOpen)?screenw*2/3:screenw-30.0),
            ),
            !editorOpen?Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(width: 30.0,//screenSize.width/15,
                  child:IconButton(
                          onPressed: (){
                            setState((){
                              editorOpen=true;
                            });},
                            icon: Icon(Icons.plus_one),
                          )),
                           Container(width: 30.0,//screenSize.width/15,
                  child:IconButton(
                          onPressed: (){
                            setState((){
                              editorOpen=true;
                            });},
                            icon: Icon(Icons.arrow_back),
                          )),
              ],
            ):Container(
              height: screenh,//screenSize.height,
              width: screenw*1/3,//screenSize.width/ 3,
              color: Colors.grey[100],
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: (){
                        setState((){
                          editorOpen=false;
                        });
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                    bottom: TabBar(
                      tabs: [
                        Tab(text: "Script", icon: Icon(Icons.edit)),
                        Tab(text: "Lib", icon: Icon(Icons.inbox)),
                        Tab(text: "New", icon: Icon(Icons.add)),
                      ],
                    ),
                    title: Text('Editor Panel'),
                  ),
                  body: customWidget.toWidget(libIn: {
                   // "controller":textFieldController, 
                    "options":options,
                    "jsonData":dat,
                    "onPressed": () {print("SEE"); setState(() {});},
                    "dataChoices":getDataChoices(),
                    "onChange":(String newValue) {
                                  setState(() {
                                    dropdownValue= newValue;//datamaps.apiMap[dropdownValue]["endpoints"]
                                    endpoint = dataController.apiModels[dropdownValue].vars["endpoints"][0]; });},
                                    //apiOptions[dropdownValue].vars["endpoints"][0]; });},
                    "onChange2":(String newValue) {setState(() { endpoint = newValue; });},
                    "endpoints":dataController.apiModels[dropdownValue].vars["endpoints"],//apiOptions[dropdownValue].vars["endpoints"],
                    "getData":() {
                      dataController.getJsonResult(url:dataController.apiModels[dropdownValue].calls["getUrl"]()).then((res){
                    //apiOptions[dropdownValue].calls["getUrl"]()).then((res){ // print(res);// customWidget.tempLib["jsonData"]=res;//if(res!=null)currentText=res.toString();
                                      dat=res;
                                      setState((){});});}
                  },
                  dataStr: '''
                  tabBarView()[
                    center()~column()[
                      textField(controller:@getController(name:scriptText)),
                      row()[
                        raisedButton(onPressed:@onPressed)~text(text:Submit),
                        raisedButton(onPressed:@onPressed)~text(text:Save)
                      ]
                    ],
                    listView()[@dataChoices],
                    listView()[
                      expansionTile(title:text(text:New Data Model from APIs))[
                        dropdown(value:${dropdownValue}_onChange:@onChange_items:@options),
                        dropdown(value:${endpoint}_onChange:@onChange2_items:@endpoints),
                        raisedButton(onPressed:@getData)~text(text:Get), 
                        jsonToModel(json:@jsonData)
                      ],
                      expansionTile(title:text(text:New Data Model from Firebase)),
                      expansionTile(title:text(text:New Data Model from Inputed Data)),
                      expansionTile(title:text(text:New Widget))
                    ]
                  ] ''' ) //container()~text(text:**($currentText)**)
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  AppBar getAppBar() => initiated ? navigation.getAppBar() : AppBar();
}

class Navigation {
  List<String> currentRoute = ["/"];
  Function refresh;
  Map routes;
  Navigation(this.refresh, this.routes);

  bool isRoot() => currentRoute.length == 1;

  void goHome() {
    currentRoute = ['/'];
    refresh();
  }

  void goUpLayer() {
    if (currentRoute.length > 1) {
      currentRoute.removeLast();
      currentRoute.last = "/";
    }
    refresh();
  }

  void goDownLayer(String route) {
    currentRoute.last = route;
    if (routes[route] is Map) {
      currentRoute.add("/");
    }
    refresh();
  }

  List<Widget> _getTabHeaders() {
    List<Widget> tabHeaders = [];
    if (isRoot()) {
      routes.keys.forEach((key) {
        if (key != "/")
          tabHeaders
              .add(header(capWord(key.substring(1)), () => goDownLayer(key)));
      });
    } else {
      var layer = routes;
      for (int i = 0; i < currentRoute.length - 1; i++) {
        layer = layer[currentRoute[i]];
      }
      tabHeaders.add(header(
          capWord(currentRoute[currentRoute.length - 2].substring(1)),
          () => goDownLayer("/")));
      layer.keys.forEach((key) {
        // if(key!="/") print(capWord(key.substring(1)));
        if (key != "/")
          tabHeaders
              .add(header(capWord(key.substring(1)), () => goDownLayer(key)));
      });
    }
    return tabHeaders;
  }

  Widget header(String text, Function onPress) => Container(
      width: 200.0,
      child: InkWell(
        onTap: onPress,
        child: Container(
          child: Center(
              child: Text(
            text,
            style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
          )),
        ),
      )); //);

  AppBar getAppBar() => AppBar(
        elevation: 2.0,
        backgroundColor: Colors.amber[200],
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            goHome();
          },
        ),
        title: Container(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _getTabHeaders()),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_upward,
                color: isRoot() ? Colors.grey : Colors.black,
              ),
              onPressed: () {
                isRoot() ? goHome() : goUpLayer();
              }),
          IconButton(
              icon: Icon(
                Icons.account_box,
                color: isRoot() ? Colors.grey : Colors.black,
              ),
              onPressed: () {
                
              }),
        ],
      );
  String getCurrentScreenStr() {
    // timer?.cancel();
    var layer = routes;
    for (int i = 0; i < currentRoute.length - 1; i++) {
      layer = layer[currentRoute[i]];
    }
    return layer[currentRoute.last];
  }
}



   // print(apiOptions);
    //dataController.initialize(db);
    // var appdata = dataController.getFirebaseData("appData", toCustomModel:false)
    // dataController.getAllFirebaseData()
    // (dataMap["quotes"]["models"] as List).shuffle();
  //  datamaps.apiMap.forEach((k,v){
  //    print(k);
  //     apiOptions[k]=CustomModel.fromMap(v);
  //   });
  //  datamaps.dataMap.forEach((k,v){
  //    if(v["type"]=="api")
  //     apiOptions[k]=CustomModel.fromMap(v);
  //   });
//  padding(l:5_r:5)~row()[
//                           container()~text(text:Name ),
//                           expanded()~container()
//                                 ~textField(controller:@getController(name:dataModelName_type:text)),
//                           raisedButton(onPressed:@onPressed)~text(text:Save)
//                         ]
// combowave(ppf:0.012_c:green_radius:100.0_waves:[])
  // FocusNode _focusNode = new FocusNode();
  //final _http = HttpClient();
    //Firestore db;
      //var jsonData={};
        //Map<String, dynamic> dataMap = datamaps.dataMap;// final _http = http.Client();
