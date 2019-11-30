import 'dart:async';
import 'dart:convert';

import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:portfolio3/custom_makers/model_maker.dart';
import 'package:portfolio3/custom_makers/w2.dart';
import 'package:portfolio3/data_controller.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio3/datamaps.dart' as datamaps;
import 'package:portfolio3/utils/utils.dart';
// combowave(ppf:0.012_c:green_radius:100.0_waves:[])

class StateManager extends ChangeNotifier {
  Timer timer;
  StateManager();
  DataController dataController = DataController();

  TextEditingController textFieldController = TextEditingController();
  CustomWidget2 customWidget;

  // FocusNode _focusNode = new FocusNode();
  Navigation navigation;
  //final _http = HttpClient();
  double h;
  double w;
  bool initiated = false;
  Firestore db;
  var routes = {};
  Map<String,dynamic> apiOptions={};
  Map<String, dynamic> dataMap = datamaps.dataMap;

  // final _http = http.Client();

  Future<dynamic> getJsonResult({String url = "", Uri uri}) async {
    // if(uri!=null){
    //   var response = await (await _http.getUrl(uri)).close();
    //   var transformedResponse = await response.transform(utf8.decoder).join();
    //   return json.decode(transformedResponse);
    // }
    if (url != "") {
      http.Response res = await http.get(url);
      return json.decode(res.body);
    }
    return null;
  }

  initialize(
   // Firestore _db,
  ) async {
  //  db = _db;
    routes = datamaps.routesStr;
    navigation = Navigation(() => notifyListeners(), routes);
    customWidget = CustomWidget2(
        lib: datamaps.myLib["vars"](), calls: datamaps.myLib["functions"](this));
   datamaps.apiMap.forEach((k,v){
     print(k);
      apiOptions[k]=CustomModel.fromMap(v);
    });
    print(apiOptions);
    // db.collection("appData").onSnapshotMetadata.listen((onData){
    //   onData.docs.forEach((dataItem){
    //     var data =dataItem.data();
    //     if(data["name"]=="routes"){
    //       routes=data["data"];
    //       navigation= Navigation(()=>notifyListeners(), routes);
    //       initiated=true;
    //       notifyListeners();
    //       print(routes);
    //     }
    //  });
    // });
    // _focusNode.addListener(_focusNodeListener);
    // dataMap.forEach((key, infoMap) {
    //   print("\n\n$key\n\n");
    //   db
    //       .collection(infoMap["collection_name"])
    //       .onSnapshotMetadata
    //       .listen((onData) {
    //     var l = [];
    //     onData.docs.forEach((dataItem) {
    //       try {
    //         l.add(CustomModel.fromLib(
    //             {"name": infoMap["name"], "vars": dataItem.data()}));
    //         // print(l.last.vars["author"]);
    //       } catch (e) {
    //         print(dataItem.data());
    //         print("err");
    //       }
    //     });
    //     infoMap["models"] = l;
    //   });
    // });
    // (dataMap["quotes"]["models"] as List).shuffle();
    initiated = true;
    notifyListeners();
  }

  List<Widget> getDataChoices() {
    List<Widget> out = [];
    dataMap.forEach((k, v) {
      out.add(ExpansionTile(
        title: Text(k),
        children: List.generate(v["models"].length, (i) {
          return v["models"][i].calls["toLabel"]();
        }),
      ));
    });
    return out;
  }

  Widget getCurrentScreen() {
    String currentText="";
    List<String> options = apiOptions.isNotEmpty?apiOptions.keys.toList():[""];
  String dropdownValue = options[0];
    String endpoint =(dropdownValue!="")?apiOptions[dropdownValue].vars["endpoints"][0]:"";
    if (!initiated) return Container();
    textFieldController.text = navigation.getCurrentScreenStr();
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Row(
          children: <Widget>[
            Container(
              height: h,
              width: w * 2 / 3,
              child:
                  customWidget // "tm":TextModel(text: "@@bold@@Curently Reading@@bold@@").toRichText()}
                      .toWidget(dataStr: textFieldController.text),
            ),
            Container(
              height: h,
              width: w / 3,
              color: Colors.grey[100],
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
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
                    "controller":textFieldController, 
                    "options":options,
                    "onPressed": () {print("SEE"); setState(() {});},
                    "dataChoices":getDataChoices(),
                    "onChange":(String newValue) {
                                  setState(() {
                                    dropdownValue= newValue;//datamaps.apiMap[dropdownValue]["endpoints"]
                                    endpoint = apiOptions[dropdownValue].vars["endpoints"][0]; });},
                    "onChange2":(String newValue) {setState(() { endpoint = newValue; });},
                    "endpoints":apiOptions[dropdownValue].vars["endpoints"],
                    "getData":() {
                      getJsonResult(url:apiOptions[dropdownValue].calls["getUrl"]()).then((res){
                                      print(res);
                                      if(res!=null)currentText=res.toString();
                                      setState((){});});}
                  },
                  dataStr: '''
                  tabBarView()[
                    center()~column()[
                      textField(controller:@controller),
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
                        container()~text(text:$currentText)
                      ],
                      expansionTile(title:text(text:New Data Model from Firebase)),
                      expansionTile(title:text(text:New Data Model from Inputed Data)),
                      expansionTile(title:text(text:New Widget))
                    ]
                   
                  ]
                  '''
                  )
                  // '''
                  // tabBarView()[
                  //   center()~column()[
                  //     textField(),
                  //     row()[
                  //       raisedButton(onPressed:@onPressed)~text(text:Submit),
                  //       raisedButton(onPressed:@onPressed)~text(text:Save),
                  //     ]
                  //   ],
                  //   listView()[@dataChoices],
                  //   listView()[
                  //     expansionTile(title:text(text:New Data Model from APIs))[
                  //       dropdown(value:${dropdownValue}_onChange:@onChange_items:@options),
                  //       dropdown(value:${endpoint}_onChange:@onChange2_items:@endpoints),
                  //       raisedButton(onPressed:@getData)~text(text:Get), 
                  //       container()~text(text:$currentText)
                  //     ],
                  //     expansionTile(title:text(text:New Data Model from Firebase)),
                  //     expansionTile(title:text(text:New Data Model from Inputed Data)),
                  //     expansionTile(title:text(text:New Widget))
                  //   ]
                  // ]
                  // '''
                  
                  // TabBarView(
                  //   children: [
                  //     Center(
                  //       child: Column(
                  //         children: <Widget>[
                  //           TextField(
                  //             controller: textFieldController,
                  //             keyboardType: TextInputType.multiline,
                  //             maxLines: null,
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //             children: <Widget>[
                  //               RaisedButton(
                  //                 onPressed: () {
                  //                   setState(() {});
                  //                 },
                  //                 child: Text("Submit"),
                  //               ),
                  //               RaisedButton(
                  //                 onPressed: () {
                  //                   setState(() {});
                  //                 },
                  //                 child: Text("Save"),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     ListView(children: getDataChoices()),
                  //     ListView(children: [
                  //       ExpansionTile(
                  //           title: Text("New Data Model from APIs"),
                  //           children: [
                  //             DropdownButton<String>(
                  //               value: dropdownValue,
                  //               icon: Icon(Icons.arrow_downward),
                  //               iconSize: 24,
                  //               elevation: 16,
                  //               style: TextStyle(color: Colors.deepPurple),
                  //               underline: Container(
                  //                 height: 2,
                  //                 color: Colors.deepPurpleAccent,
                  //               ),
                  //               onChanged: (String newValue) {
                  //                 setState(() {
                  //                   dropdownValue= newValue;//datamaps.apiMap[dropdownValue]["endpoints"]
                  //                   endpoint = apiOptions[dropdownValue].vars["endpoints"][0];
                  //                 });
                  //               },
                  //               items: options.map<DropdownMenuItem<String>>(
                  //                   (String value) {
                  //                 return DropdownMenuItem<String>(
                  //                   value: value,
                  //                   child: Text(value),
                  //                 );
                  //               }).toList(),
                  //             ),
                  //             DropdownButton<String>(
                  //               value: endpoint,
                  //               icon: Icon(Icons.arrow_downward),
                  //               iconSize: 24,
                  //               elevation: 16,
                  //               style: TextStyle(color: Colors.deepPurple),
                  //               underline: Container(
                  //                 height: 2,
                  //                 color: Colors.deepPurpleAccent,
                  //               ),
                  //               onChanged: (String newValue) {
                  //                 setState(() {
                  //                   endpoint = newValue;
                  //                 });
                  //               },
                  //               items: apiOptions[dropdownValue].vars["endpoints"].map<DropdownMenuItem<String>>(
                  //                   (String value) {
                  //                 return DropdownMenuItem<String>(
                  //                   value: value,
                  //                   child: Text(value),
                  //                 );
                  //               }).toList(),
                  //             ),
                  //             RaisedButton(
                  //                 onPressed: () async {
                  //                   await getJsonResult(url:apiOptions[dropdownValue].calls["getUrl"]()).then((res){
                  //                     if(res!=null)currentText=res.toString();
                  //                     setState((){});
                  //                   });
                  //                 },
                  //                 child: Text("Get"),
                  //               ),
                  //               Container(
                  //                 child: Text(currentText),
                  //               )
                  //           ]),
                  //       ExpansionTile(
                  //         title: Text("New Data Model from Firebase"),
                  //       ),
                  //       ExpansionTile(
                  //         title: Text("New Data Model from Inputed Data"),
                  //       ),
                  //       ExpansionTile(
                  //         title: Text("New Widget"),
                  //       )
                  //     ]
                  //         // getAPIChoices()
                  //         ),

                  //     // Icon(Icons.directions_bike),
                  //   ],
                //  ),
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

// "fl":(var tokens){
//     CustomModel fourierLines = CustomModel.fromLib(
//         {"name":"fourierLines",
//         "vars":{ "stepPerUpdate":2.5,"thickness":8.0,}} );
//         fourierLines.calls["squareWave"](numoflines:5, line1Len:100.0);
//       return MainAnimator(model: fourierLines,);
//   },
// "fl3":(var tokens){
//   CustomModel fourierLines = CustomModel.fromLib('''fourierLines(stepPerUpdate:2.5_thickness:8.0_waves:squareWave(numoflines:5_line1Len:100.0))''');
//       fourierLines.calls["squareWave"](numoflines:5, line1Len:100.0);
//     return fourierLines;//MainAnimator(model: ,);
// },

/// ''' CustomWidget2(
///        container(h:@h_w@w(frac:0.33_c:grey100)
///            ~ tabController(length:3)~scaffold(
///                appBar:appBar(bottom:tabBar()[
///
///                      ]
///                 )
///              )

// List<Widget> getAPIChoices(Function setstate){
//     List<String> options = datamaps.apiMap.keys.toList();
//      String dropdownValue = options[0];

//     List<Widget> out=[];
//     out.add(DropdownButton<String>(
//         value: dropdownValue,
//         icon: Icon(Icons.arrow_downward),
//         iconSize: 24,
//         elevation: 16,
//         style: TextStyle(
//           color: Colors.deepPurple
//         ),
//         underline: Container(
//           height: 2,
//           color: Colors.deepPurpleAccent,
//         ),
//         onChanged: (String newValue) {
//           dropdownValue = newValue;
//           setState(() {  });
//         },
//         items: options
//           .map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           })
//           .toList(),
//       )
//     );
//     // datamaps.apiMap.forEach((k,v){
//     //   out.add(ExpansionTile(
//     //     title: Text(k),
//     //     children: List.generate(v["models"].length, (i){
//     //       return  v["models"][i].calls["toLabel"]();

//     //     }),
//     //   ));
//     // });
//     return out;
//   }

// dynamic initiateTimer({int msPerCall, Function(Timer t) onCall}){
//     timer = Timer.periodic(
//     Duration(milliseconds: msPerCall),onCall);
// }

//   Map<String, dynamic> routes = {
//      "/":(StateManager s){ //Container(),
//                s.textFieldController.text='''
//    stack()
//     [
//       fitted(l:75_r:90_t:5_b:100_h:400_w:800)~
//       container(h:50_w:30_color:red)~@hello(),
//   fittedrcb(l:5_r:60_t:5_b:100_h:400_w:800)~column()[
//                       container(h:50_w:30_color:red)~customText(text:Whats Up_bold:t),
//                       container(h:50_w:60_color:red)~richText(text:textSpan(text:Hi))
//                     ]
//       ]
//    ''';

//    return StatefulBuilder(

//      builder: (BuildContext context, setState) {
//           return Row(
//            children: <Widget>[
//              Expanded(
//                child: CustomWidget2(
//        lib: {"w": s.w, "h":s.h, "hello":Text("hello"),}// "tm":TextModel(text: "@@bold@@Curently Reading@@bold@@").toRichText()}
//      ).toWidget(
//    dataStr: s.textFieldController.text
//      ),
//              ),
//              Expanded(child: Container(color: Colors.grey[100],child: Center(child: Column(
//                children: <Widget>[
//                  TextField(
//             controller: s.textFieldController,
//             //This makes the textfield accept multilines,
//             //when the user taps "enter" button, it moves to the next line
//             keyboardType: TextInputType.multiline,
//             //you can also set this property to specify the Maximun lines the textfield is to take
//             maxLines: 25,
//           ),
//            RaisedButton(onPressed: (){setState((){});},child: Text("Submit"),),
//                ],
//              ),
//             ),))
//            ],
//          );

//      },
//    );
//      },
//   "/play":{
//     "/":(StateManager s)=> CustomWidget2(lib: {"color":Colors.lightGreen, "text":Text("Random")})
//     .toWidget(
//       dataStr: "center()~column()[container(h:150_w:100_color:blue),container(h:50_w:100_color:@color)~@text]"),//(StateManager s)=>CustomClass().toWidget(),
//     "/fourier":(StateManager s){
//       List<CustomModel> waves = CustomModel().listFromLib([
//               "wave_w_${1.0}_ppf_${1.0}_c_red",
//               "wave_w_${1.0/3}_ppf_${3.0}_c_blue",
//               "wave_w_${1.0/5}_ppf_${5.0}_c_indigo",
//               "wave_w_${1.0/7}_ppf_${7.0}_c_orange",
//               "wave_w_${1.0/9}_ppf_${9.0}_c_purple"]);

//           CustomModel comboWave = CustomModel.fromLib({
//             "name":"comboWave",
//             "vars":{
//                 "waves": waves,
//                 "ppf":(1.0 / (15*10)),// int updatesPerSecond = 15;0int secondsPerFullWave = 10;// percent of circle progressed per call
//                 "color": "green",
//                 "samplingfreq": 100
//             }});
//             CustomModel fourierLines = CustomModel.fromLib(
//             {"name":"fourierLines",
//             "vars":{
//               "stepPerUpdate":2.5,
//               "thickness":8.0,
//             }}
//             );
//             fourierLines.calls["squareWave"](numoflines:5, line1Len:100.0);
//           return
//           CustomWidget2(
//            calls: {
//              "fl":()=>MainAnimator(model: fourierLines,),
//              "shell":()=> Container(), // Shell(comboWave: comboWave,),
//             }
//           ).toWidget(
//         dataStr: '''row()[
//           expanded()~container(h:${s.h*.95}_w:${s.w*.43})~@shell(),
//           expanded()~container(h:${s.h*.95}_w:${s.w*.43})~@fl()
//         ]''');},

//   },
//   '/learn':{
//     "/":(StateManager s)=>CustomWidget2(
//       lib: {"h":s.h, "w":s.w, "hello": Text("hello")}
//     ).toWidget(dataStr:
//     '''stack()[
//       fittedrcb(l:5_r:90_t:5_b:100_h:@h_w:@w)
//         ~listView()[
//           rcb(h:${s.h*2.0}_w:${s.w*0.8}_all:3)
//             ~padding(all:5)~center()
//               ~container(h:50_w:30_color:red)
//                 ~@hello
//         ]
//     ]
//     '''
//     ),
//      "/math":(StateManager s)=>Container(), //Math(),

//     "/quotes":(StateManager s)=>Container(), //Quotes(quotesList: s.dataMap["quotes"]["models"],),
//   },
//     "/create":{
//     "/":(StateManager s)=>Container() //CustomizableScreen(),
//   },
// };

// class MultiLineField extends StatelessWidget {
//   TextEditingController _textFieldController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Multi-Line TextField Example'),
//       ),
//       body: Center(
//         child: Padding(
//           //Add padding around textfield
//           padding: EdgeInsets.symmetric(horizontal: 25.0),
//           child: TextField(
//             controller: _textFieldController,
//             //This makes the textfield accept multilines,
//             //when the user taps "enter" button, it moves to the next line
//             keyboardType: TextInputType.multiline,
//             //you can also set this property to specify the Maximun lines the textfield is to take
//             maxLines: 4,
//           ),
//         ),
//       ),
//     );
//   }
// }

//  "row":[
//     {"container_h_${s.h*.95}_w_${s.w*.43}":
//      Shell(comboWave: comboWave,),},
//      {"container_h_${s.h*.95}_w_${s.w*.43}":
//      MainAnimator(model: fourierLines,)
//      }
//     ]});},
// "tiles":List.generate((s.dataMap["quotes"].length/2).floor(), (i)=>
//           CustomWidget2(lib: {
//             "text":s.dataMap["quotes"]["models"][i].calls["formattedText"](),
//           "color":RandomColor.next().withOpacity(0.3)}
//           ).toWidget(dataStr:
//             '''
//             rcb(h:${s.h/10}+w:${s.w/2}_opacity:0.3)~padding(all:8.0)~container(all:10_c:@color)
//             ~center()~@text
//             '''
//           ),
//         ),
// "tiles2":List.generate((s.dataMap["quotes"].length/2).floor(), (i){
//   CustomWidget2(lib: {
//     "text":s.dataMap["quotes"]["models"][i+(s.dataMap["quotes"]["models"].length/2).floor()].calls["formattedText"](),
//   "color":RandomColor.next().withOpacity(0.3)}
//   ).toWidget(dataStr:
//     '''
//     stateful()~padding(all:8.0)~container(all:10_c:@color_w:${double.maxFinite})
//     ~center()~@text
//     '''
//   );
// }),
//]),//, fittedrcb(h:@h_w:@w_l:80_r:100_t:5_b:100_minW:200)
// ~ column()[container(h:50_w:200)~@tm],
// "/":(StateManager s)=> CustomWidget().toWidget(
//   dataIn: {
//      "stack":[
//        {"fitted_h_${s.h}_w_${s.w}_l_80_r_100_t_5_b_100_minW_200":{
//        "column":[
//          {"container_h_50_w_200":TextModel(text: "@@bold@@Curently Reading@@bold@@").toRichText()
//          }, ]
//        }},
//        {"fitted_h_${s.h}_w_${s.w}_l_0_r_100_t_0_b_20":{
//          "center":Text("hello")
//        }
//        }
//      ]
//   })
// ,
/*
 ),
    "/quotes":(StateManager s)=>CustomWidget().toWidget(dataIn: {
      "container_colors_blue":{"column": [
       // {"container_height_50_w_100_color_green":Container()},
        {"expanded":{"row":[
         { "expanded": {
            "padding_all_5": ListView(
                  children: List.generate((s.dataMap["quotes"]["models"].length/2).floor(), (i){
                  //  print(s.dataMap["quotes"]["models"][i].author);
                    return  StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return 
                   Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: RandomColor.next().withOpacity(0.3),
                              border: Border.all(color: Colors.black, width: 2.0)),
                          width: double.infinity,
                          child: Center(
                              child: s.dataMap["quotes"]["models"][i].calls["formattedText"]()
                              )
                      )
                    );
                      });
                  }
                  ))},},
         { "expanded": {"padding_all_5":ListView(
                  children: List.generate((s.dataMap["quotes"]["models"].length/2).floor(), (i){
                     return  StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        //return 
                      
                    return                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: RandomColor.next().withOpacity(0.1),
                      
                              border: Border.all(color: Colors.black, width: 2.0)),
  
                          width: double.infinity,
                          child: Center(
                              child: s.dataMap["quotes"]["models"][i+(s.dataMap["quotes"]["models"].length/2).floor()].calls["formattedText"]()//.formattedTextWidget()
                               )
                      )
                    );
                      });
                  }
                  ))},},
        ]
       }}]
        }}),
*/
// "stack":{
// "fitted_l_5_r_90_t_5_b_100_h_${s.h}_w_${s.w}": {
//   "listView": [
//     {"rcb_h_${s.h*2.0}_w_${s.w*0.8}_all_3.0": {
//       "padding_all_5": {
//         "center":{"container_height_50_width_30_color_red[700]": Text("Hello")}
//       }
//     }}
// ]
// }
// }

//     {"container":
//           Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                   RaisedButton(
//                     color: is3b1b ? Colors.blue: Colors.grey,
//                     onPressed: (){},
//                     child: Text("3b1b Visual"),
//                   ),
//                    RaisedButton(
//                      color: is3b1b ? Colors.grey:Colors.blue,
//                     onPressed: (){},
//                     child: Text("My Visual"),
//                   ),
//                 ]),

// },

//  {
//"fitted_h_${s.h}_w_${s.w}_l_10_r_45_t_15_b_90"://Shell(comboWave: comboWave,)
//   is3b1b?
//  MainAnimator(model: fourierLines,)
//: Shell(comboWave: comboWave,),
// }

//     }
//     },
//      {"fitted_h_${s.h}_w_${s.w}_l_55_r_95_t_5_b_100":{
//         "column":[
//           {"container":
//           }
//         ]
//       }
//     },

//     ]]

// },

// bookList = await dataController.getDataList("book", "assets/book.json");
// quotesList = await dataController.getDataList("quote", "assets/quotes.json");
// bookList.forEach((q){
// _addToDB(q, "books");
// });

// List<CustomModel> bookList = List();
//  List<CustomModel> quotesList = List();
//List<QuoteModel> quotesList = List();

// class MessageList extends StatelessWidget {
//   final Firestore db;
//   MessageList({this.db});

//  // final App a;

//   @override
//   Widget build(BuildContext context) {
//     //print(db)
//     return StreamBuilder<QuerySnapshot>(
//       stream: db.collection('quotes').onSnapshotMetadata,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) return const Text('Loading...');
//         final int messageCount = snapshot.data.docs.length;
//         return ListView.builder(
//           itemCount: messageCount,
//           itemBuilder: (_, int index) {
//             final DocumentSnapshot document = snapshot.data.docs[index];
//             final Map<String, dynamic>  message = document.data();//['quotes'];

//             return ListTile(
//               title: Text(
//                 message != null ? message.toString() : '<No message retrieved>',
//               ),
//               subtitle: Text('Message ${index + 1} of $messageCount'),
//             );
//           },
//         );
//       },
//     );
//   }
// }
