import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ResultPage.dart';
import 'dicdb.dart';
import 'menuClass.dart';
import 'main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:universal_html/controller.dart';
import 'LoadingDialog.dart';
import 'package:translator/translator.dart';

class EJdicPage extends StatefulWidget {
  const EJdicPage({Key? key}) : super(key: key);
  final String title = "和英・英和辞書";
  @override
  State<EJdicPage> createState() => _EJdicPage();
}

var _editController = TextEditingController();

bool? languageswitch;
String? word;

//検索ボックスに入っている単語を取得
String keygen() {
  final key = _editController.text;
  return key;
}

//検索ボックスに入っている単語を取得
Future<String> scrapingkeygen() async {
  final key = _editController.text;
  if (key == "") {
    throw Exception();
  }
  word = key;
  return key;
}

class Word {
  final String dicname;
  final String title;
  final String mean;
  final String url;
  Word(this.dicname, this.title, this.mean, this.url);
}

final class Scraping {
  List<Word> wordList = [];
  List<String> wordurlList = [];
  Future<List<Word>> findWord(String _key) async {
    wordList.clear();
    wordurlList.clear();
    await weblioList("https://ejje.weblio.jp/content/$_key");
    await LingueeLlist(_key);
    await Future.delayed(const Duration(seconds: 3));
    return wordList;
  }

  //Weblio辞書
  Future<void> weblioList(url) async {
    //print("スクレイピング開始");
    const String dicname = "Weblio辞書";
    final controller = WindowController();
    await controller.openHttp(uri: Uri.parse(url));
    final japanesetitle = controller.window.document.querySelector(
        "#summary > div.summary-title-wrp > div.summary-title.h1WRuby > h1");
    if (japanesetitle != null) {
      //日本語を入力した結果
      languageswitch = true;
      final mean = controller.window.document.querySelector(
          "#summary > div.summaryM.descriptionWrp > p > span.content-explanation.je");
      if (mean != null) {
        final _japanesetitle = japanesetitle.text!;
        final _japanesemean = mean.text!;
        wordList.add(Word(dicname, _japanesetitle, _japanesemean, url));
        await Future.delayed(const Duration(seconds: 1));
      }
    } else if (japanesetitle == null) {
      //英語を入力したときの結果
      final englishtitle = controller.window.document.querySelector(
          "#summary > div.summary-title-wrp > div.summary-title > h1");
      final englishmean = controller.window.document.querySelector(
          "#summary > div.summaryM.descriptionWrp > p > span.content-explanation.ej");
      if (englishtitle == null || englishmean == null) {
        //print("英語htmlなし");
        throw Exception();
      } else {
        //print("英語htmlあり");
        languageswitch = false;
        final _englishtitle = englishtitle.text!;
        final _englishmean = englishmean.text!;
        wordList.add(Word(dicname, _englishtitle, _englishmean, url));
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  Future<void> LingueeLlist(key) async {
    print("get");
    var mainselect;
    const String dicname = "Linguee";
    List<String> wdlist = [];
    var result;
    var lingueeurl;
    lingueeurl =
        "https://www.linguee.jp/%E6%97%A5%E6%9C%AC%E8%AA%9E-%E8%8B%B1%E8%AA%9E/search?source=auto&query=$key";
    print("get");
    final controller = WindowController();
    await controller.openHttp(uri: Uri.parse(lingueeurl));
    if (languageswitch == true) {
      mainselect =
          "#dictionary > div.isMainTerm > div.exact > div > div > div > div > div > div";
    } else if (languageswitch == false) {
      mainselect =
          "#dictionary > div.isForeignTerm > div.exact > div > div > div > div > div";
    }
    final mainlist = controller.window.document.querySelectorAll(mainselect);
    for (final element in mainlist) {
      final main = element.querySelector('> h3 > span > a.dictLink.featured');
      if (main != null) {
        print("ok");
        final mainword = main.text!;
        wdlist.add(mainword);
      }
    }
    result = wdlist.join(",");
    wordList.add(Word(dicname, key, result, lingueeurl));
  }
}

class _EJdicPage extends State<EJdicPage> with RouteAware {
  bool menuswitch = false;
  bool gessw = false;
  bool cansw = false;
  bool netsw = true;
  final PageController pagecontroller = PageController(initialPage: 1);
  int _currentIndex = 1;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Color? textfieldcolor = Colors.black;
  //スクレイピング用
  final _scraping = Scraping();
  List<Word> _wordList = [];
//オフライン用
  List<Dicdb> _data = [];
  ScrollController _scrollController = ScrollController();

  _loadFS() async {
    var data = await Dicdb.getallwords("");
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      gessw = prefs.getBool('gessw') ?? false;
      cansw = prefs.getBool('cansw') ?? false;
      netsw = prefs.getBool('netsw') ?? true;
      cancelsize = prefs.getDouble('cancelsize') ?? 50;
      _data = data;
    });
  }

  Widget gettextfield() {
    if (_currentIndex == 0) {
      return Text(
        "翻訳",
        style: TextStyle(fontSize: 28.sp),
      );
    } else {
      return Padding(
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
              style: TextStyle(fontSize: 30.sp),
              enabled: true,
              controller: _editController,
              decoration: InputDecoration(
                hintText: '検索',
                hintStyle: TextStyle(color: textfieldcolor, fontSize: 30.sp),
                prefixIcon: Icon(
                  Icons.search,
                  color: textfieldcolor,
                  size: 30.sp,
                ),
                contentPadding:
                    EdgeInsets.only(left: 10, top: 6.0, bottom: 4.0),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
              ),
              onChanged: (String key) async {
                _scrollController.jumpTo(0.0);
                print(key);
                if (key.isEmpty == true) {
                  var data = await Dicdb.getallwords("");
                  if (data.length == 0) {
                    data = await Dicdb.getmeans("");
                  }
                  setState(() {
                    _data = data;
                  });
                } else {
                  var data = await Dicdb.getwords(key);
                  if (data.length == 0) {
                    data = await Dicdb.getmeans(key);
                  }
                  setState(() {
                    _data = data;
                  });
                }
              },
            ),
          ),
        ),
      );
    }
  }

  Widget getbutton() {
    if (_currentIndex == 2) {
      return IconButton(
        iconSize: 28.sp,
        icon: const Icon(
          Icons.travel_explore,
          color: Colors.white,
        ),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          //ローディング画面Open
          await showLoadingDialog(context: context);
          try {
            final _key = await scrapingkeygen();
            final tmpWordList = await _scraping.findWord(_key);
            //辞書選択生成
            setState(() {
              _wordList = tmpWordList;
            });
            // スナックバーでメッセージを表示
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('検索完了'),
              ),
            );
          } catch (e) {
            //辞書選択削除
            setState(() {
              _wordList.clear();
            });
            if (!mounted) return;
            // エラーダイアログ0pen
            await showDialog<void>(
              context: context, //必須の引数
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'エラー',
                    style: TextStyle(fontSize: titlesize.sp),
                  ),
                  content: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              '検索に失敗しました',
                              style: TextStyle(fontSize: 25.sp),
                            ),
                          ],
                        ),
                      )),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(fontSize: buttonsize.sp),
                      ),
                      onPressed: () {
                        //エラーダイヤログClose
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } finally {
            //ローディング画面Close
            Navigator.pop(context);
          }
        },
      );
    } else {
      return const Text("");
    }
  }

  Color dicbutton0() {
    Color bt0 = Colors.white;
    if (_currentIndex == 0) {
      bt0 = Colors.yellow;
    } else if (_currentIndex == 2 || _currentIndex == 1) {
      bt0 = Colors.white;
    }
    return bt0;
  }

  Color dicbutton1() {
    Color dicbt1 = Colors.white;
    if (_currentIndex == 1) {
      dicbt1 = Colors.yellow;
    } else if (_currentIndex == 2 || _currentIndex == 0) {
      dicbt1 = Colors.white;
    }
    return dicbt1;
  }

  Color dicbutton2() {
    Color dicbt2 = Colors.white;
    if (_currentIndex == 2) {
      dicbt2 = Colors.yellow;
    } else if (_currentIndex == 1 || _currentIndex == 0) {
      dicbt2 = Colors.white;
    }
    return dicbt2;
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
      netsw = prefs.getBool('netsw') ?? true;
      cancelsize = prefs.getDouble('cancelsize') ?? 50;
    });
  }

  void _translate({
    required String sourceText, // TextFieldに入力されたテキスト
    required String to, // 翻訳後の言語を指定（英語: en, 日本語: ja）
    required bool isTopField, // 上側のTextFieldか下側のTextFieldか判別
  }) async {
    if (sourceText.isEmpty) {
      return;
    }
    final translator = GoogleTranslator();
    // sourceTextを言語toに翻訳
    final translation = await translator.translate(
      sourceText,
      to: to,
    );
    // 翻訳結果をUIに反映
    if (isTopField) {
      _bottomController.text = translation.text;
    } else {
      _topController.text = translation.text;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadFS();
    _editController = TextEditingController(text: null);
  }

  TextEditingController _bottomController = TextEditingController();
  TextEditingController _topController = TextEditingController();

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
                resizeToAvoidBottomInset: false,
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
                    actions: [
                      getbutton(),
                    ],
                    toolbarHeight: 60.h,
                    title: gettextfield()),
                body: GestureDetector(
                  child: PageView(
                    physics: wakaran(menuswitch),
                    controller: pagecontroller,
                    children: <Widget>[
                      Column(children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                                padding: EdgeInsets.only(top: 60.h),
                                child: Container(
                                    height: 150.h,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.green)),
                                    child: Stack(children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10.h, 10, 2, 0),
                                              child: SizedBox(
                                                  width: 350.w,
                                                  height: 100.h,
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    enabled: !menuswitch,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'[a-zA-Z]'))
                                                    ],
                                                    controller: _topController,
                                                    style: TextStyle(
                                                      fontSize: 30.sp,
                                                    ),
                                                    decoration: InputDecoration(
                                                        hintText: '英語',
                                                        hintStyle: TextStyle(
                                                            fontSize: 30.sp,
                                                            color:
                                                                Colors.green),
                                                        fillColor:
                                                            Colors.green[100],
                                                        filled: true,
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                          // borderRadius: BorderRadius.circular(16),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.green,
                                                            width: 5.0,
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          // borderRadius: BorderRadius.circular(16),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .green[100]!,
                                                            width: 1.0,
                                                          ),
                                                        )),
                                                    onChanged: (value) {
                                                      if (value.isEmpty ==
                                                          true) {
                                                        _bottomController =
                                                            TextEditingController(
                                                                text: "");
                                                      } else {
                                                        _translate(
                                                            sourceText: value,
                                                            to: "ja",
                                                            isTopField: true);
                                                      }
                                                    },
                                                  )))),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.h, right: 10),
                                            child: IconButton(
                                              iconSize: 40.sp,
                                              icon: Icon(Icons.hearing),
                                              onPressed: () {
                                                onnsei(
                                                    _topController.text,
                                                    volume,
                                                    "en_US",
                                                    voicespeed);
                                              },
                                            ),
                                          ))
                                    ])))),
                        Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: Flexible(
                                child: Icon(
                              Icons.swap_vert,
                              size: 70.sp,
                            ))),
                        Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Container(
                                height: 150.h,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red)),
                                child: Stack(children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.h, 10, 2, 0),
                                          child: SizedBox(
                                              width: 350.w,
                                              height: 100.h,
                                              child: TextFormField(
                                                enabled: !menuswitch,
                                                controller: _bottomController,
                                                style: TextStyle(
                                                  fontSize: 30.sp,
                                                ),
                                                decoration: InputDecoration(
                                                    hintText: '日本語',
                                                    hintStyle: TextStyle(
                                                        fontSize: 30.sp,
                                                        color: Colors.red),
                                                    fillColor: Colors.red[100],
                                                    filled: true,
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      // borderRadius: BorderRadius.circular(16),
                                                      borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 5.0,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      // borderRadius: BorderRadius.circular(16),
                                                      borderSide: BorderSide(
                                                        color: Colors.red[100]!,
                                                        width: 1.0,
                                                      ),
                                                    )),
                                                onChanged: (value) {
                                                  if (value.isEmpty == true) {
                                                    _topController =
                                                        TextEditingController(
                                                            text: "");
                                                  } else {
                                                    _translate(
                                                        sourceText: value,
                                                        to: "en",
                                                        isTopField: false);
                                                  }
                                                },
                                              )))),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.h, right: 10),
                                        child: IconButton(
                                          iconSize: 40.sp,
                                          icon: const Icon(Icons.hearing),
                                          onPressed: () {
                                            onnsei(_bottomController.text,
                                                volume, 'ja', voicespeed);
                                          },
                                        ),
                                      ))
                                ]))),
                      ]),

                      //オフライン
                      Column(children: [
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
                            Align(
                              alignment: Alignment.topCenter,
                              //単語選択
                              child: Scrollbar(
                                  thickness: 10,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    physics: wakaran(menuswitch),
                                    shrinkWrap: true,
                                    itemCount: _data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Dicdb dicdata = _data[index];
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
                                          title: Text("${dicdata.word}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  TextStyle(fontSize: fs.sp)),
                                          subtitle: Text(
                                            "${dicdata.mean}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: fs.sp),
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            size: (MediaQuery.of(context)
                                                        .size
                                                        .height)
                                                    .toInt() /
                                                20,
                                          ),
                                          onTap: menuswitch == true
                                              ? null
                                              : () {
                                                  if (menuswitch == false) {
                                                    print("選択");
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .removeCurrentSnackBar();
                                                    //画面遷移
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ResultPage(
                                                                      dicname:
                                                                          'ejdict',
                                                                      Word: dicdata
                                                                          .word,
                                                                      Mean: dicdata
                                                                          .mean,
                                                                      url: 'なし',
                                                                      langsw:
                                                                          false,
                                                                    )));
                                                  }
                                                },
                                        ),
                                      );
                                    },
                                  )),
                            ),
                          ])),
                        )
                      ]),

                      Column(children: [
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
                            Align(
                              alignment: Alignment.topCenter,
                              //単語選択
                              child: ListView.builder(
                                physics: wakaran(menuswitch),
                                shrinkWrap: true,
                                itemCount: _wordList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    alignment: Alignment.centerLeft,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                        color: Colors.black12,
                                      )),
                                    ),
                                    child: ListTile(
                                      title: Text(_wordList[index].dicname,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: fs.sp)),
                                      trailing:
                                          const Icon(Icons.arrow_forward_ios),
                                      onTap: menuswitch == true
                                          ? null
                                          : () {
                                              print("選択");
                                              print(_wordList[index].dicname);
                                              print(word!);
                                              print(_wordList[index].mean);
                                              print(_wordList[index].url);
                                              print("${languageswitch!}");
                                              ScaffoldMessenger.of(context)
                                                  .removeCurrentSnackBar();
                                              //画面遷移
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResultPage(
                                                            dicname:
                                                                _wordList[index]
                                                                    .dicname,
                                                            Word: word!,
                                                            Mean:
                                                                _wordList[index]
                                                                    .mean,
                                                            url:
                                                                _wordList[index]
                                                                    .url,
                                                            langsw:
                                                                languageswitch!,
                                                          )));
                                            },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ])),
                        )
                      ]),
                    ],
                    onPageChanged: (value) async {
                      _currentIndex = value;
                      setState(() {});
                      if (value == 2 || value == 0) {
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
                                        Text(
                                            'モバイルネットワークに接続されていますが、ご利用になられますか？'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('キャンセル'),
                                      onPressed: () {
                                        setState(() {
                                          _currentIndex = 1;
                                        });
                                        pagecontroller.jumpToPage(1);
                                        Navigator.of(context).pop();
                                      },
                                    ),
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
                                        setState(() {
                                          _currentIndex = 1;
                                        });
                                        pagecontroller.jumpToPage(1);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]);
                            },
                          );
                        }
                      }
                    },
                  ),
                  onLongPressStart: (details) {
                    if (gessw == true) {
                      setState(() {
                        menuswitch = true;
                      });
                      print("${MediaQuery.of(context).size.height}");
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
                bottomNavigationBar: BottomAppBar(
                  height: 60.h,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            iconSize: 28.sp,
                            icon: Icon(Icons.translate, color: dicbutton0()),
                            onPressed: () {
                              setState(() {
                                _currentIndex = 0;
                              });
                              pagecontroller.jumpToPage(_currentIndex);
                            },
                          )),
                      Align(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                            iconSize: 28.sp,
                            icon: Icon(
                              Icons.wifi_off,
                              color: dicbutton1(),
                            ),
                            onPressed: () {
                              setState(() {
                                _currentIndex = 1;
                              });
                              pagecontroller.jumpToPage(_currentIndex);
                            },
                          )),
                      Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            iconSize: 28.sp,
                            icon: Icon(
                              Icons.wifi,
                              color: dicbutton2(),
                            ),
                            onPressed: () {
                              setState(() {
                                _currentIndex = 2;
                              });
                              pagecontroller.jumpToPage(_currentIndex);
                            },
                          )),
                    ],
                  ),
                ),
              )),
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
