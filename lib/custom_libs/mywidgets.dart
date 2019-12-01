
import 'package:flutter/material.dart';
import 'package:portfolio3/custom_makers/model_maker.dart';
import 'package:portfolio3/utils/dynamic_parsers.dart';
import 'package:portfolio3/utils/utils.dart';

Map<String, dynamic> mywidgetsLib = {
  "fittedrcb":{
    "vars":(var tokens){
       var h = parseMap["height"](tokens); //parseMap["height"](tokens);;
       var w = parseMap["width"](tokens);
      var wid = w *(parseMap["right"](tokens) - parseMap["left"](tokens)) /
                100;
      var hei =  h * (parseMap["bottom"](tokens) - parseMap["top"](tokens)) /
                100;
      var minW = tryParse(tokens, ["minw", "minW"])??0.0;
      var maxW = tryParse(tokens, ["maxw", "maxW"])??w;
      var minH = tryParse(tokens, ["minh", "minH"])??0.0;
      var maxH = tryParse(tokens, ["maxh", "maxH"])??h;
      return {
        "left":w * parseMap["left"](tokens) / 100,
        "top":h * parseMap["top"](tokens) / 100,
        "width": (wid<maxW)?wid:maxW,
        "height": (hei<maxH)?hei:maxH,
        "isHidden": (wid<minW || hei<minH)
      };
    },
    "functions": (CustomModel self) => {
      "toStr":()=> (self.vars["isHidden"])?"container()":
      '''positioned(left:${self.vars["left"]}_top:${self.vars["top"]}_width:${self.vars["width"]}_height:${self.vars["height"]})
                  ~rcb(width:${self.vars["width"]}_height:${self.vars["height"]})'''
    }
  
    },
    "fitted":{
    "vars":(var tokens){
       var h = parseMap["height"](tokens); //parseMap["height"](tokens);;
       var w = parseMap["width"](tokens);
      var wid = w *(parseMap["right"](tokens) - parseMap["left"](tokens)) /
                100;
      var hei =  h * (parseMap["bottom"](tokens) - parseMap["top"](tokens)) /
                100;
      var minW = tryParse(tokens, ["minw", "minW"])??0.0;
      var maxW = tryParse(tokens, ["maxw", "maxW"])??w;
      var minH = tryParse(tokens, ["minh", "minH"])??0.0;
      var maxH = tryParse(tokens, ["maxh", "maxH"])??h;
      return {
        "left":w * parseMap["left"](tokens) / 100,
        "top":h * parseMap["top"](tokens) / 100,
        "width": (wid<maxW)?wid:maxW,
        "height": (hei<maxH)?hei:maxH,
        "isHidden": (wid<minW || hei<minH)
      };
    },
    "functions": (CustomModel self) => {
      "toStr":()=> //(self.vars["isHidden"])?"container()":
      '''positioned(left:${self.vars["left"]}_top:${self.vars["top"]}_width:${self.vars["width"]}_height:${self.vars["height"]})'''
    }
    },

  "formatted":{
    "vars":(var tokens){
      return {
        "width": parseMap["width"](tokens)??0.0,
        "height": parseMap["height"](tokens)??0.0,
        "alignment":  parseMap["alignment"](tokens),
        "padding":getPadding(tokens)
      };
    },
    "functions": (CustomModel self) => {
      "lib":()=>{
        "padding":()=>self.vars["padding"],
        "align":()=>self.vars["alignment"]
      },
      "toStr":()=> 
      '''padding(padding:@padding}~align(alignment:@align)~sizedBox(h:${self.vars["height"]}_w:${self.vars["width"]})'''
    }
    },

    "customText":{
    "vars":(var tokens){
      return {
        "text": tokens.containsKey("text")? (tokens["text"] is List)?tokens["text"].join():tokens["text"]:"",
        "token": tokens.containsKey("token")?tokens["token"]:"#",
        "isBold": tokens.containsKey("bold")&&["true", "True", "t"].contains(tokens["bold"])?FontWeight.bold : FontWeight.normal,
        "isHighlighted": tokens.containsKey("highlight")? ["true", "True", "t"].contains(tokens["highlighted"]) : false,
        "isItalic": tokens.containsKey("italic")&& ["true", "True", "t"].contains(tokens["italic"]) ?FontStyle.italic: FontStyle.normal,
        "fontSize":tryParse(tokens, ["fontSize", "size", "fs"])??16.0,
        "color":parseMap["color"](tokens)??Colors.black,  
     }; 
    },
    "functions": (CustomModel self) => {
      "toWidget":(){
        return  RichText(text: TextSpan(children: self.calls["toTextSpan"]()));
      },
    
      "toTextSpan":({String outStr=""}){
        List<TextSpan> textWidgets=[];
        self.vars["text"].split(self.vars["token"]).forEach((textSeg)
        {
        if(textSeg=="bold") self.vars["isBold"]= FontWeight.bold;
        else if(textSeg=="/bold") self.vars["isBold"]=FontWeight.normal;
        else if(textSeg=="italic") self.vars["isItalic"]= FontStyle.italic;
        else if(textSeg=="/italic") self.vars["isItalic"]= FontStyle.normal;
        else if(textSeg.contains("color")) self.vars["color"] =colorFromString(textSeg.substring("color".length))??Colors.black;
        else if(textSeg.contains("/color")) self.vars["color"]=Colors.black;  // else if(textSeg.contains("highlight")) self.vars["isHighlighted"]= !isHighlighted;
        else if(textSeg.contains("size"))self.vars["fontSize"]=double.tryParse(textSeg.substring("size".length)) ?? 12.0;
        else if(textSeg.contains("/size"))self.vars["fontSize"]=16.0;
        else{
          //if(outStr!="")outStr+=",";
          //outStr+='''textSpan(text:$textSeg)''';//_style:textStyle(fontSize:${self.vars["fontSize"]}_fontWeight:${self.vars["isBold"]}_fontStyle:${self.vars["isItalic"]}))''';
          textWidgets.add(
            TextSpan(
              text: textSeg, 
              style:TextStyle(
                fontSize: self.vars["fontSize"], 
                fontWeight: self.vars["isBold"], 
                fontStyle:self.vars["isItalic"], 
                color: self.vars["color"])));
             //   backgroundColor: isHighlighted ? Colors.yellowAccent:null)));
        }

      });
      return textWidgets;
      },
      "toStr":(){
        var o = '''richText(
          text:textSpan(text:${self.vars["text"]})
          )''';
      return o;
      }
    }
    },
     "form":{
    "vars":(var tokens){
      return {
        "width": parseMap["width"](tokens)??0.0,
        "height": parseMap["height"](tokens)??0.0,
        "alignment":  parseMap["alignment"](tokens),
        "padding":getPadding(tokens)
      };
    },
    "functions": (CustomModel self) => {
      "lib":()=>{
        "padding":()=>self.vars["padding"],
        "align":()=>self.vars["alignment"]
      },
      "toStr":()=> 
      '''padding(padding:@padding}~align(alignment:@align)~sizedBox(h:${self.vars["height"]}_w:${self.vars["width"]})'''
    }
    },
    
  "pctWide":{
    "vars":(var tokens){
      return {
        "width":  parseMap["width"](tokens) *parseMap["left"](tokens) /100,
        "height":parseMap["height"](tokens)??0.0 * parseMap["left"](tokens)??0.0 *parseMap["ratio"](tokens)??0.0 /100,
        "padding":getPadding(tokens),
        "color" :ifIs(tokens, "color")??"null",  
      };
    },
    "functions": (CustomModel self) => {
      "lib":()=>{
        "padding":()=>self.vars["padding"],
      },
      "toStr":()=> 
      '''sizedBox(w:${self.vars["width"]}_h:${self.vars["height"]})
          ~container(color:${self.vars["color"]})
              ~padding(padding:@padding)'''
    }
    },
  };
  

  


//   Map<String, dynamic> myWidgetMap = {
//     "pctWide": (var tokens, List<Widget> children) {
//       var h = parseMap["height"](tokens); //parseMap["height"](tokens);;
//       var w = parseMap["width"](tokens);
//       if(h == null && w == null) return null;
//       var wid = w *parseMap["left"](tokens) /100;
//       var hei= (h) * parseMap["left"](tokens)*parseMap["ratio"](tokens)/100;
//       //print(hei); print(wid);
//       return      SizedBox(
//                 width:  wid,
//                 height:hei,
//                 child: Container(
//                   color: parseMap["color"](tokens),
//                   child: Padding(
//                     padding: getPadding(tokens),
//                   child: (children==null)?children:children[0], ),
//                 ));
//   },
//     "centerAbout": (var tokens, List<Widget> children) {
//     return Positioned(
//         left: parseMap["left"](tokens),
//         top:parseMap["top"](tokens),
//         child: FractionalTranslation(
//            translation: const Offset(-0.5, -0.5),
//         child: (children==null)?children:children[0],
//       ),);
//   },

// };


    //     "customTextList":{
    // "vars":(var tokens){
    //   return {
    //     "text": tokens.containKey("text")? (tokens["text"] is List)?tokens["text"].join():tokens["text"]:"",
    //     "token": tokens.containKey("token")?tokens["token"]:"@@",
    //     "isBold": tokens.containKey("bold")&&["true", "True", "t"].contains(tokens["bold"])?"bold" : "normal",
    //     "isHighlighted": tokens.containKey("highlight")? ["true", "True", "t"].contains(tokens["highlighted"]) : false,
    //     "isItalic": tokens.containKey("italic")&& ["true", "True", "t"].contains(tokens["italic"]) ?"italic": "normal",
    //     "fontSize":tryParse(tokens, ["fontSize", "size", "fs"])??16.0,
    //     "color":tokens.containKey("color")? tokens["color"]:"black",  
    //  }; 
    // },
    // "functions": (CustomModel self) => {
    //   "toTextSpan":({String outStr=""})=>{
    //     self.vars["text"].split(self.vars["token"]).forEach((textSeg)
    //     {
    //     if(textSeg=="bold") self.vars["isBold"]= "bold";
    //     else if(textSeg=="/bold") self.vars["isBold"]="normal";
    //     else if(textSeg=="italic") self.vars["isItalic"]= "italic";
    //     else if(textSeg=="/italic") self.vars["isItalic"]= "normal";
    //     else if(textSeg.contains("color:")) self.vars["color"] = textSeg.substring("color:".length);
    //     else if(textSeg.contains("/color")) self.vars["color"]="black";  // else if(textSeg.contains("highlight")) self.vars["isHighlighted"]= !isHighlighted;
    //     else if(textSeg.contains("size:"))self.vars["fontSize"]=double.tryParse(textSeg.substring("size:".length)) ?? 12.0;
    //     else if(textSeg.contains("/size"))self.vars["fontSize"]=16.0;
    //     else{
    //       if(outStr!="")outStr+=",";
    //       outStr+='''textSpan(text:${textSeg}_style:textStyle(fontSize:${self.vars["fontSize"]}_fontWeight:${self.vars["isBold"]}_fontStyle:${self.vars["isItalic"]}))''';
    //     }
    //   })
    //   },
    //   "toStr":()=> self.calls["toTextSpan"]()
    // }
    // },

    // "customText":{
    // "vars":(var tokens){
    //   print("customText");
    //   print(tokens);
    //   return {
    //     "text": tokens.containsKey("text")? (tokens["text"] is List)?tokens["text"].join():tokens["text"]:"",
    //     "token": tokens.containsKey("token")?tokens["token"]:"#",
    //     "isBold": tokens.containsKey("bold")&&["true", "True", "t"].contains(tokens["bold"])?"bold" : "normal",
    //     "isHighlighted": tokens.containsKey("highlight")? ["true", "True", "t"].contains(tokens["highlighted"]) : false,
    //     "isItalic": tokens.containsKey("italic")&& ["true", "True", "t"].contains(tokens["italic"]) ?"italic": "normal",
    //     "fontSize":tryParse(tokens, ["fontSize", "size", "fs"])??16.0,
    //     "color":tokens.containsKey("color")? tokens["color"]:"black",  
    //  }; 
    // },
    // "functions": (CustomModel self) => {
    //   "toWidget":(){
    //     return RichText(text: ,)
    //   },
      

    //   "toTextSpan":({String outStr=""}){
    //     self.vars["text"].split(self.vars["token"]).forEach((textSeg)
    //     {
    //     if(textSeg=="bold") self.vars["isBold"]= "bold";
    //     else if(textSeg=="/bold") self.vars["isBold"]="normal";
    //     else if(textSeg=="italic") self.vars["isItalic"]= "italic";
    //     else if(textSeg=="/italic") self.vars["isItalic"]= "normal";
    //     else if(textSeg.contains("color:")) self.vars["color"] = textSeg.substring("color:".length);
    //     else if(textSeg.contains("/color")) self.vars["color"]="black";  // else if(textSeg.contains("highlight")) self.vars["isHighlighted"]= !isHighlighted;
    //     else if(textSeg.contains("size:"))self.vars["fontSize"]=double.tryParse(textSeg.substring("size:".length)) ?? 12.0;
    //     else if(textSeg.contains("/size"))self.vars["fontSize"]=16.0;
    //     else{
    //       if(outStr!="")outStr+=",";
    //       outStr+='''textSpan(text:$textSeg)''';//_style:textStyle(fontSize:${self.vars["fontSize"]}_fontWeight:${self.vars["isBold"]}_fontStyle:${self.vars["isItalic"]}))''';
    //     }

    //   });
    //   return outStr;
    //   },
    //   "toStr":(){
    //     var o = '''richText(
    //       text:textSpan()[${self.calls["toTextSpan"]()}]
    //       )''';
    //     print(o);
    //   return o;
    //   }
    // }
    // },