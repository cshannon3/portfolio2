import 'package:flutter/material.dart';
import 'package:portfolio3/custom_libs/default_widgets_lib.dart';
import 'package:portfolio3/custom_libs/mywidgets.dart';
import 'package:portfolio3/custom_makers/model_maker.dart';
// import 'package:portfolio3/utils/dynamic_parsers.dart';
// import 'package:portfolio3/utils/random.dart';
// import 'package:portfolio3/utils/utils.dart';

class CustomWidget2 {
  Map<String, dynamic> lib;
  var calls;
  var tempLib={};


  CustomWidget2({
    this.lib, 
    this.calls
  });
    List tokenize(String dataStr){
      if(!dataStr.contains("("))return [dataStr];
      var parIn = [];
      var parOut =[];
      for (int i=0; i<dataStr.length; i++){
        if (dataStr[i]=="(")parIn.add(i);
        else if (dataStr[i]==")")parOut.add(i);
      }
     // print(tokenList);
     // Get list of all tokens  // if only one set of par return list spliting it
      if(parIn.length==1&& parOut.length==1){
        var name =dataStr.substring(0, parIn[0]);
        var info =dataStr.substring(parIn[0]+1, parOut[0]);
        var components = [name, info];
        if(dataStr.length>parOut[0]+1)components.add(dataStr.substring(parOut[0]+1));
          return components;
      }
      int u =1; 
      // if multiple want to find the end par that matches the first par, do so by iterating par list until parout>parin-1 ()()
      while ((u+1<parIn.length && u<parOut.length) && (parIn[u]<parOut[u-1])){
        u++;
      }
      var lastPar= parIn[u];
      var end = parOut[u-1];
      if(lastPar<end)end=parOut.last;

      var name =dataStr.substring(0, parIn[0]);
      var info =dataStr.substring(parIn[0]+1,end);
      var components = [name, info];
      if(dataStr.length>parOut[0]+1)components.add(dataStr.substring(end+1));
        return components;
  }
 
  List<Widget> splitList(String dataStr){

    if(dataStr=="")return[];
    if(dataStr.trim()[0]=="[")
        dataStr = dataStr.substring(dataStr.indexOf("[")+1,dataStr.contains("]")?dataStr.lastIndexOf("]"):dataStr.length);

    if(!dataStr.contains(",")){ // print(dataStr);
      var w= toWidget(dataStr: dataStr);
      return(w is List)?w:[w];
      }

   var comm = [];
   dataStr.split(",").forEach((f){if(f!="")comm.add(f);});
   var out=[];
   int i=0;
  // print("IN");
   for(int y=0;y<comm.length;y++){
       //print(comm[y]);
      if(i==0) {out.add(comm[y]);print(comm[y]);}
      else out.last+=","+comm[y];
      if(comm[y].contains("]"))i-="]".allMatches(comm[y]).length;
      if(comm[y].contains("[")) i+="[".allMatches(comm[y]).length;
   }//print("OUT"); //print(out);
   List<Widget> widg=[];
   out.forEach((u){
     if(u!="")widg.add(toWidget(dataStr:u));
   });
   return widg;
  }


  dynamic tokensToMap(dynamic tok, Map map){
    //print("tok"); [l:75_r:90_t:5_b:100_h:@h(frac:0.5)_w:800]
        while(tok.last.contains("(")){
          //print("TOK LAST");//l:75_r:90_t:5_b:100_h:@h(frac:0.5)_w:800
          var y=tokenize(tok.last);
          //print("Y"); //[l:75_r:90_t:5_b:100_h:@h, frac:0.5, _w:800]
          tok.last=y[0];
          if(y.length>1)tok.addAll(y.sublist(1));
        }


        var outM = tok[0].split("_");
        //print("OUTM");[l:75, r:90, t:5, b:100, h:@h]
        //if(outM.contains("**")){}
        for(int r=0; r<outM.length;r++){
          map[outM[r].split(":")[0]]=(outM[r].split(":").length>1)?outM[r].split(":")[1]:"";
        }
        var i=1;
        try{
        while(tok.length>i){
          map[outM.last.split(":")[0]]+= "("+tok[i]+")";
          i++;
          if(tok.length>i){
            outM = tok[i].split("_");
            for(int r=0; r<outM.length;r++){
              if(outM[r].split(":")[0]!="")
                map[outM[r].split(":")[0]]=(outM[r].split(":").length>1)?outM[r].split(":")[1]:"";
            }
          }
          i++;
        }
        }catch(e){}
       // if(map.isNotEmpty) print(map);
        return map;
  }

     
dynamic toWidget(
      {var dataStr, var libIn, var children}) {
        if(lib==null)lib={};
        if(libIn!=null)tempLib=libIn;
        if(calls==null)calls={};
       // if(libIn!=null)libIn.forEach((key, val){lib[key]=val;});
        var stems=[];
        var map={};
        
    if (dataStr is String) {
        // stems[0] is the widget name, stems[1] is whats inside the paren, stems[2] the child/children data
        stems =tokenize(dataStr);
         // PARSING INSIDE
      if(stems.length>1 && stems[1]!=""){
        map= tokensToMap([stems[1]], map);
        map.forEach((k,v){
          if(v.contains("(") || v.contains("@") ){
           // print(v);
            // Parsing any widgets inside the map
            map[k]=toWidget(dataStr: v);
          }
        });
      }

      if(children is List<Widget> ||children is List<TextSpan>)map["children"]=children;
      if(children is Widget || children is TextSpan)map["child"]=children;
     
     // PARSING CHILD/ CHILDREN 
     if(stems.length>2 && stems[2].trim()!=""){ 
       stems[2]= stems[2].trim();
       if(stems[2][0]=="["){
         // get children
        // splitList2(stems[2]);
        map["children"]=splitList(stems[2]);
        children=map["children"];
       }
       else if (stems[2][0]=="~"){
         // get child
         map["child"]=toWidget(dataStr:stems[2].substring(1), children: children);
         children=map["child"];
       }else if(stems[2].contains("(")){
         var possibleChild= stems[2].substring(0,stems[2].indexOf("("));
         if(widgetLib.containsKey(possibleChild) || mywidgetsLib.containsKey(possibleChild)){
            map["child"]=toWidget(dataStr:stems[2], children: children);
            children=map["child"];
         }
       }
     }

      String widgetName = stems[0].trim();
     // print(widgetName);
     if(widgetName[0]=="@"){
       if (lib.containsKey(widgetName.substring(1)))
          return lib[widgetName.substring(1)];
        if (tempLib.containsKey(widgetName.substring(1))){
          // print(widgetName.substring(1));  // print(tempLib[widgetName.substring(1)]);
         return tempLib[widgetName.substring(1)];
        }
      if (calls.containsKey(widgetName.substring(1)))
        return calls[widgetName.substring(1)](map);
     }

      if (widgetLib.containsKey(widgetName)) {
          //print(widgetName); print(map);
          return widgetLib[widgetName](map);
        } 
        else if (mywidgetsLib.containsKey(widgetName)) {
         // print(widgetName); print(map);
          CustomModel c = CustomModel.fromWidgetLib(
              {"name": widgetName, "vars": map});
          if(c.calls.containsKey("toWidget"))return c.calls["toWidget"]();
          return toWidget(
            dataStr: c.calls["toStr"](),
            children: children, //libIn: c.calls.containsKey("lib")?c.calls["widgetLib"]:null
          );
        }
    }

    return dataStr;
  }
}






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