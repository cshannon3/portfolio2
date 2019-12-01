

import 'package:flutter/material.dart';
import 'package:portfolio3/custom_makers/w2.dart';
import 'package:portfolio3/utils/utils.dart';

class JsonToDataModel extends StatefulWidget {
  final  dynamic json;

  const JsonToDataModel({Key key, this.json}) : super(key: key);
  @override
  _JsonToDataModelState createState() => _JsonToDataModelState();
}

class _JsonToDataModelState extends State<JsonToDataModel> {
  var controllerMap={
    "scriptText":TextEditingController()
  };
  CustomWidget2 customWidget;
  @override
  void initState() {
    super.initState();
     customWidget = CustomWidget2(
      // lib: {"json":widget.json},
        calls: tempJsonLib["functions"](this));
  }
  @override
  Widget build(BuildContext context) {
    var l = widget.json.keys.toList();
    return (widget.json=={})?Container :customWidget.toWidget(
      libIn: {"json":widget.json},
      dataStr: '''
      container()~column()[
        @forEach(items:@json),
                       padding(l:5_r:5)~row()[
                          container()~text(text:Name),
                          expanded()~container()
                                ~textField(controller:@getController(name:dataModelName_type:text)),
                                raisedButton()~text(text:Save)
                        ],
                        container()~text(text:Widget),
                        textField(controller:@getController(name:dataWidgetScript_type:text)),
                        raisedButton()~text(text:Preview),
                        raisedButton()~text(text:Save Model)
                          
      ]
      '''
    );
    // return Container(
    // child: Column(children: List.generate(l.length, (i){
    //   return Text(l[i]);
    // }),),
    // );
  }
}

Map<String, dynamic> tempJsonLib = {
  "vars":()=>{
    "hello":Text("hello"),

  },
  "functions":(dynamic s)=>{
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
      if(tokens.containsKey("items")){
       // if(tokens["items"] is Map){
          tokens["items"].forEach((k, v){
              if(v is Map) {
               
                out.add( 
                ExpansionTile(
                  title: Text(k),
                  children:s.customWidget.calls["forEach"]({"items":v})
                ));
              }
               else if(v is List) {
                 //return Container();
              }
              else
               out.add(ListTile(
                leading: Text("$k: "),
                title: Text(v.toString()),
                trailing: IconButton(icon: Icon(Icons.add),onPressed: (){},),
                ));
          });
       // }
        
      }
     // print(out);
      return out;
    },
  }
};