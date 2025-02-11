import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/dicdb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menuClass.dart';

class editmeanPage extends StatefulWidget {
  const editmeanPage(
      {Key? key, this.folderkey, this.dicname, this.word, this.meandata})
      : super(key: key);
  final folderkey;
  final dicname;
  final word;
  final List<Psmeandb>? meandata;
  @override
  State<editmeanPage> createState() => _editmeanPage();
}

class _editmeanPage extends State<editmeanPage> with RouteAware {
  int itemindex = 1;
  bool menuswitch = false;
  bool answerswich = false;
  List<Favworddb> WordList = [];
  List<Favworddb> wordlist = [];
  // List<Psmeandb> MeanList = [];
  List<Psmeandb> meanlist = [];
  List<TextEditingController> _controller =
      List.generate(30, (index) => TextEditingController());
  int j = 1;
  ScrollController _scrollController = ScrollController();
  // void getmeandata(int key, String dicname, String word) async {
  //   var meandata = await Psmeandb.getkeyfolders(key, dicname, word);
  //   meanlist = meandata;
  //   setState(() {});
  // }

  _loadFS() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < meanlist.length; i++) {
      _controller[i] = TextEditingController(text: meanlist[i].mean);
    }
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
    meanlist = widget.meandata!;
    itemindex = meanlist.length;
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
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.word),
          ),
          body: Column(
            children: [
              Flexible(
                  child: Container(
                      child: Stack(children: [
                Align(
                  child: Container(
                    color: Colors.black.withOpacity(0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black, width: 2.w)),
                        height: 600.h,
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
                                return Dismissible(
                                    background: Container(color: Colors.red),
                                    key: ObjectKey(_controller[index]),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      print("$j");
                                      _controller.removeAt(index);
                                      _controller.add(TextEditingController());
                                      itemindex = itemindex - 1;
                                      setState(() {});
                                      print("$itemindex");

                                      meanlist.removeAt(index);

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
                                  style: TextStyle(
                                      fontSize: 40.sp, color: Colors.blue),
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
                                          _scrollController
                                                  .position.maxScrollExtent +
                                              500,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.linear,
                                        );
                                      },
                              ),
                            )))),
                Align(
                  alignment: Alignment(
                      -1,
                      ((MediaQuery.of(context).size.height) / 1.2) /
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
                Align(
                  alignment: Alignment(
                      0,
                      ((MediaQuery.of(context).size.height) / 1.2) /
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
                          await Psmeandb.deletepsmean(
                              widget.folderkey!, widget.dicname!, widget.word);
                          for (int i = 0; i < itemindex; i++) {
                            if (_controller[i].text.isEmpty == false) {
                              if (i < meanlist.length) {
                                Psmeandb newinsertdata = Psmeandb(
                                    dicname: widget.dicname!,
                                    word: widget.word,
                                    mean: _controller[i].text,
                                    key: widget.folderkey!,
                                    colornumber: meanlist[i].colornumber);
                                await Psmeandb.insertpsmean(newinsertdata);
                              } else {
                                Psmeandb newinsertdata = Psmeandb(
                                    dicname: widget.dicname!,
                                    word: widget.word,
                                    mean: _controller[i].text,
                                    key: widget.folderkey!,
                                    colornumber: 4278190080);
                                await Psmeandb.insertpsmean(newinsertdata);
                              }
                            }
                          }
                          Navigator.pop(context);
                        },
                      )),
                ),
              ])))
            ],
          ),
        ),
        //ここから下は必須
      ]),
    );
  }
}
