

import 'package:flutter/material.dart';
import 'package:portfolio3/custom_makers/model_maker.dart';
import 'package:portfolio3/mydata/textdata.dart';
import 'package:portfolio3/secrets.dart';
import 'package:portfolio3/state_manager.dart';
import 'package:portfolio3/utils/main_animator.dart';

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
     "/quotes": "listView()[@forEach(models:@data(name:quotes))]"//_widget:padding(all:8)~container(all:8_color:green200)~center()
  }
};
Map<String, dynamic> myLib = {
  "vars":()=>{
    "hello":Text("hello"),

  },
  "functions":(StateManager s)=>{
    "h":(var tokens)=> (tokens.containsKey("frac"))?s.h*double.tryParse(tokens["frac"])??1.0:s.h,
    "w":(var tokens)=> (tokens.containsKey("frac"))?s.w*double.tryParse(tokens["frac"])??1.0:s.w,
    // fourierLines(stepPerUpdate:2.5_thickness:8)
    "data":(var tokens){
      print(tokens);
      if(tokens.containsKey("name") && s.dataMap.containsKey(tokens["name"])){
        return s.dataMap[tokens["name"]]["models"];
      }
      return [];
    },
    "forEach":(var tokens){
      List<Widget> out=[];
      String str = tokens.containsKey("widget")? tokens["widget"]+"~":"";
      print(str);
      if(tokens.containsKey("models")){
        tokens["models"].forEach((m){
        if(m is String) {print("m");}//m=CustomModel.fromLib(m)};
        if(m is CustomModel){    
            if(m.calls.containsKey("toStr"))out.add(s.customWidget.toWidget(dataStr:str+m.calls["toStr"]()));
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
                "category":1,
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