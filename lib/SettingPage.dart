import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/dicdb.dart';
import 'Sidemenu.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'menuClass.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> with RouteAware {
  bool menuswitch = false;
  bool switchBool = false;
  bool gessw = false;
  bool cansw = false;
  bool netsw = true;
  double vl = 0.5;
  double sp = 0.5;
  String lang = "en-GB";
  String? lang2;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> itemlist = [
    "en-US",
    "en-GB",
    "en-IN",
    "en-AU",
    "en-IE",
    "en-ZA"
  ];
  List<String> items = ["アメリカ", "イギリス", "イングランド", "オーストラリア", "アイルランド", "南アフリカ"];
  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      netsw = prefs.getBool('netsw') ?? true;
      gessw = prefs.getBool('gessw') ?? false;
      cansw = prefs.getBool('cansw') ?? false;
      fs = prefs.getDouble('fontsize') ?? 19;
      vl = prefs.getDouble('vl') ?? 0.5;
      sp = prefs.getDouble('sp') ?? 0.5;
      lang = prefs.getString('lang') ?? "en-US";
      var index = itemlist.indexOf(lang);
      lang2 = items[index];
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
    widgets.clear();
    _loadFS();
  }

  @override
  void initState() {
    super.initState();
    widgets.clear();
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
          designSize: const Size(440, 906),
          builder: (context, child) => Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
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
                    '設定',
                    style: TextStyle(fontSize: 25.sp, fontFamily: 'Murecho'),
                  ),
                  toolbarHeight: 60.h,
                  centerTitle: true,
                ),
                body: GestureDetector(
                  child: SettingsList(
                    physics: wakaran(menuswitch),
                    sections: [
                      //セクション
                      SettingsSection(
                        title: Text(
                          'セクション',
                          style:
                              TextStyle(fontSize: fs.sp, fontFamily: 'Murecho'),
                        ),
                        tiles: [
                          CustomSettingsTile(
                            child: Container(
                              color: const Color(0xFFEFEFF4),
                              padding: const EdgeInsetsDirectional.only(
                                start: 14,
                                top: 20,
                                bottom: 0,
                                end: 14,
                              ),
                              child: Text(
                                'フォント',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                    fontSize: fs.sp,
                                    letterSpacing: -0.5,
                                    fontFamily: 'Murecho'),
                              ),
                            ),
                          ),
                          SettingsTile.navigation(
                            title: Text(
                              'フォントサイズ',
                              style: TextStyle(
                                  fontSize: fs.sp, fontFamily: 'Murecho'),
                            ),
                            value: Text(
                              "${fs - 14}",
                              style: TextStyle(
                                  fontSize: fs.sp, fontFamily: 'Murecho'),
                            ),
                            leading: Icon(
                              Icons.format_size,
                              size: fs + 4.sp,
                            ),
                            onPressed: menuswitch == true
                                ? null
                                : (context) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return fontsizeDialog();
                                        });
                                  },
                          ),
                          CustomSettingsTile(
                            child: Container(
                              color: const Color(0xFFEFEFF4),
                              padding: const EdgeInsetsDirectional.only(
                                start: 14,
                                top: 20,
                                bottom: 0,
                                end: 14,
                              ),
                              child: Text(
                                '読み上げ音声',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                    fontSize: fs.sp,
                                    letterSpacing: -0.5,
                                    fontFamily: 'Murecho'),
                              ),
                            ),
                          ),
                          SettingsTile.navigation(
                            title: Text(
                              '音量',
                              style: TextStyle(
                                  fontSize: fs.sp, fontFamily: 'Murecho'),
                            ),
                            value: Text(
                              (vl * 10).toStringAsFixed(1),
                              style: TextStyle(fontSize: fs.sp),
                            ),
                            leading: Icon(
                              Icons.volume_up,
                              size: fs + 4.sp,
                            ),
                            onPressed: menuswitch == true
                                ? null
                                : (context) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return volumeDialog();
                                        });
                                  },
                          ),
                          SettingsTile.navigation(
                            title: Text(
                              '速度',
                              style: TextStyle(
                                  fontSize: fs.sp, fontFamily: 'Murecho'),
                            ),
                            value: Text(
                              (sp * 10).toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: fs.sp, fontFamily: 'Murecho'),
                            ),
                            leading: Icon(
                              Icons.speed,
                              size: fs + 4.sp,
                            ),
                            onPressed: menuswitch == true
                                ? null
                                : (context) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return speedDialog();
                                        });
                                  },
                          ),
                          SettingsTile.navigation(
                            title: Text(
                              'アクセント',
                              style: TextStyle(
                                  fontSize: fs.sp, fontFamily: 'Murecho'),
                            ),
                            value: Text(
                              lang2!,
                              style: TextStyle(
                                  fontSize: fs.sp, fontFamily: 'Murecho'),
                            ),
                            leading: Icon(Icons.language, size: fs + 4.sp),
                            onPressed: menuswitch == true
                                ? null
                                : (context) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return languageDialog();
                                        });
                                  },
                          ),
                          CustomSettingsTile(
                            child: Container(
                              color: Color(0xFFEFEFF4),
                              padding: EdgeInsetsDirectional.only(
                                start: 14,
                                top: 20,
                                bottom: 0,
                                end: 14,
                              ),
                              child: Text(
                                'ジェスチャーメニュー',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                    fontSize: fs.sp,
                                    letterSpacing: -0.5,
                                    fontFamily: 'Murecho'),
                              ),
                            ),
                          ),
                          SettingsTile.switchTile(
                              initialValue: gessw,
                              onToggle: (value) async {
                                final ges =
                                    await SharedPreferences.getInstance();
                                ges.setBool('gessw', value);
                                gessw = value;
                                setState(() {});
                              },
                              title: Text(
                                "ジェスチャーメニュー",
                                style: TextStyle(
                                    fontSize: fs.sp, fontFamily: 'Murecho'),
                              )),
                          if (gessw == true)
                            SettingsTile.navigation(
                              title: Text(
                                'キャンセル範囲',
                                style: TextStyle(
                                    fontSize: fs.sp, fontFamily: 'Murecho'),
                              ),
                              // value: Text(
                              //   "${cancelsize / 10}",
                              //   style: TextStyle(fontSize: fs.sp),
                              // ),
                              leading:
                                  Icon(Icons.highlight_off, size: fs + 4.sp),
                              onPressed: menuswitch == true
                                  ? null
                                  : (context) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return cancelsizeDialog();
                                          });
                                    },
                            ),
                          if (gessw == true)
                            SettingsTile.switchTile(
                                initialValue: cansw,
                                onToggle: (value) async {
                                  final can =
                                      await SharedPreferences.getInstance();
                                  can.setBool('cansw', value);
                                  cansw = value;
                                  setState(() {});
                                },
                                title: Text(
                                  "キャンセルサポート",
                                  style: TextStyle(
                                      fontSize: fs.sp, fontFamily: 'Murecho'),
                                )),
                          CustomSettingsTile(
                            child: Container(
                              color: Color(0xFFEFEFF4),
                              padding: EdgeInsetsDirectional.only(
                                start: 14,
                                top: 20,
                                bottom: 0,
                                end: 14,
                              ),
                              child: Text(
                                'その他',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                    fontSize: fs.sp,
                                    letterSpacing: -0.5,
                                    fontFamily: 'Murecho'),
                              ),
                            ),
                          ),
                          SettingsTile.navigation(
                            title: Text(
                              '単語帳幅',
                              style: TextStyle(
                                  fontSize: fs.sp, fontFamily: 'Murecho'),
                            ),
                            // value: Text(
                            //   "${cancelsize / 10}",
                            //   style: TextStyle(fontSize: fs.sp),
                            // ),
                            leading: Icon(Icons.height, size: fs + 4.sp),
                            onPressed: menuswitch == true
                                ? null
                                : (context) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return widgetheightDialog();
                                        });
                                  },
                          ),
                          SettingsTile.switchTile(
                              initialValue: netsw,
                              onToggle: (value) async {
                                final netcheck =
                                    await SharedPreferences.getInstance();
                                netcheck.setBool('netsw', value);
                                netsw = value;
                                setState(() {});
                              },
                              title: Text(
                                "モバイルネット確認",
                                style: TextStyle(
                                    fontSize: fs.sp, fontFamily: 'Murecho'),
                              )),
                          SettingsTile.navigation(
                            title: Text(
                              '一括削除',
                              style: TextStyle(
                                  fontSize: fs.sp, fontFamily: 'Murecho'),
                              selectionColor: Colors.red,
                            ),
                            leading: Icon(Icons.delete, size: fs + 4.sp),
                            onPressed: menuswitch == true
                                ? null
                                : (context) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('本当に削除しますか？'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('キャンセル'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('OK'),
                                                onPressed: () async {
                                                  await Foldb.deleteallFol();
                                                  await Favworddb
                                                      .deleteallfavword();
                                                  await Psmeandb
                                                      .deleteallpsmean();
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setInt('keycounter', 0);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                          ),
                        ],
                      ),
                    ],
                  ),
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
                drawer: showsidemenu(fontsize: fs),
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
    ]));
  }
}

class fontsizeDialog extends StatefulWidget {
  @override
  State<fontsizeDialog> createState() => _fontsizeDialog();
}

class _fontsizeDialog extends State<fontsizeDialog> {
  double? fontsize;
  double fs = 20;
  double _sliderValue = 20.0;

  Future<void> saveFS(double sV) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontsize', sV);
  }

  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 20;
      _sliderValue = fs;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFS();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'フォントサイズ',
        style: TextStyle(fontSize: titlesize.sp),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${_sliderValue - 14}',
                        style: TextStyle(fontSize: _sliderValue.sp),
                      )),
                ],
              ),
            ),
            Slider(
              activeColor: Colors.orange,
              inactiveColor: Colors.blueAccent,
              value: _sliderValue,
              min: 15.0,
              max: 24.0,
              divisions: 18,
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                  fontsize = value;
                });
              },
              onChangeEnd: (value) {
                saveFS(value);
              },
            ),
          ])),
      actions: <Widget>[
        TextButton(
          child: Text(
            '閉じる',
            style: TextStyle(fontSize: buttonsize.sp),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // TextButton(
        //   child: Text(
        //     '保存',
        //     style: TextStyle(fontSize: buttonsize.sp),
        //   ),
        //   onPressed: () async {
        //     //OKを押したあとの処理
        //     saveFS(_sliderValue);
        //     Navigator.pop(context);
        //   },
        // ),
      ],
    );
  }
}

class cancelsizeDialog extends StatefulWidget {
  @override
  State<cancelsizeDialog> createState() => _cancelsizeDialog();
}

class _cancelsizeDialog extends State<cancelsizeDialog> {
  double fs = 19;
  double? cs;
  double _cs = 50;
  double _sliderValue = 50.0;

  Future<void> saveFS(double sV) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('cancelsize', sV);
  }

  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      _cs = prefs.getDouble('cancelsize') ?? 50;
      _sliderValue = _cs;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFS();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'キャンセル範囲',
        style: TextStyle(fontSize: titlesize.sp),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    width: _sliderValue * 2,
                    height: _sliderValue * 2,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 5)),
                  )
                ],
              ),
            ),
            Slider(
              activeColor: Colors.orange,
              inactiveColor: Colors.blueAccent,
              value: _sliderValue,
              min: 10.0,
              max: 100.0,
              divisions: 18,
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                  cs = value;
                });
              },
              onChangeEnd: (value) {
                saveFS(value);
              },
            ),
          ])),
      actions: <Widget>[
        TextButton(
          child: Text(
            '閉じる',
            style: TextStyle(fontSize: buttonsize.sp),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // TextButton(
        //   child: Text('保存', style: TextStyle(fontSize: buttonsize.sp)),
        //   onPressed: () async {
        //     //OKを押したあとの処理
        //     saveFS(_sliderValue);
        //     Navigator.pop(context);
        //   },
        // ),
      ],
    );
  }
}

class volumeDialog extends StatefulWidget {
  @override
  State<volumeDialog> createState() => _volumeDialog();
}

class _volumeDialog extends State<volumeDialog> {
  double fs = 19;
  double? vl;
  double _vl = 5.0;
  double _sliderValue = 5.0;

  Future<void> saveFS(double sV) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('vl', sV);
  }

  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      _vl = prefs.getDouble('vl') ?? 0.5;
      language = prefs.getString("lang") ?? "en-US";
      voicespeed = prefs.getDouble('sp') ?? 0.5;
      _sliderValue = _vl;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFS();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '読み上げ音量',
        style: TextStyle(fontSize: titlesize.sp),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        (_sliderValue * 10).toStringAsFixed(1),
                        style: TextStyle(fontSize: fs.sp),
                      )),
                ],
              ),
            ),
            Slider(
              activeColor: Colors.orange,
              inactiveColor: Colors.blueAccent,
              value: _sliderValue,
              min: 0.1,
              max: 1.0,
              divisions: 18,
              onChangeStart: (value) async {
                onnseistop();
              },
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                  vl = value;
                });
              },
              onChangeEnd: (value) {
                saveFS(value);
                onnsei("ok?", value, language, voicespeed);
              },
            ),
          ])),
      actions: <Widget>[
        TextButton(
          child: Text(
            '閉じる',
            style: TextStyle(fontSize: buttonsize.sp),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // TextButton(
        //   child: Text(
        //     '保存',
        //     style: TextStyle(fontSize: buttonsize.sp),
        //   ),
        //   onPressed: () async {
        //     //OKを押したあとの処理
        //     saveFS(_sliderValue);
        //     Navigator.pop(context);
        //   },
        // ),
      ],
    );
  }
}

class speedDialog extends StatefulWidget {
  @override
  State<speedDialog> createState() => _speedDialog();
}

class _speedDialog extends State<speedDialog> {
  double fs = 19;
  double? sp;
  double _sp = 0.5;
  double _sliderValue = 0.5;

  Future<void> saveFS(double sV) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('sp', sV);
  }

  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sp = prefs.getDouble('sp') ?? 0.5;
      fs = prefs.getDouble('fontsize') ?? 19;
      volume = prefs.getDouble('vl') ?? 1.0;
      language = prefs.getString('lang') ?? "en-US";
      _sliderValue = _sp;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFS();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '速度',
        style: TextStyle(fontSize: titlesize.sp),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        (_sliderValue * 10).toStringAsFixed(1),
                        style: TextStyle(fontSize: fs.sp),
                      )),
                ],
              ),
            ),
            Slider(
              activeColor: Colors.orange,
              inactiveColor: Colors.blueAccent,
              value: _sliderValue,
              min: 0.1,
              max: 1.0,
              divisions: 18,
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                  sp = value;
                });
              },
              onChangeEnd: (value) {
                saveFS(value);
                onnsei("ok?", volume, language, value);
              },
            ),
          ])),
      actions: <Widget>[
        TextButton(
          child: Text(
            '閉じる',
            style: TextStyle(fontSize: buttonsize.sp),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // ElevatedButton(
        //   child: Text(
        //     '保存',
        //     style: TextStyle(fontSize: buttonsize.sp),
        //   ),
        //   onPressed: () async {
        //     //OKを押したあとの処理
        //     saveFS(_sliderValue);
        //     Navigator.pop(context);
        //   },
        // ),
      ],
    );
  }
}

class languageDialog extends StatefulWidget {
  @override
  State<languageDialog> createState() => _languageDialog();
}

class _languageDialog extends State<languageDialog> {
  double fs = 20;
  String? lang;
  String? lang2;
  List<String> itemlist = [
    "en-US",
    "en-GB",
    "en-IN",
    "en-AU",
    "en-IE",
    "en-ZA"
  ];
  List<String> items = ["アメリカ", "イギリス", "イングランド", "オーストラリア", "アイルランド", "南アフリカ"];

  Future<void> saveFS(String sV) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', sV);
  }

  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      volume = prefs.getDouble('vl') ?? 1.0;
      lang = prefs.getString('lang') ?? "en-US";
      voicespeed = prefs.getDouble('sp') ?? 0.5;
      var index = itemlist.indexOf(lang!);
      lang2 = items[index];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFS();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'アクセント',
        style: TextStyle(fontSize: titlesize.sp),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SingleChildScrollView(
              child: ListBody(
                children: <Widget>[],
              ),
            ),
            DropdownButton(
              iconSize: 28.sp,
              itemHeight: 70.h,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: fs.sp),
                  ),
                );
              }).toList(),
              value: lang2,
              style: TextStyle(fontSize: 25.0, color: Colors.black),
              onChanged: (value) {
                lang2 = value;
                var index = items.indexOf(value!);
                lang = itemlist[index];
                saveFS(lang!);
                onnsei("ok?", volume, lang, voicespeed);
                setState(() {});
              },
            )
          ])),
      actions: <Widget>[
        TextButton(
          child: Text(
            '閉じる',
            style: TextStyle(fontSize: buttonsize.sp),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // ElevatedButton(
        //   child: Text(
        //     '保存',
        //     style: TextStyle(fontSize: buttonsize.sp),
        //   ),
        //   onPressed: () async {
        //     //OKを押したあとの処理
        //     saveFS(lang!);
        //     Navigator.pop(context);
        //   },
        // ),
      ],
    );
  }
}

class widgetheightDialog extends StatefulWidget {
  @override
  State<widgetheightDialog> createState() => _widgetheightDialog();
}

class _widgetheightDialog extends State<widgetheightDialog> {
  double fs = 19;
  double? wh;
  double _wh = 200;
  double _sliderValue = 200.0;

  Future<void> saveFS(double sV) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('wh', sV);
  }

  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      _wh = prefs.getDouble('wh') ?? 200;
      _sliderValue = _wh;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFS();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '単語帳幅',
        style: TextStyle(fontSize: titlesize.sp),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                      height: _sliderValue.h,
                      decoration: BoxDecoration(border: Border.all()))
                ],
              ),
            ),
            Slider(
              activeColor: Colors.orange,
              inactiveColor: Colors.blueAccent,
              value: _sliderValue,
              min: 100,
              max: 300,
              divisions: 20,
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                  wh = value;
                });
              },
              onChangeEnd: (value) {
                saveFS(value);
              },
            ),
          ])),
      actions: <Widget>[
        TextButton(
          child: Text(
            '閉じる',
            style: TextStyle(fontSize: buttonsize.sp),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
