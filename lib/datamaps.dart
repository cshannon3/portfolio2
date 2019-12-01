

import 'package:flutter/material.dart';
import 'package:portfolio3/custom_makers/model_maker.dart';
import 'package:portfolio3/custom_makers/w2.dart';
import 'package:portfolio3/mydata/textdata.dart';
import 'package:portfolio3/secrets.dart';
import 'package:portfolio3/state_manager.dart';
import 'package:portfolio3/utils/main_animator.dart';
import 'package:portfolio3/utils/utils.dart';

Map<String, dynamic> routesStr = {
   "/":'''stack()
    [
      fitted(l:75_r:90_t:5_b:100_h:@h(frac:0.5)_w:800)~
          container(h:50_w:30_color:red)~@hello,
        fittedrcb(l:5_r:60_t:5_b:100_h:@h()_w:@w())~column()[
                      container(color:green)~center()~customText(text:@getText()),
                      container(h:50_w:60_color:red)~richText(text:textSpan(text:Hi))
                    ]                       
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
    "w":(var tokens)=> (tokens.containsKey("frac"))?s.screenSize.width*double.tryParse(tokens["frac"])??1.0:s.screenSize.width,
    "data":(var tokens){
      print(tokens);
      if(tokens.containsKey("name") && s.dataController.dataMap.containsKey(tokens["name"])){
        return s.dataController.dataMap[tokens["name"]]["models"];
      }
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
      print("FOREAch");
      print(str);
      if(tokens.containsKey("models")){
        tokens["models"].forEach((m){
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
      "getText":(var tokens)=>sampleText["math1"],
  },
};

 Map<String, dynamic> dataMap={
  //  "books":{"name":"book", "collection_name": "books", "models":[],},
    "quotes":{"name":"quote", "collection_name": "quotes", "models":[],}
   // "blogs":{"name":"blog", "collection_name": "blogs", "models":[],}
  };
    Map<String, dynamic> apiMap={
    "crypto":{
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