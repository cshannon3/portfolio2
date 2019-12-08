import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:portfolio3/utils/dynamic_parsers.dart';
import 'package:portfolio3/utils/random.dart';
import 'dart:math';

import 'package:portfolio3/utils/utils.dart';


List<String> assetPhotos=["","co.jpg", "coverphoto.jpg"];


const BOX_COLOR = Colors.cyan;
const BOX_COLOR2 = Colors.yellow;
enum DRAGSIDE { LEFT, RIGHT, DOWN, UP, NONE, CENTER }
enum CHILDTYPE { BOX,IMAGE,TEXT,BUTTON}


class TextEditModel{
  FontWeight fw=FontWeight.normal;
  FontStyle fs =FontStyle.normal;
  Color color = Colors.black;
  double fontSize=14.0;
  String text="";
  bool newLine=false;


  TextSpan toWidget({var children}){
    var style = TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fw,
      fontStyle: fs
    );
    return (children!=null)?
    RichText(text: TextSpan(text: text, style: style,
    children: List.generate(children.length,((i){
      return children[i].toWidget();
    }))),
  ):
    
    TextSpan(text: text, style: style);
  }


}
class DragBox {
  bool isDragging = false;
  Color color = Colors.transparent;
  DRAGSIDE dragside = DRAGSIDE.NONE;
  double left;
  double right;
  double top;
  double bottom;
  double newposition;
  Offset start;
  Offset activePoint;
  //Size size;
  DragBox({this.left, this.right, this.bottom, this.top});

  bool isOnBox(Offset tap, Size size) {
    // print(left);print(right);print(top);print(bottom);
    double convertedStartY = tap.dy / size.height;
    double convertedStartX = tap.dx / size.width;
    if (convertedStartX > left &&
        convertedStartX < right &&
        convertedStartY > top &&
        convertedStartY < bottom) {
      print("IN BOX");
      start = tap;
      //Point(convertedStartX, convertedStartY);
      isDragging = true;
      color = Colors.grey[400].withOpacity(.3);
      return true;
    }
    return false;
  }

  void updateDrag(Offset point, Size size) {
    if (!isDragging) return;
    activePoint = point;
    var dragVecY = activePoint.dy - start.dy;
    var dragVecX = activePoint.dx - start.dx;
    final normDragVecX = (dragVecX / size.width).clamp(-1.0, 1.0);
    final normDragVecY = (dragVecY / size.height).clamp(-1.0, 1.0);
    if (dragside == DRAGSIDE.NONE) getdragside(dragVecX, dragVecY, size);
    if (dragside == DRAGSIDE.CENTER) {
      start = activePoint;
      left = (left + normDragVecX).clamp(0.0, 1.0);
      right = (right + normDragVecX).clamp(0.0, 1.0);
      top = (top + normDragVecY).clamp(0.0, 1.0);
      bottom = (bottom + normDragVecY).clamp(0.0, 1.0);
    } else if (dragside == DRAGSIDE.LEFT || dragside == DRAGSIDE.RIGHT) {
      if (dragside == DRAGSIDE.LEFT)
        newposition = (left + normDragVecX).clamp(0.0, 1.0);
      else
        newposition = (right + normDragVecX).clamp(0.0, 1.0);
    } else {
      if (dragside == DRAGSIDE.DOWN)
        newposition = (bottom + normDragVecY).clamp(0.0, 1.0);
      else
        newposition = (top + normDragVecY).clamp(0.0, 1.0);
    }
  }

  void getdragside(double dragVecX, double dragVecY, Size size) {
    double convertedStartY = start.dy / size.height;
    double convertedStartX = start.dx / size.width;
    double centerX = (left + (right - left) / 2);
    double centerY = (top + (bottom - top) / 2);
    double spanX = right - left;
    double spanY = bottom - top;
    if ((convertedStartX - centerX).abs() < spanX * .25 &&
        (convertedStartY - centerY).abs() < spanY * .25) {
      print("Center");
      dragside = DRAGSIDE.CENTER;
    } else {
      if (dragVecX.abs() > dragVecY.abs()) {
        if (convertedStartX - left > right - convertedStartX) {
          print("right");
          dragside = DRAGSIDE.RIGHT;
        }
        // if(dragVecX>0)dragside=DRAGSIDE.RIGHT;
        else {
          print("left");
          dragside = DRAGSIDE.LEFT;
        }
      } else {
        if (convertedStartY - top > bottom - convertedStartY) {
          print("down");
          dragside = DRAGSIDE.DOWN;
        } else {
          print("up");
          dragside = DRAGSIDE.UP;
        }
        //if(dragVecY>0)dragside=DRAGSIDE.DOWN;
        //else dragside=DRAGSIDE.UP;
      }
    }
  }

  void endDrag() {
    if (dragside == DRAGSIDE.UP)
      top = newposition;
    else if (dragside == DRAGSIDE.DOWN)
      bottom = newposition;
    else if (dragside == DRAGSIDE.LEFT)
      left = newposition;
    else if (dragside == DRAGSIDE.RIGHT) right = newposition;
    activePoint = null;
    newposition = null;
    start = null;
    dragside = DRAGSIDE.NONE;
    color = Colors.transparent;
    isDragging = false;
  }

  Path drawPath(Size size) {
    if (dragside == DRAGSIDE.DOWN) return drawBottom(size);
    if (dragside == DRAGSIDE.UP) return drawTop(size);
    if (dragside == DRAGSIDE.LEFT) return drawLeft(size);
    if (dragside == DRAGSIDE.RIGHT) return drawRight(size);
    return drawBox(size);
    //
    //
  }

  Path drawBox(Size size) {
    final path = Path();
    // Draw the curved sections with quadratic bezier to
    // Start at the point of the touch
    path.moveTo(size.width * left, size.height * top);
    // draw the curved left side curve
    path.lineTo(size.width * right, size.height * top);
    path.lineTo(size.width * right, size.height * bottom);
    path.lineTo(size.width * left, size.height * bottom);
    path.close();

    return path;
  }

  Path drawBottom(Size size) {
    final boxValueY = size.height * newposition;
    final prevBoxValueY = (size.height * bottom);
    final midPointY = ((boxValueY - prevBoxValueY) * 1.2 + prevBoxValueY)
        .clamp(0.0, size.height);
    Point mid;

    mid = Point(size.width * (left + (right - left) / 2), midPointY);

    final path = Path();
    path.moveTo(mid.x, mid.y);
    // draw the curved left side curve
    path.quadraticBezierTo(
      mid.x - 100, //x1,
      mid.y, //y1,
      size.width * left, //x2,
      size.height * bottom, //y2
    );
    //
    // path.lineTo(size.width*right, size.height*top);
    path.moveTo(mid.x, mid.y);
    path.quadraticBezierTo(
      mid.x + 100, //x1,
      mid.y, //y1,
      size.width * right, //x2,
      size.height * bottom, //y2
    );
    path.lineTo(size.width * right, size.height * top);
    path.lineTo(size.width * left, size.height * top);
    path.lineTo(size.width * left, size.height * bottom);
    path.close();

    return path;
  }

  Path drawTop(Size size) {
    final boxValueY = size.height * newposition;
    final prevBoxValueY = (size.height * top);
    final midPointY = ((boxValueY - prevBoxValueY) * 1.2 + prevBoxValueY)
        .clamp(0.0, size.height);
    Point mid;

    mid = Point(size.width * (left + (right - left) / 2), midPointY);

    final path = Path();
    // Draw the curved sections with quadratic bezier to
    // Start at the point of the touch
    //path.moveTo(size.width*left, size.height*top);
    // draw the curved left side curve

    // Draw the curved sections with quadratic bezier to
    // Start at the point of the touch
    path.moveTo(mid.x, mid.y);
    // draw the curved left side curve
    path.quadraticBezierTo(
      mid.x - 100, //x1,
      mid.y, //y1,
      size.width * left, //x2,
      size.height * top, //y2
    );
    //
    // path.lineTo(size.width*right, size.height*top);
    path.moveTo(mid.x, mid.y);
    path.quadraticBezierTo(
      mid.x + 100, //x1,
      mid.y, //y1,
      size.width * right, //x2,
      size.height * top, //y2
    );
    path.lineTo(size.width * right, size.height * bottom);
    path.lineTo(size.width * left, size.height * bottom);
    path.lineTo(size.width * left, size.height * top);
    path.close();

    return path;
  }

  Path drawLeft(Size size) {
    final boxValueY = size.width * newposition;
    final prevBoxValueX = (size.width * left);
    final midPointX = ((boxValueY - prevBoxValueX) * 1.2 + prevBoxValueX)
        .clamp(0.0, size.width);
    Point mid;

    mid = Point(midPointX, size.height * (top + (bottom - top) / 2));

    final path = Path();
    path.moveTo(mid.x, mid.y);
    // draw the curved left side curve
    path.quadraticBezierTo(
      mid.x, //x1,
      mid.y - 100, //y1,
      size.width * left, //x2,
      size.height * top, //y2
    );
    //
    // path.lineTo(size.width*right, size.height*top);
    path.moveTo(mid.x, mid.y);
    path.quadraticBezierTo(
      mid.x, //x1,
      mid.y + 100, //y1,
      size.width * left, //x2,
      size.height * bottom, //y2
    );
    path.lineTo(size.width * right, size.height * bottom);
    path.lineTo(size.width * right, size.height * top);
    path.lineTo(size.width * left, size.height * top);
    path.close();

    return path;
  }

  Path drawRight(Size size) {
    final boxValueY = size.width * newposition;
    final prevBoxValueX = (size.width * right);
    final midPointX = ((boxValueY - prevBoxValueX) * 1.2 + prevBoxValueX)
        .clamp(0.0, size.width);
    Point mid;

    mid = Point(midPointX, size.height * (top + (bottom - top) / 2));

    final path = Path();
    path.moveTo(mid.x, mid.y);
    // draw the curved left side curve
    path.quadraticBezierTo(
      mid.x, //x1,
      mid.y - 100, //y1,
      size.width * right, //x2,
      size.height * top, //y2
    );
    //
    // path.lineTo(size.width*right, size.height*top);
    path.moveTo(mid.x, mid.y);
    path.quadraticBezierTo(
      mid.x, //x1,
      mid.y + 100, //y1,
      size.width * right, //x2,
      size.height * bottom, //y2
    );
    path.lineTo(size.width * left, size.height * bottom);
    path.lineTo(size.width * left, size.height * top);
    path.lineTo(size.width * right, size.height * top);
    path.close();

    return path;
  }
  // void current(){
  //   print("left: $left right: $right  top: $top bottom: $bottom ");
  // }

}

class PhysicsBox extends StatefulWidget {
  final DragBox dragBox;
  final Widget child;
  final double h;

  final double w;

  PhysicsBox({this.dragBox, this.child, this.h, this.w});

  @override
  _PhysicsBoxState createState() => new _PhysicsBoxState();
}

class _PhysicsBoxState extends State<PhysicsBox> with TickerProviderStateMixin {
  AnimationController controller;
  ScrollSpringSimulation simulation;
  DragBox dragBox;
  Offset point;
  bool optionsOpen = false;
  bool editMode = true;
  Color boxColor = Colors.transparent;
  String curColor = "";
  String bColor = "";
  double bRadius=0.0;
  double boxOpacity=1.0;
  double bThickness=2.0;
  bool decorate=false;
  bool hasPadding=false;
  bool isCentered=false;
  bool hasImage=false;
  String photoFromAsset;
  String photoFromUrl;
  CHILDTYPE childType=CHILDTYPE.BOX;
 // Lis
  TextEditingController textEditingController;

  String incr = "";
  List<String> incrList = [
    "",
    "100",
    "200",
    "300",
    "400",
    "500",
    "600",
    "700",
    "800",
    "900"
  ];
  bool hasChildren = false;
  List<Widget> lw = [];

  @override
  void initState() {
    super.initState();
    dragBox = widget.dragBox;
    textEditingController=TextEditingController(text: "Add Text");
    //boxPositionOnStart2 = boxPosition2;
    simulation = ScrollSpringSimulation(
      //spring
      SpringDescription(
        mass: 0.5,
        stiffness: 0.5,
        damping: 0.1,
      ),
      0.0, //start
      1.0, // end
      0.0, //velocity,
    ); //ScrollSpringSimulation
    controller = AnimationController(vsync: this)
      ..addListener(() {
        print('${simulation.x(controller.value)}'); // print position of object
      });
  }

  List<Widget> addList() {
    List<Widget> out = (widget.child is Widget) ? [widget.child] : [];
    for (int y = 0; y < 10; y++) {
      out.add(
        RandomColorBlock(
            height: 50.0,
            child: Container(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
              ),
            )),
      );
    }
    return out;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colrs = colorOptions;
    // dragBox.current();
    return Stack(
      children: [
        // Positioned(
        //   left: dragBox.left,
        //   right: dragBox.right,
        //   top: dragBox.top,
        //   bottom: dragBox.bottom,
        //   child: widget.child??Container(),
        // ),
        Positioned(
          left: dragBox.left * widget.w, //s.width,
          top: dragBox.top * widget.h, //s.height,
          width: (dragBox.right - dragBox.left) * widget.w, //s.width,
          height: (dragBox.bottom - dragBox.top) * widget.h, //s.height,
          child: Container(
            decoration: decorate?BoxDecoration(
              color:boxColor,
              border: Border.all(width:bThickness, color: colorFromString(bColor),),
              borderRadius: BorderRadius.circular(bRadius)
            )
            :BoxDecoration(color: boxColor),
            child: Padding(
              padding: EdgeInsets.all((hasPadding)?8.0:0.0),
              child: hasChildren
                  ? ListView(
                      children: lw,
                    )
                     : isCentered?Center(child:
                     (childType==CHILDTYPE.BOX)? Container():
                      (childType==CHILDTYPE.IMAGE)? (photoFromAsset!="")?Image.asset("assets/images/$photoFromAsset"):Container():
                       (childType==CHILDTYPE.BUTTON)? Container():
                        (childType==CHILDTYPE.TEXT)?Text(textEditingController.text):
                          Container()

                     ):
                       (childType==CHILDTYPE.BOX)? Container():
                      (childType==CHILDTYPE.IMAGE)? (photoFromAsset!="")?Image.asset("assets/images/$photoFromAsset"):Container():
                       (childType==CHILDTYPE.BUTTON)? Container():
                        (childType==CHILDTYPE.TEXT)?Text(textEditingController.text):
                          Container()
                  //widget.child ?? Container(),
                  // : isCentered?Center(child:widget.child ?? Container()):
                  // widget.child ?? Container(),
            ),
          ),
        ),
        editMode
            ? GestureDetector(
                onPanStart: startDrag,
                onPanUpdate: onDrag,
                onPanEnd: endDrag,
                onDoubleTap: () {
                  setState(() {
                    optionsOpen = true;
                  });
                },
                child: CustomPaint(
                    painter: BoxPainter(
                      dragbox: dragBox,
                      // ?? checks "a" for null and replaces "a" with "b" if it is
                      touchPoint: point,
                    ), // Box Painter
                    child: Container()), // Custom Paint
              )
            : Container(),
        optionsOpen
            ? Positioned(
                left: widget.w / 2 - 200.0, //s.width,
                top: widget.h / 2 - 250, //s.height,
                width: 400, //s.width,
                height: 500, //s.height,
                child: Container(
                  color: Colors.green,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Color:"),
                          DropdownButton<String>(
                            value: curColor,
                            items: colrs
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String newVal) {
                              curColor = newVal;
                              boxColor = colorFromString(curColor + incr, opacity: boxOpacity);
                              setState(() {});
                            },
                          ),
                          DropdownButton<String>(
                            value: incr,
                            items: incrList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String newVal) {
                              incr = newVal;
                              boxColor = colorFromString(curColor + incr, opacity: boxOpacity);
                              setState(() {});
                            },
                          ),
                IconButton(onPressed: (){if(boxOpacity>=0.1)setState(() {
                          boxOpacity-=0.1;
                          boxColor = colorFromString(curColor + incr, opacity: boxOpacity);
                        });},icon: Icon(Icons.arrow_downward),),           
                        Text(boxOpacity.toStringAsPrecision(2)),
                        IconButton(onPressed: (){if(boxOpacity<=0.9)setState(() {
                          boxOpacity+=0.1;boxColor = colorFromString(curColor + incr, opacity: boxOpacity);
                        });},icon: Icon(Icons.arrow_upward),),
                        ],
                      ),
                      decorate?Row(
                        children: <Widget>[
                          Text("Border:"),
                          DropdownButton<String>(
                            value: bColor,
                            items: colrs
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String newVal) {
                              bColor = newVal;
                              //boxColor = colorFromString(curColor + incr);
                              setState(() {});
                            },
                          ),
                        
     
                        IconButton(onPressed: (){if(bThickness>=1.0)setState(() {
                          bThickness-=1;
                        });},icon: Icon(Icons.arrow_downward),),           
                        Text(bThickness.toString()),
                        IconButton(onPressed: (){setState(() {
                          bThickness+=1.0;
                        });},icon: Icon(Icons.arrow_upward),),
                         IconButton(onPressed: (){if(bRadius>=1.0)setState(() {
                          bRadius-=1.0;
                        });},icon: Icon(Icons.arrow_downward),),
                        Text(bRadius.toString()),
                        IconButton(onPressed: (){setState(() {
                          bRadius+=1.0;
                        });},icon: Icon(Icons.arrow_upward),),
                        ],
                      ):  Center(
                        child: RaisedButton(
                          child: Text("decorate"),
                          onPressed: () {
                            setState(() {
                              decorate=true;
                            });
                          },
                        ),
                      ),
                      Row(children: <Widget>[
                        Expanded(child:FlatButton(
                          color: !hasChildren?Colors.blueAccent:null,
                          child: Text("Single Child"),
                          onPressed: (){setState(() {
                            hasChildren=false;
                          });},
                        ) ,),
                        Expanded(child:FlatButton(
                          color: hasChildren?Colors.blueAccent:null,
                          child: Text("Children"),
                          onPressed: (){setState(() {
                            hasChildren=true;
                             lw = addList();
                          });},
                        ) ,),
                      ],),
        
                     
                     (!hasChildren)? Center(
                        child: RaisedButton(
                          child: Text(isCentered?"unCenter":"Center"),
                          onPressed: () {
                            isCentered=!isCentered;
                            setState(() {});
                          },
                        ),
                      ):Container(),
                      (!hasChildren)?Row(children: <Widget>[
                             Expanded(child:FlatButton(
                          color:  (childType==CHILDTYPE.BOX)?Colors.blueAccent:null,
                          child: Text("Box"),
                          onPressed: (){setState(() {
                             childType=CHILDTYPE.BOX;
                          });},
                        ) ,),
                        Expanded(child:FlatButton(
                          color:  (childType==CHILDTYPE.IMAGE)?Colors.blueAccent:null,
                          child: Text("Image"),
                          onPressed: (){setState(() {
                             childType=CHILDTYPE.IMAGE;
                          });},
                        ) ,),
                        Expanded(child:FlatButton(
                          color:  (childType==CHILDTYPE.TEXT)?Colors.blueAccent:null,
                          child: Text("Text"),
                          onPressed: (){setState(() {
                             childType=CHILDTYPE.TEXT;
                          });},
                        ) ,),
                              Expanded(child:FlatButton(
                          color: (childType==CHILDTYPE.BUTTON)?Colors.blueAccent:null,
                          child: Text("Button"),
                          onPressed: (){setState(() {
                            childType=CHILDTYPE.BUTTON;
                          });},
                        ) ,),
                      ],):Container(),
                     (!hasChildren)? 
                      (childType==CHILDTYPE.BOX)? Container():
                      (childType==CHILDTYPE.IMAGE)?   Row(
                       children: <Widget>[
                         RaisedButton(
                           child: Text(hasImage?"remove Image":"addImage"),
                           onPressed: () {
                             hasImage=!hasImage;
                             setState(() {});
                           },
                         ),
                         Column(
                           children: <Widget>[
                             DropdownButton<String>(
                                value: photoFromAsset,
                                items: assetPhotos
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newVal) {
                                  photoFromAsset = newVal;
                                  //boxColor = colorFromString(curColor + incr);
                                  setState(() {});
                                },
                              ),
                               DropdownButton<String>(
                                value: photoFromAsset,
                                items: assetPhotos
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newVal) {
                                  photoFromAsset = newVal;
                                  //boxColor = colorFromString(curColor + incr);
                                  setState(() {});
                                },
                              ),
                           ],
                         ),
                       ],
                     ):
                       (childType==CHILDTYPE.BUTTON)? Container():
                        (childType==CHILDTYPE.TEXT)?Column(
                          children: <Widget>[
                            Row(children: <Widget>[
                           IconButton(onPressed: () {setState(() { }); },icon: Icon(Icons.format_bold), ),
                           IconButton(onPressed: () {setState(() { }); },icon: Icon(Icons.format_italic), ),
                          //  DropdownButton<String>(
                          //   value: curColor,
                          //   items: colrs
                          //       .map<DropdownMenuItem<String>>((String value) {
                          //     return DropdownMenuItem<String>(
                          //       value: value,
                          //       child: Text(value),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String newVal) {
                          //     curColor = newVal;
                          //     boxColor = colorFromString(curColor + incr, opacity: boxOpacity);
                          //     setState(() {});
                          //   },
                          // ),
                            ],),
                            Row(
                              children: <Widget>[
                                Text("Text:"),
                                Expanded(
                                  child: TextField(
                                    controller:textEditingController,
                                      onChanged: (text) {
    print("First text field: $text");
    setState(() {
      
    });
  },
                                    ),
                                ),
                              ],
                            ),
                          ],
                        ):
                         Container(): Container(),
                   
                      Center(
                        child: RaisedButton(
                          child: Text(hasPadding?"Remove Padding":"Add Padding"),
                          onPressed: () {
                            setState(() {
                              hasPadding = !hasPadding;
                            });
                          },
                        ),
                      ),
                      Center(
                        child: RaisedButton(
                          child: Text("Close"),
                          onPressed: () {
                            setState(() {
                              optionsOpen = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
        // Gesture Detector
        Positioned(
            left: dragBox.left * widget.w, //s.width,
            top: dragBox.top * widget.h - 30.0, //s.height,
            child: IconButton(
              onPressed: () {
                setState(() {
                  editMode = !editMode;
                });
              },
              icon: Icon(editMode ? Icons.close : Icons.edit),
            )),
      ],
    ); // Stack
  }

  void startDrag(DragStartDetails details) {
    // This takes start drag obj and uses context/render box to find location of it on the screen
    var start = (context.findRenderObject() as RenderBox).globalToLocal(details
        .globalPosition); // Global to local converts coordinates to a 'local' system that is easier to work with
    if (dragBox.isOnBox(start, context.size)) print("active");
  }

  void openOptions() {}

  void onDrag(DragUpdateDetails details) {
    setState(() {
      point = (context.findRenderObject() as RenderBox)
          .globalToLocal(details.globalPosition);
      dragBox.updateDrag(point, context.size);
    });
  }

  void endDrag(DragEndDetails details) {
    dragBox.endDrag();
    setState(() {});
  }
}

class BoxPainter extends CustomPainter {
  final DragBox dragbox;
  final Offset touchPoint;
  final Paint boxPaint1;
  final Paint dropPaint;

  BoxPainter({
    this.dragbox,
    this.touchPoint,
  })  : boxPaint1 = Paint(),
        dropPaint = Paint() {
    boxPaint1.color = this.dragbox.color;
    boxPaint1.style = PaintingStyle.fill;
    dropPaint.color = Colors.grey;
    dropPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    Path pathOne = dragbox.drawPath(size);

    canvas.drawPath(pathOne, boxPaint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
       // Center(
                      //   child: RaisedButton(
                      //     child: Text((hasChildren) ? "De-List" : "To List"),
                      //     onPressed: () {
                      //       if (hasChildren) {
                      //         hasChildren = false;
                      //         lw = [];
                      //       } else {
                      //         hasChildren = true;
                      //         lw = addList();
                      //       }
                      //       setState(() {});
                      //     },
                      //   ),
                      // ),