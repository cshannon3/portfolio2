

import 'package:flutter/material.dart';
import 'package:portfolio3/custom_makers/model_maker.dart';
import 'package:portfolio3/custom_makers/w2.dart';
import 'package:portfolio3/mydata/textdata.dart';
import 'package:portfolio3/secrets.dart';
import 'package:portfolio3/state_manager.dart';
import 'package:portfolio3/utils/main_animator.dart';
import 'package:portfolio3/utils/utils.dart';
import 'package:portfolio3/googleclient/client.dart' as commons;
import 'package:http/http.dart' as http;
import 'package:portfolio3/googleclient/requests.dart' as req;
import 'package:googleapis/docs/v1.dart' as docs;
//editable(l:0_r:30_t:0_b:80)~container(h:100_w:max_c:blue),
Map<String, dynamic> routesStr = {
   "/":'''stack()
    [
      fitted(l:5_r:95_t:5_b:95_h:@h()_w:@w())~listView()[
        fitted(l:5_r:95_t:5_b:35_h:@h()_w:@w()_type:list)~stack()[
        container(h:300_w:max)~image(path:assets/images/co.jpg_fit:width),
        container()~center()~customText(text:#bold##size30##italic#Welcome)
        ],
        container(h:100_w:max_c:blue)
        ],
        draggable(l:20_r:40_t:10_b:60)~customText(text:#bold##size25##italic#Physics Box)
     ]
   
   ''',
  "/play":{
    "/": "center()~column()[container(h:150_w:100_color:blue),container(h:50_w:100_color:blue300)~@hello]",
    "/fourier":'''row()[
          expanded()~container(h:@h(frac:0.95)_w:@w(frac:0.43))~animator(model:@combowave),
          expanded()~container(h:@h(frac:0.95)_w:@w(frac:0.43))~@fl()
        ]'''
  },
  '/learn':{
    "/":
    '''stack()[
      fittedrcb(l:5_r:90_t:5_b:100_h:@h_w:@w)
            ~padding(all:5)~center()
              ~container(h:50_w:30_color:red)
                ~@hello
    ]
    ''',
    "/docs":'''stack()[
       fitted(l:0_r:90_t:5_b:100_h:@h_w:@w)
       ~listView()[
            @forEach(models:@data(name:googleDocs)_widget:
                (padding(all:4)~container(c:blue200_bColor:black_bWidth:4.0))
                )
          ]
      ]''',
     "/quotes": '''stack()[
       fitted(l:0_r:30_t:5_b:100_h:@h_w:@w)
       ~listView()[
            @forEach(models:@data(name:quotes)_widget:
                (padding(all:4)~container(c:blue200_bColor:black_bWidth:4.0))
                )
          ]
      ]'''//_widget:padding(all:8)~container(all:8_color:green200)~center()
  }
};
Map<String, dynamic> myLib = {
  "vars":()=>{
    "hello":Text("hello"),

  },
  "functions":(StateManager s)=>{
    "h":(var tokens)=> (tokens.containsKey("frac"))?s.screenSize.height*double.tryParse(tokens["frac"])??1.0:s.screenSize.height,
    "w":(var tokens){ 
      var w = s.editorOpen?s.screenSize.width*2/3:s.screenSize.width;
      return (tokens.containsKey("frac"))?w*double.tryParse(tokens["frac"])??1.0:w;
    },
    "data":(var tokens){
      if(!tokens.containsKey("name"))return [];
      var name = tokens["name"];
      if(s.dataController.apiModels.containsKey(name))
        return s.dataController.apiModels[tokens["name"]].vars["models"];
      if(s.dataController.firebaseModels.containsKey(name))
          return s.dataController.firebaseModels[tokens["name"]].vars["models"];
      if(s.dataController.googleAPIModels.containsKey(name)){
        print("HRRRR");
        var m= s.dataController.googleAPIModels[tokens["name"]].vars["models"];
        print(m.length);
        return m;
      }
    
      //  {
      //   s.dataController.dataMap.containsKey(tokens["name"])){
      //   return s.dataController.dataMap[tokens["name"]]["models"];
      //   }
      // }
      return [];
    },
    "getVar":(var tokens){
      var name = ifIs(tokens, "name");
      if(name==null)return null;
      // switch(name){
      //   case "jsonData":
      //   return s.jsonData;
      //   break; // }// return null;
    },
    "getController":(var tokens){
      var name = ifIs(tokens, "name");
      if(name==null)return null;
      var type = ifIs(tokens, "type");
      if(s.controllerMap.containsKey(name))return s.controllerMap[name];
      if(type==null)return null;
      switch (type){
        case "text": 
          s.controllerMap[name]=TextEditingController(); 
          return s.controllerMap[name];
          break;
      }return null;
    },
    "disposeControllers":(var tokens){
      s.controllerMap.forEach((k,v){
        try{ v.dispose(); }catch(e){} });
    },
    "forEach":(var tokens){
      List<Widget> out=[];
      String str = ifIs(tokens, "widget")??"";
      if(str!=""){
        str=str.substring(str.indexOf("(")+1, str.lastIndexOf(")"))+"~";
      }
      // print("FOREAch");
      // print(str);
      if(tokens.containsKey("models")){
        tokens["models"].forEach((m){
          print(m.vars);
        if(m is String) {print("m");}//m=CustomModel.fromLib(m)};
        if(m is CustomModel){    
            if(m.calls.containsKey("toStr")){
              var widg;
              try{widg=s.customWidget.toWidget(dataStr:str+m.calls["toStr"]());}
              catch(e){widg=s.customWidget.toWidget(dataStr:m.calls["toStr"]());}
              out.add(widg);
            }
            else if(m.calls.containsKey("toWidget"))out.add(m.calls["toWidget"]());
            if(m.calls.containsKey("toWidgetList"))out.addAll(m.calls["toWidgetList"]());
        }
        });
      }
      return out;
    },
        "fl":(var tokens){
        CustomModel fourierLines = CustomModel.fromLib(
            {"name":"fourierLines",
            "vars":{ "stepPerUpdate":2.5,"thickness":8.0,}} );
            fourierLines.calls["squareWave"](numoflines:5, line1Len:100.0);
          return MainAnimator(model: fourierLines,);
      },
    "fl2":(var tokens){
        CustomModel fourierLines = CustomModel.fromLib("fourierLines_stepPerUpdate_2.5_thickness_8.0");
            fourierLines.calls["squareWave"](numoflines:5, line1Len:100.0);
          return fourierLines;//MainAnimator(model: ,);
      },
      "getText":(var tokens)=>sampleText["Gettysburg Address"],
  },
};

//  Map<String, dynamic> dataMap={
//   //  "books":{"name":"book", "collection_name": "books", "models":[],},
//     "quotes":{"name":"quote", "collection_name": "quotes", "models":[],}
//    // "blogs":{"name":"blog", "collection_name": "blogs", "models":[],}
//   };



// Map<String, dynamic> dMap={
//   "firebase":{
//           "vars":(var tokens)=>{
//                  "firestore":tokens["firestore"], 
//               },
//             "functions":(CustomModel self)=>{
//               "getData":(var tokens) async{
//                 if(!tokens.containsKey("firestore"))return [];
//                // bool toCustomModel = true; //ifIs("")
//                 tokens["firestore"].collection(self.vars["collection_name"])
//                       .onSnapshotMetadata
//                       .listen((onData) {
//                     var l = [];
//                     onData.docs.forEach((dataItem) {
//                         try {
//                           l.add(CustomModel.fromLib({"name": self.vars["name"], "vars": dataItem.data()}));
//                         } catch (e) {
//                           print(dataItem.data());print("err");}
//                     });
//                     return l;
//                   });
//               }
//             }
//   },
//   "googleAPI":{
//           "vars":(var tokens)=>{
//                  "client":tokens["client"]
//               },
//       "functions":(CustomModel self)=>{
//         "customGetData":(var tokens){
//         },
//         "getData":(var tokens) async { 
//                 commons.ApiRequester _requester= 
//                 commons.ApiRequester(c,self.vars["baseUrl"],"",self.vars["dartClient"]);
//                 self.calls["customGetData"]({"requester":_requester});
//                 }
//               }
//           }
//   };


Map<String, dynamic> dataMap={
  "quotes":{
      "type":"firebase",
      "vars":(var tokens)=>{
                 "name":"quote", 
                  "collection_name": "quotes", 
                  "models":[],
              },
            "functions":(CustomModel self)=>{
              "getData":(var tokens) async{
                if(!tokens.containsKey("firestore"))return;
               // bool toCustomModel = true; //ifIs("")
                tokens["firestore"].collection(self.vars["collection_name"])
                      .onSnapshotMetadata
                      .listen((onData) {
                    var l = [];
                    onData.docs.forEach((dataItem) {
                        try {
                          l.add(CustomModel.fromLib({"name": self.vars["name"], "vars": dataItem.data()}));
                        } catch (e) {
                          print(dataItem.data());print("err");}
                    });
                    self.vars["models"]=l;
                  });
              }
            }
    },
    "googleDocs":{
      "type":"googleAPI",
      "vars":(var tokens)=>{
                 "name":"googleDocs", 
                  "sampleDocs": {
                    "Gettysburg Address":"16wLizatyKJVH4x0Zpz2wVoeUYAcxbmsvJ2xJsAKOBfE",
                    //"I Have A Dream":"1-0TRJYy0dsDTbzXZHVEBRVOC8BiWv9_34IgyrX7Zn8w",
                    "Declaration of Independence":"1mtPVlFVytbsYJ8VONrRGfEXnzFfEavF9dbQQmakYOWg",
                    //"Finest Hour":"1WOx1ro53mE8YiOH_iOfMY0UqiOD3KAIV3mGovb_ZE2o"
                  },
                  "models":[],
                  "api":null,
                  "dartClient":'dart-api-client docs/v1',
                  "baseUrl":"https://docs.googleapis.com/",
                  "scopes":[]
              },
      "functions":(CustomModel self)=>{
        "getData":(var tokens) async {
                     var _url;
                          var _body;
                if(tokens.containsKey("client")){
                  http.Client cl = tokens["client"];
                  commons.ApiRequester _requester= 
                  commons.ApiRequester(cl,"https://docs.googleapis.com/","",'dart-api-client docs/v1');
                  //self.vars["api"]=
                  //docs.DocsApi(tokens["client"]);
                  
                //}//else if (self.vars["api"]==null)return;
          // var l=[];
                self.vars["sampleDocs"].forEach((docTitle,documentId){
                      if (documentId == null) {
                              throw new ArgumentError("Parameter documentId is required.");
                            }
                          var _queryParams = new Map<String, List<String>>();
                          var _uploadMedia;
                          var _uploadOptions;
                          var _downloadOptions = req.DownloadOptions.Metadata;
                            _url = 'v1/documents/' + commons.Escaper.ecapeVariable('$documentId');

                        var _response = _requester.request(_url, "GET",
                            body: _body,
                            queryParams: _queryParams,
                            uploadOptions: _uploadOptions,
                            uploadMedia: _uploadMedia,
                            downloadOptions: _downloadOptions);
                        return _response.then((docData) {
                  // self.vars["api"].documents.get(docId).then((docData){

                          print(docTitle);
                          var txt = self.calls["parseData"]({"data":docData});
                          CustomModel cm = CustomModel.fromMap({
                              "vars":(var tokens)=>{
                                "title":docTitle,
                                "text": txt
                              },
                              "functions":(CustomModel me)=>{
                                "toStr":(var tokens)=> '''customText(text:${me.vars["text"]})'''
                              }
                            });
                            self.vars["models"].add(cm);
                            print(self.vars["models"].last.vars["title"]);

                      });
              });
             // self.vars["models"]=l;
              
                }
                return ;
        },
        "parseData":(var tokens){
          if(!tokens.containsKey("data"))return null;
            var data = tokens["data"];
            var content = checkPath(data, ["body", "content"]);
            if(!content[0])return null;
                String out="";
                bool italic= false;
                bool bold= false;
                String fontType = "normal";
                String fontFamily;
                int fontWeight=400;
                int fontsize = 10;
            content[1].forEach((cont){
              var elements = checkPath(cont, ["paragraph", "elements"]);
              if(elements[0] && elements[1] is List)
                  elements[1].forEach((t){
                      var cont = t["textRun"]["content"];
                      var ts = t["textRun"]["textStyle"];
                      String nFront="";
                      if(ts.containsKey("italic") && ts["italic"] && !italic){
                          fontType="italic";
                          nFront+="#italic#"; italic=true;}
                        else if (!ts.containsKey("italic") && italic){
                          nFront+="#normal#";
                          fontType="normal";
                          italic=false;
                        }
                        if(ts.containsKey("bold") && ts["bold"] && !bold){
                          fontWeight=700;
                          nFront+="#fw$fontWeight#"; bold=true;}
                        else if (!ts.containsKey("bold") && bold){
                          fontWeight=400;
                          nFront+="#fw$fontWeight#";
                          bold=false;
                        }
                        var font= checkPath(ts, ["fontSize", "magnitude"]);
                        if(font[0] &&font[1]!=fontsize){
                        // ts.containsKey("fontSize") && ts["fontSize"].containsKey("magnitude") &&ts["fontSize"]["magnitude"]!=fontsize){
                          fontsize=ts["fontSize"]["magnitude"];
                          nFront+="#size$fontsize#"; }       
                        var ffam= checkPath(ts, ["weightedFontFamily", "fontFamily"]);
                        if(ffam[0] && fonts.containsKey(ffam[1])){
                          if(ffam[1]!=fontFamily && fonts[ffam[1]][fontType].contains(fontWeight)){
                            fontFamily=ffam[1];
                          nFront+="#fontfam$fontFamily#"; }
                      } 
                        out+= nFront+cont;//+nBack;
                  });

            });
            return out;
            }
            }
    },

    "crypto":{
          "type":"api",
              "vars":(var tokens)=>{
                "name":"crypto", 
                "key": "", 
                "url": "https://api.coinmarketcap.com/v1/ticker/",
                "endpoints":["coin"],
                "currentEndpoint":"coin",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=> "${self.vars["url"]}"
              }
        },
    "weather":{
      "type":"api",
              "vars":(var tokens)=>{
                "name":"weather", 
                "key": secrets["weatherAPI"], 
                "url": "http://api.openweathermap.org/data/2.5/",
                "endpoints":["weather", "forcast"],
                "currentEndpoint":"weather",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=> "${self.vars["url"]}${self.vars["currentEndpoint"]}?id=524901&APPID=${self.vars["key"]}"
              }
        },
    "trivia":{
      "type":"api",
       "vars":(var tokens)=>{
                "name":"trivia", 
                "key": "",
                "url": "https://opentdb.com/api.php",
                "amount":10,
                "category":18,
                "endpoints":["questions"],
                "currentEndpoint":"questions",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=> "${self.vars["url"]}?amount=${self.vars["amount"]}&category=${self.vars["category"]}"
              }
      },
    "pixabay":{
      "type":"api",
       "vars":(var tokens)=>{
                "name":"pixabay", 
                "key": secrets["pixabayAPI"],
                "url": "https://pixabay.com/api/",
                "count":10,
                "endpoints":["images"],
                "currentEndpoint":"images",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=> "${self.vars["url"]}?key=${self.vars["key"]}&editors_choice=true&per_page=${self.vars["count"]}&orientation=vertical"
              }
      },
    "news":{
      "type":"api",
             "vars":(var tokens)=>{
                "name":"news", 
                "key": secrets["newsAPI"],
                "url": "https://newsapi.org/v2/",
                "endpoints":["everything", "top-headlines", "sources"],
                "currentEndpoint":"everything",
              },
              "functions":(CustomModel self)=>{
                "getUrl":(){
                   var url = "${self.vars["url"]}${self.vars["currentEndpoint"]}?apiKey=${self.vars["key"]}";
                   if(self.vars["currentEndpoint"]=="everything")url+="&pageSize=10&q=us";
                   else if (self.vars["currentEndpoint"]=="top-headlines")url+="&country=US";
                   return url;
                }
              }
  
      },
    "giphy":{
      "type":"api",
       "vars":(var tokens)=>{
                "name":"weather", 
                "key": secrets["Giphy"],
                "url": "https://api.giphy.com/v1/gifs/",
                "endpoints":["random"],
                "currentEndpoint":"random",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=>"${self.vars["url"]}${self.vars["currentEndpoint"]}?apiKey=${self.vars["key"]}&tag=&rating=G"
              }
    },
    "musixmatch":{
      "type":"api",
        "vars":(var tokens)=>{
                "name":"weather", 
                "key": secrets["musixmatch"],
                "url": "https://newsapi.org/v2/",
                "endpoints":["everything"],
                "currentEndpoint":"weather",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=> "${self.vars["url"]}${self.vars["currentEndpoint"]}?apiKey=9d206d9be4174155bf59edb914ce4101&pageSize=10&q=us?id=524901&APPID=${self.vars["key"]}"
              }
      },

  };
  // Map<String, dynamic> apiMap={
  //   "crypto":{
  //             "vars":(var tokens)=>{
  //               "name":"crypto", 
  //               "key": "", 
  //               "url": "https://api.coinmarketcap.com/v1/ticker/",
  //               "endpoints":["coin"],
  //               "currentEndpoint":"coin",
  //             },
  //             "functions":(CustomModel self)=>{
  //               "getUrl":()=> "${self.vars["url"]}"
  //             }
  //       },
  //   "weather":{
  //             "vars":(var tokens)=>{
  //               "name":"weather", 
  //               "key": secrets["weatherAPI"], 
  //               "url": "http://api.openweathermap.org/data/2.5/",
  //               "endpoints":["weather", "forcast"],
  //               "currentEndpoint":"weather",
  //             },
  //             "functions":(CustomModel self)=>{
  //               "getUrl":()=> "${self.vars["url"]}${self.vars["currentEndpoint"]}?id=524901&APPID=${self.vars["key"]}"
  //             }
  //       },
  //   "trivia":{
  //      "vars":(var tokens)=>{
  //               "name":"trivia", 
  //               "key": "",
  //               "url": "https://opentdb.com/api.php",
  //               "amount":10,
  //               "category":18,
  //               "endpoints":["questions"],
  //               "currentEndpoint":"questions",
  //             },
  //             "functions":(CustomModel self)=>{
  //               "getUrl":()=> "${self.vars["url"]}?amount=${self.vars["amount"]}&category=${self.vars["category"]}"
  //             }
  //     },
  //   "pixabay":{
  //      "vars":(var tokens)=>{
  //               "name":"pixabay", 
  //               "key": secrets["pixabayAPI"],
  //               "url": "https://pixabay.com/api/",
  //               "count":10,
  //               "endpoints":["images"],
  //               "currentEndpoint":"images",
  //             },
  //             "functions":(CustomModel self)=>{
  //               "getUrl":()=> "${self.vars["url"]}?key=${self.vars["key"]}&editors_choice=true&per_page=${self.vars["count"]}&orientation=vertical"
  //             }
  //     },
  //   "news":{
  //            "vars":(var tokens)=>{
  //               "name":"news", 
  //               "key": secrets["newsAPI"],
  //               "url": "https://newsapi.org/v2/",
  //               "endpoints":["everything", "top-headlines", "sources"],
  //               "currentEndpoint":"everything",
  //             },
  //             "functions":(CustomModel self)=>{
  //               "getUrl":(){
  //                  var url = "${self.vars["url"]}${self.vars["currentEndpoint"]}?apiKey=${self.vars["key"]}";
  //                  if(self.vars["currentEndpoint"]=="everything")url+="&pageSize=10&q=us";
  //                  else if (self.vars["currentEndpoint"]=="top-headlines")url+="&country=US";
  //                  return url;
  //               }
  //             }
  
  //     },
  //   "giphy":{
  //      "vars":(var tokens)=>{
  //               "name":"weather", 
  //               "key": secrets["Giphy"],
  //               "url": "https://api.giphy.com/v1/gifs/",
  //               "endpoints":["random"],
  //               "currentEndpoint":"random",
  //             },
  //             "functions":(CustomModel self)=>{
  //               "getUrl":()=>"${self.vars["url"]}${self.vars["currentEndpoint"]}?apiKey=${self.vars["key"]}&tag=&rating=G"
  //             }
  //   },
  //   "musixmatch":{
  //       "vars":(var tokens)=>{
  //               "name":"weather", 
  //               "key": secrets["musixmatch"],
  //               "url": "https://newsapi.org/v2/",
  //               "endpoints":["everything"],
  //               "currentEndpoint":"weather",
  //             },
  //             "functions":(CustomModel self)=>{
  //               "getUrl":()=> "${self.vars["url"]}${self.vars["currentEndpoint"]}?apiKey=9d206d9be4174155bf59edb914ce4101&pageSize=10&q=us?id=524901&APPID=${self.vars["key"]}"
  //             }
  //     },

  // };