
import 'dart:math';
import 'dart:html' as html;
import 'dart:typed_data';

dynamic ifIs(var tokens, var name) =>
    (tokens!=null && tokens.containsKey(name)) ? tokens[name] : null;

String capWord(String word) {
  if (!word.contains("_")) return word[0].toUpperCase() + word.substring(1);
  String out = "";
  word.split("_").forEach((w) => out += capWord(w));
  return out;
}

bool hasChildren(String key){
   var widgetInfo = key.contains("_") ? key.split("_") : [key];
   return (["stack", "column", "row", "listview"].contains(widgetInfo[0]));
 }

dynamic tokensToMap(var tokens){
  print(tokens);
  var mapOut = {};
  for (int i = 0; i<tokens.length; i++){
    mapOut[tokens[i]]=mapOut[tokens[i+1]];
    i+=1;
  }
  print(mapOut);
  return mapOut;
}


double K(double progress) {
  return sin(progress * (pi / 200));
}

double Z(double progress) {
  return cos(progress * (pi / 200));
}

double X(double progress) {
  return tan(progress * (pi / 200));
}

double rad(double progress) {
  return progress * (pi / 200);
}

double toProgress(double rad) {
  return rad * (200.0 / pi);
}

double progressFromZ(double zlength, double radius) {
  return toProgress(acos(zlength / radius));
}

double progressFromK(double klength, double radius) {
  return toProgress(asin(klength / radius));
}
class Platform {
  var _iOS = ['iPad Simulator', 'iPhone Simulator', 'iPod Simulator', 'iPad', 'iPhone', 'iPod'];

  bool isIOS() {
    var matches = false;
    _iOS.forEach((name) {
      if (html.window.navigator.platform.contains(name) || html.window.navigator.userAgent.contains(name)) {
        matches = true;
      }
    });
    return matches;
  }

  bool isAndroid() =>
      html.window.navigator.platform == "Android" || html.window.navigator.userAgent.contains("Android");

  bool isMobile() => isAndroid() || isIOS();

  String name() {
    var name = "";
    if (isAndroid()) {
      name = "Android";
    } else if (isIOS()) {
      name = "iOS";
    }
    return name;
  }

  void openStore() {
    // if (isAndroid()) {
    //   html.window.location.href = "your Play Store URL";
    // } else {
    //   html.window.location.href = "Your App Store URL";
    // }
  }
}

final Uint8List kTransparentImage = new Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);
