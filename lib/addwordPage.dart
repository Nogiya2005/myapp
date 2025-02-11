import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/dicdb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menuClass.dart';

class addwordPage extends StatefulWidget {
  const addwordPage({Key? key, this.folderkey}) : super(key: key);
  final folderkey;
  @override
  State<addwordPage> createState() => _addwordPage();
}

class _addwordPage extends State<addwordPage> with RouteAware {
  int itemindex = 1;
  bool menuswitch = false;
  String dicname = "mine";
  bool answerswich = false;
  List<Favworddb> WordList = [];
  List<Favworddb> wordlist = [];
  List<Psmeandb> MeanList = [];
  List<Psmeandb> meanlist = [];
  final TextEditingController _wordcontroller = TextEditingController();
  List<TextEditingController> _controller =
      List.generate(30, (index) => TextEditingController());
  ScrollController _scrollController = ScrollController();

  // void getmeandata(int key, String dicname, String word) async {
  //   var meandata = await Psmeandb.getkeyfolders(key, dicname, word);
  //   meanlist = meandata;
  //   setState(() {});
  // }

  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   // 遷移時に呼ばれる関数
  //   // routeObserverに自身を設定
  //   super.didChangeDependencies();
  //   routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  // }

  // @override
  // void dispose() {
  //   routeObserver.unsubscribe(this);
  //   super.dispose();
  // }

  // // 上の画面がpopされて、この画面に戻ったときに呼ばれます
  // void didPopNext() async {
  //   debugPrint("didPopNext ${runtimeType}");
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     fs = prefs.getDouble('fontsize') ?? 20;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _loadFS();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("登録"),
      ),
      body: Column(children: [
        Flexible(
            child: Container(
                child: Stack(fit: StackFit.expand, children: [
          // Align(
          //   child: Container(
          //     color: Colors.black.withOpacity(0),
          //     width: MediaQuery.of(context).size.width,
          //     height: MediaQuery.of(context).size.height,
          //   ),
          // ),
          Align(
            alignment: Alignment(
                0,
                -((MediaQuery.of(context).size.height) / 1.1) /
                    MediaQuery.of(context).size.height),
            child: SizedBox(
              width: 350.w,
              height: 100.h,
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                enabled: !menuswitch,
                controller: _wordcontroller,
                style: TextStyle(
                  fontSize: 30.sp,
                ),
                decoration: InputDecoration(
                    hintText: '単語を入力',
                    hintStyle: TextStyle(fontSize: 30.sp, color: Colors.green),
                    fillColor: Colors.green[100],
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
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
          Align(
              alignment: Alignment.center,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.w)),
                  height: 500.h,
                  child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      body: ReorderableListView.builder(
                        scrollController: _scrollController,
                        physics: wakaran(menuswitch),
                        shrinkWrap: true,
                        itemCount: itemindex,
                        onReorder: (oldIndex, newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          _controller.insert(
                              newIndex, _controller.removeAt(oldIndex));
                          setState(() {});
                        },
                        itemBuilder: (BuildContext context, int index) {
                          // if (index == itemindex && itemindex < 30) {
                          //   return Container(
                          //       padding: const EdgeInsets.all(8),
                          //       alignment: Alignment.center,
                          //       height: 120.h,
                          //       decoration: const BoxDecoration(
                          //         border: Border(
                          //             bottom: BorderSide(
                          //           color: Colors.black12,
                          //         )),
                          //       ),
                          //       child: SizedBox(
                          //         height: 120.h,
                          //         width: MediaQuery.of(context).size.width,
                          //         child: IconButton(
                          //           icon: Icon(Icons.add),
                          //           onPressed: menuswitch == true
                          //               ? null
                          //               : () {
                          //                   if (itemindex == 29) {
                          //                     j = 0;
                          //                   }
                          //                   setState(() {
                          //                     itemindex++;
                          //                   });
                          //                   print("$itemindex");
                          //                   setState(() {});
                          //                 },
                          //         ),
                          //       ));
                          // }
                          // else {
                          return Dismissible(
                              key: ObjectKey(_controller[index]),
                              background: Container(color: Colors.red),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                _controller.removeAt(index);
                                _controller.add(TextEditingController());
                                itemindex = itemindex - 1;
                                // setState(() {});
                                print("$itemindex");

                                // _controller[meanlist.length] =
                                //     TextEditingController(text: "");

                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.centerLeft,
                                height: 120.h,
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
                                  title: TextFormField(
                                    enabled: !menuswitch,
                                    controller: _controller[index],
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: '意味を入力',
                                        hintStyle: TextStyle(
                                            fontSize: 30.sp,
                                            color: Colors.green),
                                        fillColor: Colors.green[100],
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(16),
                                          borderSide: const BorderSide(
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
                                  // trailing: const Icon(Icons.arrow_forward_ios),
                                ),
                              ));
                          // }
                        },
                      ),
                      bottomNavigationBar: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          child: Text(
                            "+",
                            style:
                                TextStyle(fontSize: 40.sp, color: Colors.blue),
                          ),
                          onPressed: menuswitch == true || itemindex == 30
                              ? null
                              : () {
                                  setState(() {
                                    itemindex++;
                                  });
                                  print("$itemindex");
                                  setState(() {});
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent +
                                        500,
                                    duration: Duration(milliseconds: 5),
                                    curve: Curves.linear,
                                  );
                                },
                        ),
                      )
                      // BottomAppBar(
                      //   height: 60.h,
                      //   color: Colors.blue,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Icon(
                      //         Icons.info,
                      //         color: Colors.white,
                      //         size: 40.sp,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      ))),
          Align(
            alignment: Alignment(
                0,
                ((MediaQuery.of(context).size.height) / 1.07) /
                    MediaQuery.of(context).size.height),
            child: SizedBox(
                width: 150.w,
                height: 100.h,
                child: ElevatedButton(
                  child: Text(
                    "保存",
                    style: TextStyle(fontSize: 30.sp),
                  ),
                  onPressed: () async {
                    var meanj = false;
                    if (_wordcontroller.text.isEmpty == false) {
                      var samewordj = await Favworddb.getkeysameword(
                          widget.folderkey!, dicname, _wordcontroller.text);
                      if (samewordj.isEmpty == true) {
                        for (int j = 0; j <= itemindex; j++) {
                          if (_controller[j].text.isEmpty == false) {
                            meanj = true;
                            break;
                          }
                        }
                        if (meanj == true) {
                          var favwordlist =
                              await Favworddb.getkeyfavword(widget.folderkey!);
                          var insertorderindex = favwordlist.length;
                          Favworddb favword = Favworddb(
                            dicname: dicname,
                            key: widget.folderkey!,
                            word: _wordcontroller.text,
                            ordernumber: insertorderindex,
                            colornumber: 4278190080,
                            url: 'なし',
                          );
                          await Favworddb.insertfavword(favword);
                          for (int i = 0; i < itemindex; i++) {
                            if (_controller[i].text.isEmpty == false) {
                              Psmeandb newinsertdata = Psmeandb(
                                  dicname: dicname,
                                  word: _wordcontroller.text,
                                  mean: _controller[i].text,
                                  key: widget.folderkey!,
                                  colornumber: 4278190080);
                              await Psmeandb.insertpsmean(newinsertdata);
                            }
                          }
                          Navigator.pop(context);
                        } else {
                          await showDialog<void>(
                            context: context, //必須の引数
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('エラー'),
                                content: const SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('意味が入力されていません。'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      //エラーダイヤログClose
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        await showDialog<void>(
                          context: context, //必須の引数
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('エラー'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('このフォルダ内に同じ単語が存在しています。'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    //エラーダイヤログClose
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      await showDialog<void>(
                        context: context, //必須の引数
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('エラー'),
                            content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('単語が入力されていません'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  //エラーダイヤログClose
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                )),
          ),
          Align(
            alignment: Alignment(
                -1,
                ((MediaQuery.of(context).size.height) / 1.07) /
                    MediaQuery.of(context).size.height),
            child: SizedBox(
                width: 150.w,
                height: 100.h,
                child: Container(
                  child: Text(
                    "${itemindex}/30",
                    style: TextStyle(fontSize: 40),
                  ),
                )),
          ),
        ])))
      ]),
    );
  }
}
