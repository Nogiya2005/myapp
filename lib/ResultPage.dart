import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/EJregist.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration.dart';
import 'main.dart';
import 'menuClass.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Mean {
  Color? textcolor;
  String? wordmean;
  int? favmean;
  Mean({this.textcolor, this.wordmean, this.favmean});
}

class ResultPage extends StatefulWidget {
  const ResultPage(
      {Key? key, this.dicname, this.Word, this.Mean, this.url, this.langsw})
      : super(key: key);
  final dicname;
  final Word;
  final Mean;
  final url;
  final langsw;
  @override
  State<ResultPage> createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> with RouteAware {
  FlutterTts? flutterTts;
  String text = '';
  List meanList = <String>[];
  bool gessw = false;
  bool cansw = false;
  bool menuswitch = false;
  bool switchBool = false;
  String editBotton = "編集";
  Color? iconcolor = Colors.white;
  List<Mean> MeanList = [];
  Color mycolor = Color(0xfff44336);
  String? splitword;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void Listswitch() {
    setState(() {
      switchBool = !switchBool;
    });
  }

  Widget iconsw() {
    if (widget.langsw == true) {
      return Icon(
        Icons.hearing,
        size: 28.sp,
      );
    } else {
      return Text("");
    }
  }

  Widget iconbutton() {
    if (widget.langsw == false) {
      return IconButton(
        iconSize: 25.sp,
        icon: Icon(
          Icons.hearing,
          color: Colors.white,
        ),
        onPressed: () {
          if (widget.langsw == false) {
            text = widget.Word;
            print(text);
            onnsei(text, volume, language, voicespeed);
          }
        },
      );
    } else {
      return const Text("");
    }
  }

  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble("vl", 0.5);
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      volume = prefs.getDouble('vl') ?? 0.5;
      voicespeed = prefs.getDouble('sp') ?? 0.5;
      language = prefs.getString('lang') ?? "en-US";
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
    final mean = "${widget.Mean}";
    if (widget.dicname == "ejdict") {
      splitword = "/";
    } else if (widget.dicname == "Weblio辞書") {
      if (widget.langsw == true) {
        splitword = ";";
      } else if (widget.langsw == false) {
        splitword = "、";
      }
    } else if (widget.dicname == "Linguee") {
      splitword = ",";
    }
    meanList = mean.split(splitword!).toList();
    for (int i = 0; i < meanList.length; i++) {
      meanList[i] = meanList[i].replaceAll(RegExp(r'\s'), '');
      final Color? textcolors = Colors.black;
      MeanList.add(Mean(
          textcolor: textcolors, wordmean: meanList[i], favmean: 4278190080));
    }
    print("${MeanList.length}");
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
      Scaffold(
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
            "${widget.Word!}",
            style: TextStyle(fontSize: 25.sp),
          ),
          actions: [
            iconbutton(),
          ],
          toolbarHeight: 60.h,
        ),
        body: GestureDetector(
          child: Column(children: [
            Flexible(
                child: Container(
              child: Stack(fit: StackFit.expand, children: [
                Align(
                  child: Container(
                    color: Colors.black.withOpacity(0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
                Flexible(
                    child: ListView.builder(
                  physics: wakaran(menuswitch),
                  shrinkWrap: true,
                  itemCount: MeanList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                          color: Colors.black12,
                        )),
                      ),
                      child: ListTile(
                        leading: Text(
                          "・",
                          style: TextStyle(fontSize: 30),
                        ),
                        title: Text("${MeanList[index].wordmean}",
                            style: TextStyle(
                                fontSize: fs.sp,
                                color: MeanList[index].textcolor)),
                        // trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: menuswitch == true && widget.langsw == true
                            ? null
                            : () {
                                if (widget.langsw == true) {
                                  text = MeanList[index].wordmean!;
                                  print(text);
                                  onnsei(text, volume, language, voicespeed);
                                }
                              },
                        trailing: iconsw(),
                      ),
                    );
                  },
                )),
              ]),
            ))
          ]),
          onLongPressStart: (details) {
            if (switchBool == false && gessw == true) {
              setState(() {
                menuswitch = true;
              });
              print("開始");
              x0 = details.localPosition.dx;
              y0 = details.localPosition.dy;
              // print("x0=$x0" "," "y0=$y0");
              if (cansw == true) {
                widgets.add(cansp(
                    x0, y0, cancelsize, MediaQuery.of(context).size.height));
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
            if (menuswitch == true) {
              widgets.clear();

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
        bottomNavigationBar: BottomAppBar(
          height: 60.h,
          color: Theme.of(context).primaryColor,
          notchMargin: 6.0,
          shape: const AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                      onPressed: () {
                        if (widget.url != 'なし') {
                          final url = Uri.parse(widget.url);
                          launchUrl(url);
                        }
                      },
                    )),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.star_rate,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                      onPressed: () {
                        if (widget.langsw == false) {
                          print(meanList);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return registrationPage(
                                  dicname: widget.dicname!,
                                  word: widget.Word!,
                                  mean: MeanList, //謎
                                  url: widget.url!,
                                );
                              });
                        } else if (widget.langsw == true) {
                          print(meanList);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EJregistPage(
                                  dicname: widget.dicname!,
                                  word: widget.Word!,
                                  mean: MeanList, //謎
                                  url: widget.url!,
                                  itemlist: meanList,
                                );
                              });
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
      if (menuswitch == true && switchBool == false)
        Align(child: backblackcontainer()),
      if (menuswitch == true && switchBool == false)
        Align(
            alignment: Alignment.center,
            child: menuchart(
              fs: fs,
              cansz: cancelsize,
            )),
      ...widgets,
    ]));
  }
}
