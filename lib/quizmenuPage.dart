import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/quizfolderPage.dart';
import 'Sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menuClass.dart';
import 'main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizmenuPage extends StatefulWidget {
  const QuizmenuPage({Key? key}) : super(key: key);
  final String title = "和英・英和辞書";
  @override
  State<QuizmenuPage> createState() => _QuizmenuPage();
}

class _QuizmenuPage extends State<QuizmenuPage> with RouteAware {
  bool gessw = false;
  bool cansw = false;
  bool menuswitch = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // final PageController controller = PageController(initialPage: 1);
  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      gessw = prefs.getBool('gessw') ?? false;
      cansw = prefs.getBool('cansw') ?? false;
      cancelsize = prefs.getDouble('cancelsize') ?? 50;
    });
  }

  @override
  void didChangeDependencies() {
    // 遷移時に呼ばれる関数
    // routeObserverに自身を設定
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // 上の画面がpopされて、この画面に戻ったときに呼ばれます
  void didPopNext() async {
    debugPrint("didPopNext ${runtimeType}");
    _loadFS();
  }

  @override
  void initState() {
    super.initState();
    _loadFS();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(alignment: Alignment.center, children: [
        Align(
          child: Container(
            color: Colors.black.withOpacity(0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        ScreenUtilInit(
            designSize: Size(440, 906),
            builder: (context, child) => Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                    centerTitle: true,
                    leading: IconButton(
                      iconSize: 28.sp,
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                      ),
                    ),
                    title: Text(
                      "クイズ",
                      style: TextStyle(fontSize: 28.sp),
                    ),
                    toolbarHeight: 60.h,
                  ),
                  body: GestureDetector(
                    child: Container(
                        child: Column(children: [
                      Flexible(
                        child: Container(
                            child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Align(
                              child: Container(
                                color: Colors.black.withOpacity(0),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 60.h),
                                    child: SizedBox(
                                        height: 150.h,
                                        width: 300.w,
                                        child: ElevatedButton(
                                          onPressed: menuswitch == true
                                              ? null
                                              : () {
                                                  print("スペルチェック");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              QuizfolderPage(
                                                                next: 0,
                                                              )));
                                                },
                                          child: Text(
                                            'スペルチェック',
                                            style: TextStyle(fontSize: 28.sp),
                                          ),
                                        ))),
                                Padding(
                                    padding: EdgeInsets.only(top: 60.h),
                                    child: SizedBox(
                                        height: 150.h,
                                        width: 300.w,
                                        child: ElevatedButton(
                                          onPressed: menuswitch == true
                                              ? null
                                              : () {
                                                  print("リスニング");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              QuizfolderPage(
                                                                next: 1,
                                                              )));
                                                },
                                          child: Text(
                                            'リスニング',
                                            style: TextStyle(fontSize: 28.sp),
                                          ),
                                        ))),
                                Padding(
                                    padding: EdgeInsets.only(top: 60.h),
                                    child: SizedBox(
                                        height: 150.h,
                                        width: 300.w,
                                        child: ElevatedButton(
                                          onPressed: menuswitch == true
                                              ? null
                                              : () {
                                                  print("〇✕クイズ");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              QuizfolderPage(
                                                                next: 2,
                                                              )));
                                                },
                                          child: Text(
                                            '〇✖',
                                            style: TextStyle(fontSize: 28.sp),
                                          ),
                                        ))),
                              ],
                            ),
                          ],
                        )),
                      )
                    ])),
                    onLongPressStart: (details) {
                      if (gessw == true) {
                        setState(() {
                          menuswitch = true;
                        });
                        print("開始");
                        x0 = details.localPosition.dx;
                        y0 = details.localPosition.dy;
                        // print("x0=$x0" "," "y0=$y0");
                        if (cansw == true) {
                          widgets.add(cansp(x0, y0, cancelsize,
                              MediaQuery.of(context).size.height));
                        }
                      }
                    },
                    onLongPressMoveUpdate: (details) {
                      if (menuswitch == true) {
                        x = details.localPosition.dx;
                        y = details.localPosition.dy;
                        // print("x=$x" "," "y=$y");
                        setState(() {
                          X = x - x0;
                          Y = y0 - y;
                          sq = sqrt(X * X + Y * Y);
                          ab = Y / X;
                        });
                        // print("x=$X" "," "y=$Y");
                      }
                    },
                    onLongPressEnd: (details) {
                      print("ゆるさない");
                      widgets.clear();
                      if (menuswitch == true) {
                        if (sq <= cancelsize) {
                          print("キャンセル");
                        } else if ((ab.abs() >= 1 || X == 0) && Y > 0) {
                          print("上");
                          int a = 1;
                          nanikore(context, a);
                        } else if ((ab.abs() >= 1 || X == 0) && Y < 0) {
                          print("下");
                          int a = 2;
                          nanikore(context, a);
                        } else if ((ab.abs() < 1 || Y == 0) && X < 0) {
                          print("左");
                          int a = 3;
                          nanikore(context, a);
                        } else if ((ab.abs() < 1 || Y == 0) && X > 0) {
                          print("右");
                          int a = 4;
                          nanikore(context, a);
                        }
                        setState(() {
                          sq = 0;
                          menuswitch = false;
                        });
                      }
                    },
                  ),
                  drawer: showsidemenu(
                    fontsize: fs,
                  ),
                )),
        if (menuswitch == true) Align(child: backblackcontainer()),
        if (menuswitch == true)
          Align(
              alignment: Alignment.center,
              child: menuchart(
                fs: fs,
                cansz: cancelsize,
              )),
        ...widgets,
      ]),
    );
  }
}
