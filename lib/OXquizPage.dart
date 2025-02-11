import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/dicdb.dart';
import 'Sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'menuClass.dart';

class OXquizPage extends StatefulWidget {
  const OXquizPage({Key? key, this.worddata}) : super(key: key);
  final List<Favworddb>? worddata;
  @override
  State<OXquizPage> createState() => _OXquizPage();
}

class spelldata {
  int? percent;
  String? before;
  String? after;
  spelldata({this.percent, this.before, this.after});
}

class _OXquizPage extends State<OXquizPage> with RouteAware {
  bool gessw = false;
  bool cansw = false;
  bool menuswitch = false;
  List<int> indexList = [];
  bool answerswich = false;
  List<Favworddb> WordList = [];
  List<Favworddb> wordlist = [];
  List<Psmeandb> MeanList = [];
  List<Psmeandb> meanlist = [];
  bool deEW = false;
  int i = 0;
  String? youranswer;
  String? answertext;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Color? answerbackcolor = Colors.blue[100];
  List<spelldata> spellList = [
    spelldata(percent: 30, before: 'ou', after: 'au'),
    spelldata(percent: 50, before: 'ce', after: 'se'),
    spelldata(percent: 50, before: "se", after: "ce"),
    spelldata(percent: 50, before: "ly", after: "ry"),
    spelldata(percent: 50, before: "ry", after: "ly"),
    spelldata(percent: 30, before: "ght", after: "gth"),
    spelldata(percent: 50, before: "th", after: "ht"),
    spelldata(percent: 40, before: "tch", after: "cth"),
    spelldata(percent: 50, before: "sea", after: "see"),
    spelldata(percent: 50, before: "see", after: "sea"),
    spelldata(percent: 40, before: "er", after: "or"),
    spelldata(percent: 30, before: "ent", after: "entation"),
    spelldata(percent: 40, before: "sion", after: "tion"),
    spelldata(percent: 40, before: "tion", after: "sion"),
    spelldata(percent: 30, before: "able", after: "albe"),
    spelldata(percent: 30, before: "al", after: "all"),
    spelldata(percent: 50, before: "ful", after: "full"),
    spelldata(percent: 30, before: "ter", after: "tar"),
    spelldata(percent: 20, before: "q", after: "p"),
    spelldata(percent: 20, before: "p", after: "q"),
    spelldata(percent: 30, before: "ci", after: "si"),
    spelldata(percent: 30, before: "si", after: "ci"),
    spelldata(percent: 20, before: "d", after: "b"),
    spelldata(percent: 20, before: "b", after: "d"),
  ];
  String? editword;

  void aj(bool edj, String aj) {
    print("判定$edj");
    if (edj == true) {
      if (aj == "まる") {
        answertext = "不正解:${WordList[indexList[i]].word}";
        answerbackcolor = Colors.red[100];
      } else if (aj == "ばつ") {
        answertext = "正解:${WordList[indexList[i]].word}";
        answerbackcolor = Colors.blue[100];
      }
    } else if (edj == false) {
      if (aj == "まる") {
        answertext = "正解:${WordList[indexList[i]].word}";
        answerbackcolor = Colors.blue[100];
      } else if (aj == "ばつ") {
        answertext = "不正解:${WordList[indexList[i]].word}";
        answerbackcolor = Colors.red[100];
      }
    }
    answerswich = !answerswich;
    setState(() {});
  }

  _loadFS() async {
    wordlist = widget.worddata!;
    //ランダム化
    for (int l = 0; l < wordlist.length; l++) {
      indexList.add(l);
    }
    indexList.shuffle();
    //ここまで
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      gessw = prefs.getBool('gessw') ?? false;
      cansw = prefs.getBool('cansw') ?? false;
      cancelsize = prefs.getDouble('cancelsize') ?? 59;
      WordList = wordlist;
    });
  }

  _loaddata() async {
    int min = 20;
    int max = 30;
    spellList.shuffle();
    var word = wordlist[indexList[i]].word;
    var splitword = word!.split("");
    print("${splitword.length}");
    print("$splitword");
    for (int j = 0; j < splitword.length - 1; j++) {
      if (splitword[j] == splitword[j + 1]) {
        var spra = math.Random();
        int splitp = spra.nextInt(max - min);
        print("変更確立${splitp + min}");
        var random = math.Random();
        if (random.nextInt(100) <= splitp + min) {
          print("変更しました。");
          splitword.removeAt(j);
          deEW = true;
          break;
        } else {
          min = 10;
        }
      }
    }
    if (deEW == true) {
      print("${splitword.length}");
      var WD = splitword.join();
      editword = WD;
    } else {
      for (int f = 0; f < spellList.length; f++) {
        print("${spellList[f].before}");
        print("${spellList[f].after}");
        var EW = word.replaceFirst(spellList[f].before!, spellList[f].after!);
        if (EW != word) {
          var edp = math.Random();
          if (edp.nextInt(100) < spellList[f].percent!) {
            editword = EW;
            deEW = true;
            print("変更しました");
            break;
          }
        } else {
          editword = wordlist[indexList[i]].word;
        }
      }
    }
    print(editword);
    meanlist = await Psmeandb.getkeypsmean(wordlist[indexList[i]].key!,
        wordlist[indexList[i]].dicname!, wordlist[indexList[i]].word!);
    setState(() {
      MeanList = meanlist;
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
    final prefs = await SharedPreferences.getInstance();
    cancelsize = 100;
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      gessw = prefs.getBool('gessw') ?? false;
      cansw = prefs.getBool('cansw') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFS();
    _loaddata();
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
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 60.h,
          leading: IconButton(
            iconSize: 28.sp,
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu,
            ),
          ),
          centerTitle: true,
          title: Text(
            "〇✕クイズ",
            style: TextStyle(fontSize: 28.sp),
          ),
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
              if (WordList.length > 0) //コピペOK
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black, width: 2.w)),
                        height: 340.h,
                        child: Flexible(
                            child: ListView.builder(
                          physics: wakaran(menuswitch),
                          shrinkWrap: true,
                          itemCount: MeanList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.centerLeft,
                              height: 160.h,
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                  color: Colors.black12,
                                )),
                              ),
                              child: ListTile(
                                  leading: Text(
                                    "・",
                                    style: TextStyle(fontSize: 28.sp),
                                  ),
                                  title: Text("${MeanList[index].mean}",
                                      style: TextStyle(
                                          fontSize: fs.sp,
                                          color: Color(
                                              MeanList[index].colornumber!)))
                                  // trailing: const Icon(Icons.arrow_forward_ios),
                                  ),
                            );
                          },
                        )))),
              Align(
                alignment: Alignment(
                    0,
                    -((MediaQuery.of(context).size.height) / 2) /
                        MediaQuery.of(context).size.height),
                child: Container(
                    color: answerbackcolor,
                    width: 350.sp,
                    height: 100.h,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        editword!,
                        style: TextStyle(fontSize: 30.sp),
                      ),
                    )),
              ),
              if (answerswich == true) //コピペOK
                Align(
                  alignment: Alignment(
                      0,
                      -((MediaQuery.of(context).size.height) / 1.2) /
                          MediaQuery.of(context).size.height),
                  child: Container(
                      color: Colors.blue[100],
                      width: 350.sp,
                      height: 100.h,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          answertext!,
                          style: TextStyle(fontSize: 30.sp),
                        ),
                      )),
                ),
              if (WordList.length > 0 && answerswich == true) //コピペOK
                Align(
                  alignment: Alignment(
                      0,
                      -((MediaQuery.of(context).size.height) / 7) /
                          MediaQuery.of(context).size.height),
                  child: SizedBox(
                      width: 150.w,
                      height: 80.h,
                      child: ElevatedButton(
                        child: Text(
                          "次へ",
                          style: TextStyle(fontSize: 30.sp),
                        ),
                        onPressed: menuswitch == true
                            ? null
                            : () async {
                                answerbackcolor = Colors.blue[100];
                                deEW = false;
                                print("リセット$deEW");
                                i++;
                                if (WordList.length <= i) {
                                  print("終了");
                                  Navigator.pop(context);
                                } else {
                                  _loaddata();
                                  answerswich = !answerswich;
                                  setState(() {});
                                  // print("$answerswich");
                                }
                              },
                      )),
                ),
              if (answerswich == false)
                Align(
                    alignment: Alignment(
                        -((MediaQuery.of(context).size.width) / 1.6) /
                            MediaQuery.of(context).size.width,
                        -((MediaQuery.of(context).size.height) / 6) /
                            MediaQuery.of(context).size.height),
                    child: IconButton(
                      iconSize: 100.sp,
                      icon: Icon(
                        Icons.circle_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        aj(deEW, "まる");
                      },
                    )),
              if (answerswich == false)
                Align(
                    alignment: Alignment(
                        ((MediaQuery.of(context).size.width) / 1.6) /
                            MediaQuery.of(context).size.width,
                        -((MediaQuery.of(context).size.height) / 6) /
                            MediaQuery.of(context).size.height),
                    child: IconButton(
                      iconSize: 120.sp,
                      icon: Icon(
                        Icons.close_outlined,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        aj(deEW, "ばつ");
                      },
                    ))
            ])))
          ]),
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
                sq = math.sqrt(X * X + Y * Y);
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
      ),
      //ここから下は必須
      if (menuswitch == true) Align(child: backblackcontainer()),
      if (menuswitch == true)
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
