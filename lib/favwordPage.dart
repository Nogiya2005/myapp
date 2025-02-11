import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/dicdb.dart';
import 'package:myapp/editmeanPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'menuClass.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';

class favwordPage extends StatefulWidget {
  const favwordPage({Key? key, this.Word}) : super(key: key);
  final Favworddb? Word;
  @override
  State<favwordPage> createState() => _favwordPage();
}

class _favwordPage extends State<favwordPage> with RouteAware {
  List<Psmeandb> wordmeanlist = [];
  Favworddb? worddata;
  bool gessw = false;
  bool cansw = false;
  bool netsw = true;
  bool menuswitch = false;
  bool switchBool = false;
  String editBotton = "編集";
  Color? iconcolor = Colors.white;
  Color mycolor = Color(0xfff44336);
  int? key;
  String? dicname;
  String? word;
  FlutterTts? flutterTts;
  String text = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void Listswitch() {
    setState(() {
      switchBool = !switchBool;
    });
  }

  Color urliconcolor() {
    if (worddata!.url == "なし") {
      return Colors.grey;
    } else {
      return Colors.white;
    }
  }

  _loadFS() async {
    worddata = widget.Word;
    key = worddata!.key;
    dicname = worddata!.dicname;
    word = worddata!.word;
    wordmeanlist = await Psmeandb.getkeypsmean(key!, dicname!, word!);
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      netsw = prefs.getBool('netsw') ?? true;
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
    print("${wordmeanlist.length}");
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
            word!,
            style: TextStyle(fontSize: 28.sp),
          ),
          actions: [
            IconButton(
              iconSize: 28.sp,
              icon: Icon(
                Icons.hearing,
                color: Colors.white,
              ),
              onPressed: () {
                text = word!;
                print(text);
                onnsei(text, volume, language, voicespeed);
              },
            ),
          ],
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
                  itemCount: wordmeanlist.length,
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
                        title: Text("${wordmeanlist[index].mean}",
                            style: TextStyle(
                                fontSize: fs.sp,
                                color:
                                    Color(wordmeanlist[index].colornumber!))),
                        // trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: menuswitch == true
                            ? null
                            : () async {
                                print("選択");
                                setState(() {
                                  wordmeanlist[index].colornumber =
                                      mycolor.value;
                                });
                                Psmeandb updatedata = Psmeandb(
                                    dicname: dicname!,
                                    word: word!,
                                    key: key!,
                                    mean: wordmeanlist[index].mean!,
                                    colornumber:
                                        wordmeanlist[index].colornumber!);
                                await Psmeandb.updatepsmean(
                                    updatedata,
                                    key!,
                                    dicname!,
                                    word!,
                                    "${wordmeanlist[index].mean!}");
                              },
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
              print("x0=$x0" "," "y0=$y0");
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
                      iconSize: 28.sp,
                      icon: Icon(
                        Icons.info_outline,
                        color: urliconcolor(),
                      ),
                      onPressed: () async {
                        if (worddata!.url != 'なし') {
                          final url = Uri.parse(worddata!.url!);
                          var connectresult =
                              await Connectivity().checkConnectivity();
                          if (connectresult == ConnectivityResult.mobile) {
                            //モバイルネットワークの場合
                            print("Are you OK?");
                            if (netsw == true) {
                              await showDialog<void>(
                                context: context, //必須の引数
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('確認'),
                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('モバイルネットワークに接続されています'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('キャンセル'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('続行'),
                                        onPressed: () {
                                          launchUrl(url);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }

                          if (connectresult == ConnectivityResult.wifi) {
                            //WIFI接続の場合
                            print("OK");
                          }

                          if (connectresult == ConnectivityResult.none) {
                            //オフラインの場合
                            print("Please connect to the internet");
                            await showDialog<void>(
                              context: context, //必須の引数
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('エラー'),
                                  content: const SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('ネットに接続されていません'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: IconButton(
                      iconSize: 28.sp,
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => editmeanPage(
                                folderkey: key!,
                                dicname: dicname!,
                                word: word!,
                                meandata: wordmeanlist,
                              ),
                            ));
                      },
                    )),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        iconSize: 28.sp,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Pick a color!'),
                                  content: SingleChildScrollView(
                                    child: BlockPicker(
                                      pickerColor: mycolor, //default color
                                      onColorChanged: (Color color) {
                                        //on color picked
                                        setState(() {
                                          mycolor = color;
                                        });
                                        print("$mycolor");
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: const Text('DONE'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); //dismiss the color picker
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: Icon(
                          Icons.circle,
                          color: mycolor,
                        ))),
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
