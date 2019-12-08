import 'package:flutter/material.dart';

import 'package:portfolio3/custom_makers/w2.dart';

class EditableContainer extends StatefulWidget {
  final Map tokens;
  EditableContainer({this.tokens});

  @override
  _EditableContainerState createState() => _EditableContainerState();
}

class _EditableContainerState extends State<EditableContainer> {

    TextEditingController leftPctController = TextEditingController();
    TextEditingController rightPctController = TextEditingController();
    TextEditingController topPctController = TextEditingController();
    TextEditingController bottomPctController = TextEditingController();
    double leftPct;
    double rightPct;
    double topPct;
    double bottomPct;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    leftPct = double.tryParse(widget.tokens["l"]);
    print(leftPct);
    rightPct=double.tryParse(widget.tokens["r"]);
    topPct=double.tryParse(widget.tokens["t"]);
    bottomPct=double.tryParse(widget.tokens["b"]);
  }
  @override
  Widget build(BuildContext context) {
  //     String t;String b;
  // String l;
  // String r;
    leftPctController.text=leftPct.toString();
    rightPctController.text=rightPct.toString();
    topPctController.text=topPct.toString();
    bottomPctController.text=bottomPct.toString();
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var l2=(leftPct>5)? (leftPct-5):(rightPct<95)?rightPct :rightPct-5;
    var t2=h*(bottomPct - topPct)<=100.0 && (topPct>10)?(topPct-10):topPct;
    return 
      CustomWidget2(
        calls:{
            "getController":(var tokens){

    },
        }
      ).toWidget(
        screenW:w,
        screenH: h,
        libIn: {
        "child": widget.tokens["child"]
      },
      
       dataStr:
      '''
      stack()[
        fitted(l:${leftPct}_r:${rightPct}_t:${topPct}_b:$bottomPct)~@child,
        fitted(l:${l2}_r:${rightPct+50}_t:${t2}_b:$bottomPct)~container(c:green)
        ]
      '''
    );
  }
}
// }
//        fitted(l:${l2}_r:${rightPct}_t:${t2}_b:${bottomPct}_h:${h}_w:$w)~listView()[
//         ],
//         raisedButton()~text(text:Get), 
                   