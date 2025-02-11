import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/dicdb.dart';
import 'Sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menuClass.dart';
import 'main.dart';

class spellingPage extends StatefulWidget {
  const spellingPage({Key? key, this.worddata}) : super(key: key);
  final List<Favworddb>? worddata;
  @override
  State<spellingPage> createState() => _spellingPage();
}

class _spellingPage extends State<spellingPage> with RouteAware {
  bool gessw = false;
  bool cansw = false;
  bool menuswitch = false;
  List<int> indexList = [];
  bool answerswich = false;
  List<Favworddb> WordList = [];
  List<Favworddb> wordlist = [];
  List<Psmeandb> MeanList = [];
  List<Psmeandb> meanlist = [];
  int i = 0;
  String? youranswer;
  String? answertext;
  final TextEditingController _controller = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Color? answerbackcolor = Colors.blue[100];

  // void getmeandata(int key, String dicname, String word) async {
  //   var meandata = await Psmeandb.getkeyfolders(key, dicname, word);
  //   meanlist = meandata;
  //   setState(() {});
  // }

  _loadFS() async {
    wordlist = widget.worddata!;
    //ランダム化
    for (int l = 0; l < wordlist.length; l++) {
      indexList.add(l);
    }
    indexList.shuffle();
    //ここまで
    meanlist = await Psmeandb.getkeypsmean(wordlist[indexList[i]].key!,
        wordlist[indexList[i]].dicname!, wordlist[indexList[i]].word!);
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      gessw = prefs.getBool('gessw') ?? false;
      cansw = prefs.getBool('cansw') ?? false;
      cancelsize = prefs.getDouble('cancelsize') ?? 50;
      WordList = wordlist;
      MeanList = meanlist;
    });
  }

  String buttontext() {
    String text = "";
    if (answerswich == false) {
      text = "解答";
    } else {
      if (WordList.length <= i + 1) {
        text = "終了";
      } else {
        text = "次へ";
      }
    }

    return text;
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
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              size: 28.sp,
            ),
          ),
          centerTitle: true,
          title: Text(
            "スペルチェック",
            style: TextStyle(fontSize: 28.sp),
          ),
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
                                  style: TextStyle(fontSize: 30),
                                ),
                                title: Text("${MeanList[index].mean}",
                                    style: TextStyle(
                                        fontSize: fs.sp, color: Colors.black)),
                                // trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            );
                          },
                        )))),
              if (WordList.length > 0) //コピペOK
                Align(
                  alignment: Alignment(
                      0,
                      -((MediaQuery.of(context).size.height) / 2) /
                          MediaQuery.of(context).size.height),
                  child: SizedBox(
                    width: 350.w,
                    height: 100.h,
                    child: TextFormField(
                      enabled: !answerswich,
                      controller: _controller,
                      style: TextStyle(
                        fontSize: 25.sp,
                      ),
                      decoration: InputDecoration(
                          hintText: '答えを入力',
                          hintStyle:
                              TextStyle(fontSize: 25.sp, color: Colors.green),
                          fillColor: Colors.green[100],
                          filled: true,
                          focusedBorder: const OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 5.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.green[100]!,
                              width: 1.0,
                            ),
                          )),
                    ),
                  ),
                ),
              if (answerswich == true) //コピペOK
                Align(
                  alignment: Alignment(
                      0,
                      -((MediaQuery.of(context).size.height) / 2) /
                          MediaQuery.of(context).size.height),
                  child: Container(
                      // decoration: BoxDecoration(borderRadius: ),
                      color: answerbackcolor,
                      width: 350.sp,
                      height: 100.h,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          youranswer!,
                          style: TextStyle(fontSize: 25.sp),
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
                          style: TextStyle(fontSize: 25.sp),
                        ),
                      )),
                ),
              if (WordList.length > 0) //コピペOK
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
                          buttontext(),
                          style: TextStyle(fontSize: 25.sp),
                        ),
                        onPressed: menuswitch == true
                            ? null
                            : () async {
                                print(buttontext());
                                if (answerswich == false) {
                                  youranswer = _controller.text;
                                  if (youranswer ==
                                      WordList[indexList[i]].word) {
                                    answerbackcolor = Colors.blue[100];
                                    answertext = "正解";
                                  } else {
                                    answerbackcolor = Colors.red[100];
                                    answertext = WordList[indexList[i]].word;
                                  }
                                  answerswich = !answerswich;
                                  setState(() {});
                                  print("$answerswich");
                                } else if (answerswich == true) {
                                  i++;
                                  if (WordList.length <= i) {
                                    print("終了");
                                    Navigator.pop(context);
                                  } else {
                                    meanlist = await Psmeandb.getkeypsmean(
                                        wordlist[indexList[i]].key!,
                                        wordlist[indexList[i]].dicname!,
                                        wordlist[indexList[i]].word!);
                                    setState(() {
                                      MeanList = meanlist;
                                    });
                                    _controller.clear();
                                    answerswich = !answerswich;
                                    setState(() {});
                                    print("$answerswich");
                                  }
                                }
                              },
                      )),
                ),
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
              widgets.add(cansp(
                  x0, y0, cancelsize, MediaQuery.of(context).size.height));
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
