

import 'package:flutter/material.dart';
import 'package:portfolio3/utils/random.dart';
String token = "_";
List<String> tokenList= ["~"];
Map<String, dynamic> parseMap = {
  "height": (var tokens) => tryParse(tokens, ["height", "h"]),
  "width": (var tokens) => tryParse(tokens, ["width", "w"]),
  "left": (var tokens) => tryParse(tokens, ["left", "l"]),
  "right": (var tokens) => tryParse(tokens, ["right", "r"]),
  "top": (var tokens) => tryParse(tokens, ["top", "t"]),
  "ratio": (var tokens) => tryParse(tokens, ["ratio", "ra"]),
  "vertical": (var tokens) =>
      tryParse(tokens, ["vertical", "vert", "v"]),
  "horizontal": (var tokens) =>
      tryParse(tokens, ["horizontal", "hor"]),
  "all": (var tokens) => tryParse(tokens, ["all"]),
  "bottom": (var tokens) => tryParse(tokens, ["bottom", "b"]),
  "flex": (var tokens) => tryParse(tokens, ["flex", "f"], type: "int"),
  "color": (var tokens) =>
      tryParse(tokens, ["color", "c"], type: "color"),
  "alignment": (var tokens) =>
      tryParse(tokens, ["alignment", "align", "al"], type: "alignment"),
    "x": (var tokens) => tryParse(tokens, ["x", "dx"]),
  "y": (var tokens) => tryParse(tokens, ["y", "dy"]),
   "length": (var tokens) => tryParse(tokens, ["length", "len"]),
};



EdgeInsets getPadding(var tokens) {
  var all = parseMap["all"](tokens);
  if (all != null) return EdgeInsets.all(all);
  var hor = parseMap["horizontal"](tokens);
  var vert = parseMap["vertical"](tokens);
  if (hor != null || vert != null)
    return EdgeInsets.symmetric(vertical: vert ?? 0.0, horizontal: hor ?? 0.0);
  return EdgeInsets.only(
      top: parseMap["top"](tokens) ?? 0.0,
      bottom: parseMap["bottom"](tokens) ?? 0.0,
      left: parseMap["left"](tokens) ?? 0.0,
      right: parseMap["right"](tokens) ?? 0.0);
}



dynamic tryParse(var tokens, List<String> names,
    {String type = "double", bool parseType=true}) {
  var out;
  int i = 0;
  tokens = trySplit(tokens, type);
  if(tokens is List){
    while (out == null && i < names.length) {
    if (tokens.contains(names[i]))
      out = parseToken(tokens, label:names[i],dictName: names[0], type: type);
    i++;
  }
  }
  else{
    while (out == null && i < names.length) {
      if (tokens.containsKey(names[i])){
        out = parseType?parseToken(tokens[names[i]],dictName: names[0], type: type):tokens[names[i]];
      }
      i++;
    }
  }
  return out;
}

parseToken(var tokens, {var label,var dictName, var type = "double"}) {
  var tok = tokens;
  if(tokens is List){
    tok = tokens[tokens.indexOf(label) + 1];
  }
  if(tok is String){
  switch (type) {
    case "double":
      if(tok=="max")return double.maxFinite;
      return double.tryParse(tok);
      break;
    case "int":
      return int.tryParse(tok);
      break;
    case "color":
      return colorFromString(tok);
      break;
    case "string":
      return tok;
      break;
    case "alignment":
      return defaultEnum["alignment"].containsKey(tok)?defaultEnum["alignment"][tok]:null;
      break; 
    // case "class":
    //   var key = (dictName!=null)?dictName:(tok is List)?tok[0]:tok;
    //   if(tok is List)return defaultClass.containsKey(key)?defaultClass[key](tok.sublist(1)):null;
    //   return defaultClass.containsKey(key)?defaultClass[key]:null;
    // case "enum":
    //   var key = (dictName!=null)?dictName:(tok is List)?tok[0]:tok;
    //   if(tok is List)return defaultEnum.containsKey(key)?defaultEnum[key](tok.sublist(1)):null;
    //   return defaultEnum.containsKey(key)?defaultEnum[tok]:null;
    default:
      return tok;
      break;
  }
  }
  else return tok;
}

dynamic trySplit(var tokens, String type){
  if (!(tokens is List))return tokens;
  if(type!="class" || type!="enum")return tokens;
  var outTokens =[];
  tokens.forEach((t){
    int i=0;
    while (i<tokenList.length &&!t.contains(tokenList[i]))i++;
    if(i!=tokenList.length)outTokens.add(t.split(tokenList[i]));
    else outTokens.add(t);
  });
}




//String to(String baseName) => capWord(baseName) + "Model";
Color colorFromString(String color){
  var incr;
  if (color.contains("[")){
    var c = color.split("[");
    color = c[0];
    incr = int.tryParse(c[1].substring(0, c[1].length-1));
  }  

  else if(color.length>3){
      incr = int.tryParse(color.substring(color.length-3));
      if(incr!=null)color=color.substring(0,color.length-3);
  }
    switch(color){
      case "black":
        return Colors.black;
      case "red":
        return (incr!=null)?Colors.red[incr]: Colors.red;
      case "grey":
        return (incr!=null)?Colors.grey[incr]: Colors.grey;
      case "indigo":
        return (incr!=null)?Colors.indigo[incr]: Colors.indigo;
      case "blue":
        return (incr!=null)?Colors.blue[incr]: Colors.blue;
      case "green":
        return (incr!=null)?Colors.green[incr]: Colors.green;
      case "purple":
        return (incr!=null)?Colors.purple[incr]: Colors.purple;
      case "white":
        return Colors.white;
      case "orange":
        return (incr!=null)?Colors.orange[incr]: Colors.orange;
      case "random":
        return RandomColor.next();
      default:
        return Colors.black;
    }
  }    


Map<String, dynamic> defaultClass = {

  "paint": (var tokens)=>Paint()
      ..strokeJoin = tryParse(tokens, ["strokeJoin", "sj"], type: "enum")??StrokeJoin.round
      ..strokeWidth = tryParse(tokens, ["strokeWidth", "sw"], type: "enum")??StrokeCap.round
      ..color = parseMap["color"](tokens)??Colors.green
      ..style = tryParse(tokens, ["paintStyle", "sc"], type: "enum")??PaintingStyle.stroke
};



Map<String, dynamic> defaultEnum = {

  "strokeJoin":{
    "round":StrokeJoin.round,
    "r": StrokeJoin.round,
    "bevel":StrokeJoin.bevel,
    "b":StrokeJoin.bevel
  } ,
  "strokeCap":{
    "b":StrokeCap.butt,
    "butt":StrokeCap.butt,
    "r":StrokeCap.round,
    "round":StrokeCap.round,
    "s":StrokeCap.square,
    "square":StrokeCap.square,
  },
  "paintStyle":{
    "f":PaintingStyle.fill,
    "fill":PaintingStyle.fill,
    "stroke":PaintingStyle.stroke,
    "s":PaintingStyle.stroke
  },
  "alignment":{
    "center": Alignment.center,
    "topLeft": Alignment.topLeft,
    "topRight": Alignment.topRight,
    "bottomLeft": Alignment.bottomLeft,
    "bottomRight": Alignment.bottomRight,
    "topCenter": Alignment.topCenter,
    "bottomCenter": Alignment.bottomCenter,
    "centerRight": Alignment.centerRight,
    "centerLeft": Alignment.centerLeft
  }
};


