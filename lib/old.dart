
 
//  List tokenize(String dataStr){
//       if(!dataStr.contains("("))return [dataStr];
//       var parIn = [];
//       var parOut =[];
//       for (int i=0; i<dataStr.length; i++){
//         if (dataStr[i]=="(")parIn.add(i);
//         else if (dataStr[i]==")")parOut.add(i);
//       }
//       var end;
//      //print(tokenList);  // Get list of all tokens  // if only one set of par return list spliting it
//       if(parIn.length==1&& parOut.length==1){
//         end = parOut[0];
//         // var name =dataStr.substring(0, parIn[0]);
//         // var info =dataStr.substring(parIn[0]+1, parOut[0]);
//         // var components = [name, info];
//         // if(dataStr.length>parOut[0]+1)components.add(dataStr.substring(parOut[0]+1));
//         //   return components;
//       }else{
//       int u =1; 
//       // if multiple want to find the end par that matches the first par, do so by iterating par list until parout>parin-1 ()()
//       while ((u+1<parIn.length && u<parOut.length) && (parIn[u]<parOut[u-1])){
//         u++;
//       }
//       end = parOut[u-1];
//       if(parIn[u]<end)end=parOut.last;
//       }
//       var name =dataStr.substring(0, parIn[0]);
//       var info =dataStr.substring(parIn[0]+1,end);
//       var components = [name, info];
//       if(dataStr.length>parOut[0]+1)components.add(dataStr.substring(end+1));
//       //print(components);
//       return components;
//   }

//  List<Widget> splitList(String dataStr){
//     if(dataStr=="")return[];

//     if(dataStr.trim()[0]=="[")
//         dataStr = dataStr.substring(dataStr.indexOf("[")+1,dataStr.contains("]")?dataStr.lastIndexOf("]"):dataStr.length);
//     // if(!dataStr.contains(",")){ // print(dataStr);
//     //   //print("GGGG");
//     //     print(trimList(dataStr.split(",")));
//     //   var w= toWidget(dataStr: dataStr);
//     //   return(w is List)?w:[w];
//     // }
//    var splitAllCommas = trimList(dataStr.split(","));
//     //var comm = [];//dataStr.split(",").forEach((f){if(f!="")comm.add(f);});
//     var out=[];
//     int nestedLayer=0;
//     // print("IN");
//     for(int y=0;y<splitAllCommas.length;y++){
//       // if at highest layer, then it should be split otherwise add
//         if(nestedLayer==0) out.add(splitAllCommas[y]);//;print(splitAllCommas[y]);}
//         else out.last+=","+splitAllCommas[y];
//         // update layerof next split
//         if(splitAllCommas[y].contains("]")) nestedLayer-="]".allMatches(splitAllCommas[y]).length;
//         if(splitAllCommas[y].contains("["))  nestedLayer+="[".allMatches(splitAllCommas[y]).length;
//     }//print("OUT"); //print(out);
//     List<Widget> widg=[];
//     out.forEach((widgetDataStr){
//       if(widgetDataStr!=""){
//         var w= toWidget(dataStr: widgetDataStr);
//         if(w is List<Widget>)widg.addAll(w);
//         else widg.add(w);
//       // var w= toWidget(dataStr: dataStr);
//        // widg.add(toWidget(dataStr:widgetDataStr));
//       }
      
//     });
//     return widg;
//   }


  // dynamic tokensToMap(dynamic tok, Map map){
  //   //print("tok"); [l:75_r:90_t:5_b:100_h:@h(frac:0.5)_w:800]
  //   // Splits tokens so that no nested tokens get parsed
  //       var nestedTokensList= tok;
  //       while(nestedTokensList.last.contains("(")){
  //         //print("TOK LAST");//l:75_r:90_t:5_b:100_h:@h(frac:0.5)_w:800
  //         var outerInnerTokens=tokenize(nestedTokensList.last);
  //         //print("Y"); //[l:75_r:90_t:5_b:100_h:@h, frac:0.5, _w:800]
  //         nestedTokensList.last=outerInnerTokens[0];//
  //         if(outerInnerTokens.length>1)nestedTokensList.addAll(outerInnerTokens.sublist(1));
  //       }
  //       // while(tok.last.contains("(")){
  //       //   //print("TOK LAST");//l:75_r:90_t:5_b:100_h:@h(frac:0.5)_w:800
  //       //   var y=tokenize(tok.last);
  //       //   //print("Y"); //[l:75_r:90_t:5_b:100_h:@h, frac:0.5, _w:800]
  //       //   tok.last=y[0];
  //       //   if(y.length>1)tok.addAll(y.sublist(1));
  //       // }
  //       //print("C");
  //       //print(tok);
  //       print("A");
  //       var tokenNameValStrs = trimList(tok[0].split("_"));
  //       //print("OUTM");[l:75, r:90, t:5, b:100, h:@h]
  //       //if(outM.contains("**")){}
  //       print("B");
  //       for(int r=0; r<tokenNameValStrs.length;r++){
  //         var nameValPair = trimList(tokenNameValStrs[r].split(":"));
  //         if(nameValPair.length<2)nameValPair.add("");
  //         map[nameValPair[0]]=nameValPair[1];
  //       //  map[outM[r].split(":")[0]]=(outM[r].split(":").length>1)?outM[r].split(":")[1]:"";
  //       }
  //       print("C");
  //       var i=1;
  //       try{
  //       while(nestedTokensList.length>i){
  //         var nameValPair = trimList(tokenNameValStrs.last.split(":"));
  //         map[nameValPair[0]]+= "("+nestedTokensList[i]+")";
  //         i++;
  //         if(nestedTokensList.length>i){
  //           tokenNameValStrs = trimList(nestedTokensList[i].split("_"));
  //           //outM = tok[i].split("_");
  //             for(int r=0; r<tokenNameValStrs.length;r++){
  //             var nameValPair = trimList(tokenNameValStrs[r].split(":"),skipEmpty:false);
  //             if(nameValPair[0]!=""){
  //               if(nameValPair.length<2)nameValPair.add("");
  //               map[nameValPair[0]]=nameValPair[1];

  //             }
              
  //             //if(outM[r].split(":")[0]!="")
  //              // map[outM[r].split(":")[0]]=(outM[r].split(":").length>1)?outM[r].split(":")[1]:"";
  //           }
  //           // for(int r=0; r<outM.length;r++){
  //           //   if(outM[r].split(":")[0]!="")
  //           //     map[outM[r].split(":")[0]]=(outM[r].split(":").length>1)?outM[r].split(":")[1]:"";
  //           // }
  //         }
  //         i++;
  //       }
  //       }catch(e){}
  //      // if(map.isNotEmpty) print(map);
  //       return map;
  // }
  //   List tokenize(String dataStr){
  //     if(!dataStr.contains("("))return [dataStr];

  //   var tokenIndicies =[];
  //     var tokenI=["[", "]", "~", "(", ")", "_", ":", "@"];
  //     var tokenList={"[":[], "]":[], "~":[], "(":[], ")":[], "_":[], ":":[], "@":[]};
  //     for (int i=0; i<dataStr.length; i++)
  //       if (tokenList.containsKey(dataStr[i])){tokenList[dataStr[i]].add(i);tokenIndicies.add(tokenI.indexOf(dataStr[i]));}
  //    // print(tokenList);
  //    // Get list of all tokens
  //     var parIn = tokenList["("];
  //     var parOut = tokenList[")"];
  //     // if only one set of par return list spliting it
  //     if(parIn.length==1&& parOut.length==1){
  //       var lst = [dataStr.substring(0, parIn[0]), dataStr.substring(parIn[0]+1, parOut[0])];
  //       if(dataStr.length>parOut[0]+1)lst.add(dataStr.substring(parOut[0]+1));
  //         return lst;
  //     }
  //     int u =1; 
  //     // if multiple want to find the end par that matches the first par, do so by iterating par list until parout>parin-1 ()()
  //     while ((u+1<parIn.length && u<parOut.length) && (parIn[u]<parOut[u-1])){
  //       u++;
  //     }
  //     var lastPar= parIn[u];
  //     var end = parOut[u-1];
  //     if(lastPar<end)end=parOut.last;
  //     var lst = [dataStr.substring(0, parIn[0]), dataStr.substring(parIn[0]+1, end)];
  //     if(dataStr.length>end+1)lst.add(dataStr.substring(end+1));
  //     return lst;
  // }
 

 // List<Widget> splitList2(String dataStr){
  //   print("INN");
  //   print(dataStr);
  //    if(!dataStr.contains("["))return null;
  //   var tokenIndicies =[];
  //     var tokenI=["[", "]", "~", "(", ")", "_", ":", "@"];
  //     var tokenList={"[":[], "]":[], "~":[], "(":[], ")":[], "_":[], ":":[], "@":[]};
  //     for (int i=0; i<dataStr.length; i++)
  //       if (tokenList.containsKey(dataStr[i])){tokenList[dataStr[i]].add(i);tokenIndicies.add(tokenI.indexOf(dataStr[i]));}
  //    // print(tokenList);
  //    // Get list of all tokens
  //     var parIn = tokenList["["];
  //     var parOut = tokenList["]"];
  //     // if only one set of par return list spliting it
  //     if(parIn.length==1&& parOut.length==1){
  //       print("HI");
  //       var lst = [dataStr.substring(0, parIn[0]), dataStr.substring(parIn[0]+1, parOut[0])];
  //       if(dataStr.length>parOut[0]+1)lst.add(dataStr.substring(parOut[0]+1));
  //        List<Widget> widg=[];
  //        lst[1].split(",").forEach((f){
  //           widg.add(toWidget(dataStr:f));
  //        });
  //        return widg;
  //     }

  //     int u =1; 
  //     // if multiple want to find the end par that matches the first par, do so by iterating par list until parout>parin-1 ()()
      
  //     while ((u+1<parIn.length && u<parOut.length) && (parIn[u]<parOut[u-1])){
  //       print(u);
  //       // if(parIn[u]>parOut[u] ){//&& dataStr.substring(parOut[u], parIn[u]).contains(",")){
  //       //   print("HHEEYY");
  //       //   print(dataStr.substring(parOut[u], parIn[u]));
  //       // }
  //       u++;
  //     }
  //     // var lastPar= parIn[u];
  //     // var end = parOut[u-1];
  //     // if(lastPar<end)end=parOut.last;
  //     // var lst = [dataStr.substring(0, parIn[0]), dataStr.substring(parIn[0]+1, end)];
  //     // if(dataStr.length>end+1)lst.add(dataStr.substring(end+1));
    
  //     List<Widget> widg=[];
  // //     lst.forEach((u){
  // //          print(u);
  // //    widg.add(toWidget(dataStr:u));
  // //  });
  //  return widg;
  // }
  // // Splits widgets
  // dynamic addChildrenToMap(dynamic tok, Map map){
  //       tok= tok.trim();
  //      if(tok[0]=="["){
  //       map["children"]=splitList(tok);
  //      }
  //      else if (tok[0]=="~"){
  //        map["child"]=toWidget(dataStr:tok.substring(1));
  //      }
  // }


     //  var childrenData = stems[2].trim();
      //  if(childrenData[0]=="["){
      //   map["children"]=splitList(childrenData);
      //    children=map["children"];
      //  }
      //  else if (childrenData[0]=="~"){
      //    map["child"]=toWidget(dataStr:childrenData.substring(1));
      //    children=map["child"];
      //  }
      //print("JJJ");
      //   var tok = [stems[1]];
      //   while(tok.last.contains("(")){
      //   //  print(tok.last);
      //     var y=tokenize(tok.last);
      //     tok.last=y[0];
      //     if(y.length>1)tok.addAll(y.sublist(1));
      //     //stems[1].substring(0, stems.indexOf("_"));
      //   }
      //   var outM = tok[0].split("_");
        
      //   for(int r=0; r<outM.length;r++){
      //     map[outM[r].split(":")[0]]=(outM[r].split(":").length>1)?outM[r].split(":")[1]:"";
      //   }
      //   var i=1;
      //   try{
      //   while(tok.length>i){
      //     map[outM.last.split(":")[0]]+= "("+tok[i]+")";
      //     i++;
      //     if(tok.length>i){
      //       outM = tok[i].split("_");
      //       for(int r=0; r<outM.length;r++){
      //         if(outM[r].split(":")[0]!="")
      //           map[outM[r].split(":")[0]]=(outM[r].split(":").length>1)?outM[r].split(":")[1]:"";
      //       }
      //     }
      //     i++;
      //   }
      //   }catch(e){}
      //   if(map.isNotEmpty) print(map);
      //   // TODO parse any special tokens like widgets
      // // TODO parsing any calls
    // out.add(comm[y]);
      // if(comm[y].contains("[") && !comm[y].contains("]"))
      // i++;

      // {
      //   i+=1;
      //   y++;
      //  while(y<comm.length && i!=0) {
      //    print(i);
      //    if(comm[y].contains("]"))i--;
      //    if(comm[y].contains("["))i++;
      //    print(i);
      //    if(i==0) out.add(comm[y]);
      //    else out.last+=","+comm[y];
      //    y++;
      //  }
      //  //if(y<comm.length && i!=0)out.last+=","+comm[y];
      //  if(y<comm.length)out.addAll(comm.sublist(y));
    //  }
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
    // if(uri!=null){
    //   var response = await (await _http.getUrl(uri)).close();
    //   var transformedResponse = await response.transform(utf8.decoder).join();
    //   return json.decode(transformedResponse);
    // }
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
