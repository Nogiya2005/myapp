import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/OXquizPage.dart';
import 'package:myapp/listenquizPage.dart';
import 'package:myapp/spellingPage.dart';
import 'Sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dicdb.dart';
import 'menuClass.dart';
import 'main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom.dart';

class QuizfolderPage extends StatefulWidget {
  const QuizfolderPage({Key? key, this.next}) : super(key: key);
  final int? next;
  @override
  State<QuizfolderPage> createState() => _QuizfolderPage();
}

final _editController = TextEditingController();

class _QuizfolderPage extends State<QuizfolderPage> with RouteAware {
  bool gessw = false;
  bool cansw = false;
  List<Foldb> _foldata = [];
  bool switchBool = false;
  bool menuswitch = false;
  bool editBool = true;
  String editBotton = "編集";
  List<Favworddb> wordlist = [];
  Color? textfieldcolor = Colors.black;
  final _scaffoldKey = GlobalKey<ScaffoldState>(); //appbar.leading.icon

  Color? iconcolor = Colors.white;
  List<int> wordlistlengh = [];

  void Listswitch() {
    setState(() {
      switchBool = !switchBool;
    });
  }

  ScrollPhysics? wakaran() {
    var nazo;
    if (menuswitch == true) {
      nazo = NeverScrollableScrollPhysics();
    } else {
      nazo = ClampingScrollPhysics();
    }
    return nazo;
  }

  DismissDirection delete() {
    if (switchBool == true) {
      return DismissDirection.endToStart;
    } else {
      return DismissDirection.none;
    }
  }

  _loadFS() async {
    wordlistlengh.clear();
    final prefs = await SharedPreferences.getInstance();
    var foldata = await Foldb.getallfolders();
    for (int j = 0; j < foldata.length; j++) {
      var worddata = await Favworddb.getkeyfavword(foldata[j].keynumber!);
      print("${worddata.length}");
      wordlistlengh.add(worddata.length);
    }
    _editController.clear();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      gessw = prefs.getBool('gessw') ?? false;
      cansw = prefs.getBool('cansw') ?? false;
      cancelsize = prefs.getDouble('cancelsize') ?? 50;
      _foldata = foldata;
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
                      toolbarHeight: 60.sp,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: SizedBox(
                          width: 340.w,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextField(
                              style: TextStyle(fontSize: 25.sp),
                              enabled: true,
                              controller: _editController,
                              decoration: InputDecoration(
                                hintText: 'フォルダ検索',
                                hintStyle: TextStyle(
                                    color: textfieldcolor, fontSize: 25.sp),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: textfieldcolor,
                                  size: 28.sp,
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 8.0, top: 6.0, bottom: 4.0),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (String key) async {
                                var folderdata = await Foldb.getkeyfolders(key);
                                if (key.isNotEmpty == false) {
                                  var allfolders = await Foldb.getallfolders();
                                  setState(() {
                                    editBool = true;
                                    _foldata = allfolders;
                                  });
                                } else if (key.isNotEmpty == true) {
                                  setState(() {
                                    editBool = false;
                                    _foldata = folderdata;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      )),
                  body: GestureDetector(
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
                            Align(
                              child: ListView.builder(
                                physics: wakaran(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                itemCount: _foldata.length,
                                itemBuilder: (context, i) {
                                  if (wordlistlengh[i] == 0) {
                                    return IgnorePointer(
                                        key: Key('$i'),
                                        ignoring: menuswitch,
                                        child: Container(
                                            padding: const EdgeInsets.all(8),
                                            alignment: Alignment.centerLeft,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                color: Colors.black12,
                                              )),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                  '${_foldata[i].foldername}',
                                                  style: TextStyle(
                                                      fontSize: fs.sp,
                                                      color: Colors.grey)),
                                              trailing:
                                                  Icon(Icons.warning_amber),
                                            )));
                                  } else {
                                    return IgnorePointer(
                                        key: Key('$i'),
                                        ignoring: menuswitch,
                                        child: Container(
                                            padding: const EdgeInsets.all(8),
                                            alignment: Alignment.centerLeft,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                color: Colors.black12,
                                              )),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                  '${_foldata[i].foldername}',
                                                  style: TextStyle(
                                                      fontSize: fs.sp)),
                                              onTap: menuswitch == true
                                                  ? null
                                                  : () async {
                                                      if (switchBool == false) {
                                                        int? key = _foldata[i]
                                                            .keynumber;
                                                        var worddata =
                                                            await Favworddb
                                                                .getkeyfavword(
                                                                    key!);
                                                        wordlist = worddata;
                                                        print("フォルダ選択");
                                                        if (widget.next == 0 &&
                                                            wordlist.length >
                                                                0) {
                                                          Navigator.push(
                                                              context,
                                                              CustomPageRoute(
                                                                spellingPage(
                                                                  worddata:
                                                                      wordlist,
                                                                ),
                                                              ));
                                                        }
                                                        if (widget.next == 1 &&
                                                            wordlist.length >
                                                                0) {
                                                          Navigator.push(
                                                              context,
                                                              CustomPageRoute(
                                                                listenquizPage(
                                                                  worddata:
                                                                      wordlist,
                                                                ),
                                                              ));
                                                        }
                                                        if (widget.next == 2 &&
                                                            wordlist.length >
                                                                0) {
                                                          Navigator.push(
                                                              context,
                                                              CustomPageRoute(
                                                                OXquizPage(
                                                                  worddata:
                                                                      wordlist,
                                                                ),
                                                              ));
                                                        }
                                                      }
                                                    },
                                            )));
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                      )
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
                )),
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
      ]),
    );
  }
}
