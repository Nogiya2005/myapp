import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/EJdicPage.dart';
import 'package:myapp/quizmenuPage.dart';
import 'SettingPage.dart';
import 'favoritefolderPage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui' as ui;
import 'package:flutter_tts/flutter_tts.dart';

//単語帳幅
double widgetheight = 200;

//ダイアログOP
double buttonsize = 15;
double titlesize = 25;

//フォントサイズ
double fs = 19;

//読み上げOP
FlutterTts? flutterTts;
double volume = 1.0; //音量
String language = "en-US"; //言語
double voicespeed = 0.5; //速度
double pc = 1.0; //ピッチ

//vl,lang,sp
void onnsei(var txt, var vl, var lg, var spd) {
  flutterTts = FlutterTts();
  flutterTts!.setSpeechRate(spd);
  flutterTts!.setLanguage(lg);
  flutterTts!.setVolume(vl);
  flutterTts!.speak(txt);
}

void onnseistop() async {
  await flutterTts!.stop();
}

final widgets = [];
double x0 = 0,
    y0 = 0,
    x = 0,
    y = 0,
    X = 0,
    Y = 0,
    sq = 0,
    cancelsize = 50,
    ab = 0;
Color? section(int section, var cansz) {
  if (sq <= cansz) {
    return Colors.black.withOpacity(0.5);
  } else if ((ab.abs() >= 1 || X == 0) && Y > 0) {
    if (section == 1) {
      return Colors.blue;
    } else {
      return Colors.black.withOpacity(0.5);
    }
  } else if ((ab.abs() >= 1 || X == 0) && Y < 0) {
    if (section == 2) {
      return Colors.blue;
    } else {
      return Colors.black.withOpacity(0.5);
    }
  } else if ((ab.abs() < 1 || Y == 0) && X < 0) {
    if (section == 3) {
      return Colors.blue;
    } else {
      return Colors.black.withOpacity(0.5);
    }
  } else if ((ab.abs() < 1 || Y == 0) && X > 0) {
    if (section == 4) {
      return Colors.blue;
    } else {
      return Colors.black.withOpacity(0.5);
    }
  }
  return null;
}

ScrollPhysics? wakaran(bool swich) {
  var nazo;
  if (swich == true) {
    nazo = NeverScrollableScrollPhysics();
  } else {
    nazo = ClampingScrollPhysics();
  }
  return nazo;
}

void nanikore(context, int a) {
  if (a == 1) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EJdicPage(),
        ));
  }
  if (a == 2) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingPage(),
        ));
  }
  if (a == 3) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => favoritefolderPage(),
        ));
  }
  if (a == 4) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizmenuPage(),
        ));
  }
}

class determineContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
  }
}

class backblackcontainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 1.5,
          sigmaY: 1.5,
        ),
        child: Container(
          color: Colors.black.withOpacity(0), // 画面マスクの透明度
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ));
  }
}

class menuchart extends StatelessWidget {
  final double fs;
  final double cansz;

  menuchart({
    required this.fs,
    required this.cansz,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(PieChartData(
      startDegreeOffset: 45,
      sections: [
        PieChartSectionData(
            borderSide: BorderSide(color: Colors.black, width: 2),
            color: section(2, cansz),
            value: 6 / 24 * 100,
            titlePositionPercentageOffset: 0.5,
            title: "設定",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none),
            radius: MediaQuery.of(context).size.width / 4),
        PieChartSectionData(
            borderSide: BorderSide(color: Colors.black, width: 2),
            color: section(3, cansz),
            value: 6 / 24 * 100,
            titlePositionPercentageOffset: 0.5,
            titleStyle: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none),
            title: "単語帳",
            radius: MediaQuery.of(context).size.width / 4),
        PieChartSectionData(
            borderSide: BorderSide(color: Colors.black, width: 2),
            color: section(1, cansz),
            value: 6 / 24 * 100,
            titlePositionPercentageOffset: 0.5,
            titleStyle: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none),
            title: "英和・和英辞書",
            radius: MediaQuery.of(context).size.width / 4),
        PieChartSectionData(
            borderSide: BorderSide(color: Colors.black, width: 2),
            color: section(4, cansz),
            value: 6 / 24 * 100,
            titlePositionPercentageOffset: 0.5,
            titleStyle: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none),
            title: "クイズ",
            radius: MediaQuery.of(context).size.width / 4),
      ],
      sectionsSpace: 0,
      centerSpaceRadius: (MediaQuery.of(context).size.width) / 5,
    ));
  }
}

// class cansp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//         left: x0 - 50,
//         top: y0 + 50,
//         child: Container(
//           width: 100,
//           height: 100,
//           decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.black, width: 5)),
//         ));
//   }
// }

Positioned cansp(var X0, var Y0, var cansize, var ws) {
  print(Y0);
  return Positioned(
      left: X0 - cansize,
      top: Y0 - cansize + 75 - ((712 - ws) / 3),
      child: Container(
        width: cansize * 2,
        height: cansize * 2,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 5)),
      ));
}
