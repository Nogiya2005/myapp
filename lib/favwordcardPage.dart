import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/addwordPage.dart';
import 'package:myapp/favwordPage.dart';
import 'Sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dicdb.dart';
import 'menuClass.dart';
import 'main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class favwordcardPage extends StatefulWidget {
  const favwordcardPage({Key? key, this.folderkey}) : super(key: key);
  final int? folderkey;
  @override
  State<favwordcardPage> createState() => _favwordcardPage();
}

final _editController = TextEditingController();

class _favwordcardPage extends State<favwordcardPage> with RouteAware {
  bool gessw = false;
  bool cansw = false;
  List<Favworddb> _favworddata = [];
  bool switchBool = false;
  bool menuswitch = false;
  bool editBool = true;
  String editBotton = "編集";
  Color? textfieldcolor = Colors.black;
  List<String> mean = [];
  List<String> Meanlist = [];
  String? MEAN;
  Color mycolor = Color(0xfff44336);
  bool piccolor = false;
  ScrollController _scrollController = ScrollController();
  final List<String> items = [
    'ejdict',
    'Weblio辞書',
    'Linguee',
    "mine",
  ];
  List<String> selectedItems = ['ejdict', 'Weblio辞書', 'Linguee', "mine"];

  Color iconcolor = Colors.white;
  Color iconcolor2 = Colors.white;
  List<Psmeandb> meandatalist = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double listposition = 0.0;

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

  Widget coloriconsw() {
    if (switchBool == true) {
      return IconButton(
          onPressed: () {
            piccolor = true;
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
            size: 40,
          ));
    } else {
      return Text("");
    }
  }

  _loaddata() async {
    if (selectedItems.length == 4) {
      _favworddata.clear();
      Meanlist.clear();
      mean.clear();
      setState(() {});
      int? key = widget.folderkey;
      var favworddata = await Favworddb.getkeyfavword(key!);
      print(favworddata.toString());
      for (int j = 0; j < favworddata.length; j++) {
        meandatalist.clear();
        meandatalist = await Psmeandb.getkeycolorpsmean(
            favworddata[j].key!, favworddata[j].dicname!, favworddata[j].word!);
        if (meandatalist.length == 0) {
          meandatalist.clear();
          meandatalist = await Psmeandb.getkeypsmean(favworddata[j].key!,
              favworddata[j].dicname!, favworddata[j].word!);
        }
        MEAN = "${meandatalist[0].mean}";
        for (int i = 1; i < meandatalist.length; i++) {
          MEAN = "$MEAN" + "/" + "${meandatalist[i].mean}";
        }
        mean.add(MEAN!);
      }

      Meanlist = mean;
      _favworddata = favworddata;
      // await Future.delayed(
      //     const Duration(
      //         milliseconds: 700));
    } else if (selectedItems.length == 3) {
      _favworddata.clear();
      Meanlist.clear();
      mean.clear();
      setState(() {});
      int? key = widget.folderkey;
      var favworddata = await Favworddb.get3dicword(
          key!, selectedItems[0], selectedItems[1], selectedItems[2]);
      for (int j = 0; j < favworddata.length; j++) {
        meandatalist.clear();
        meandatalist = await Psmeandb.getkeycolorpsmean(
            favworddata[j].key!, favworddata[j].dicname!, favworddata[j].word!);
        if (meandatalist.length == 0) {
          meandatalist.clear();
          meandatalist = await Psmeandb.getkeypsmean(favworddata[j].key!,
              favworddata[j].dicname!, favworddata[j].word!);
        }
        MEAN = "${meandatalist[0].mean}";
        for (int i = 1; i < meandatalist.length; i++) {
          MEAN = "$MEAN" + "/" + "${meandatalist[i].mean}";
        }
        mean.add(MEAN!);
      }

      Meanlist = mean;
      _favworddata = favworddata;
    } else if (selectedItems.length == 2) {
      _favworddata.clear();
      Meanlist.clear();
      mean.clear();
      setState(() {});
      int? key = widget.folderkey;
      var favworddata =
          await Favworddb.get2dicword(key!, selectedItems[0], selectedItems[1]);
      for (int j = 0; j < favworddata.length; j++) {
        meandatalist.clear();
        meandatalist = await Psmeandb.getkeycolorpsmean(
            favworddata[j].key!, favworddata[j].dicname!, favworddata[j].word!);
        if (meandatalist.length == 0) {
          meandatalist.clear();
          meandatalist = await Psmeandb.getkeypsmean(favworddata[j].key!,
              favworddata[j].dicname!, favworddata[j].word!);
        }
        MEAN = "${meandatalist[0].mean}";
        for (int i = 1; i < meandatalist.length; i++) {
          MEAN = "$MEAN" + "/" + "${meandatalist[i].mean}";
        }
        mean.add(MEAN!);
      }

      Meanlist = mean;
      _favworddata = favworddata;
      // await Future.delayed(
      //     const Duration(
      //         milliseconds: 700));
    } else if (selectedItems.length == 1) {
      _favworddata.clear();
      Meanlist.clear();
      mean.clear();
      setState(() {});
      int? key = widget.folderkey;
      var favworddata = await Favworddb.get1dicword(key!, selectedItems[0]);
      for (int j = 0; j < favworddata.length; j++) {
        meandatalist.clear();
        meandatalist = await Psmeandb.getkeycolorpsmean(
            favworddata[j].key!, favworddata[j].dicname!, favworddata[j].word!);
        if (meandatalist.length == 0) {
          meandatalist.clear();
          meandatalist = await Psmeandb.getkeypsmean(favworddata[j].key!,
              favworddata[j].dicname!, favworddata[j].word!);
        }
        MEAN = "${meandatalist[0].mean}";
        for (int i = 1; i < meandatalist.length; i++) {
          MEAN = "$MEAN" + "/" + "${meandatalist[i].mean}";
        }
        mean.add(MEAN!);
      }

      Meanlist = mean;
      _favworddata = favworddata;
      // await Future.delayed(
      //     const Duration(
      //         milliseconds: 700));
    } else if (selectedItems.length == 0) {
      _favworddata.clear();
      Meanlist.clear();
      mean.clear();
    }
    setState(() {});
    _scrollController.jumpTo(listposition);
  }

  _loadFS() async {
    _favworddata.clear();
    Meanlist.clear();
    mean.clear();
    setState(() {});
    int? key = widget.folderkey;
    final prefs = await SharedPreferences.getInstance();
    var favworddata = await Favworddb.getkeyfavword(key!);
    for (int j = 0; j < favworddata.length; j++) {
      meandatalist.clear();
      meandatalist = await Psmeandb.getkeycolorpsmean(
          favworddata[j].key!, favworddata[j].dicname!, favworddata[j].word!);
      if (meandatalist.length == 0) {
        meandatalist.clear();
        meandatalist = await Psmeandb.getkeypsmean(
            favworddata[j].key!, favworddata[j].dicname!, favworddata[j].word!);
      }
      MEAN = "${meandatalist[0].mean}";
      for (int i = 1; i < meandatalist.length; i++) {
        MEAN = "$MEAN" + " / " + "${meandatalist[i].mean}";
      }
      mean.add(MEAN!);
    }

    Meanlist = mean;
    fs = prefs.getDouble('fontsize') ?? 19;
    gessw = prefs.getBool('gessw') ?? false;
    cansw = prefs.getBool('cansw') ?? false;
    cancelsize = prefs.getDouble('cancelsize') ?? 50;
    widgetheight = prefs.getDouble('wh') ?? 200;
    _favworddata = favworddata;
    // await Future.delayed(const Duration(milliseconds: 700));
    setState(() {});
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

  //この画面から別の画面にpushしたときに呼ばれる
  void didPushNext() {
    debugPrint("didPushNext ${runtimeType}");

    listposition = _scrollController.position.pixels;
  }

  // 上の画面がpopされて、この画面に戻ったときに呼ばれます
  void didPopNext() async {
    if (piccolor == false) {
      debugPrint("didPopNext ${runtimeType}");
      final prefs = await SharedPreferences.getInstance();
      fs = prefs.getDouble('fontsize') ?? 19;
      gessw = prefs.getBool('gessw') ?? false;
      cansw = prefs.getBool('cansw') ?? false;
      cancelsize = prefs.getDouble('cancelsize') ?? 50;
      widgetheight = prefs.getDouble('wh') ?? 200;
      _loaddata();
      setState(() {});
      // print("確認$listposition");
      // _loadFS();
    } else if (piccolor == true) {
      piccolor = false;
    }
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
                    title: Text(
                      "単語帳",
                      style: TextStyle(fontSize: titlesize.sp),
                    ),
                    centerTitle: true,
                  ),
                  body: GestureDetector(
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  iconStyleData: IconStyleData(iconSize: 28.sp),
                                  isExpanded: true,
                                  hint: Text(
                                    '辞書選択',
                                    style: TextStyle(
                                      fontSize: (25 - ((25 - fs) / 1.8)).sp,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: items.map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      //disable default onTap to avoid closing menu when selecting an item
                                      enabled: false,
                                      child: StatefulBuilder(
                                        builder: (context, menuSetState) {
                                          final isSelected =
                                              selectedItems.contains(item);
                                          return InkWell(
                                            onTap: () async {
                                              isSelected
                                                  ? selectedItems.remove(item)
                                                  : selectedItems.add(item);
                                              //This rebuilds the StatefulWidget to update the button's text
                                              print(selectedItems.toString());
                                              setState(() {});
                                              //This rebuilds the dropdownMenu Widget to update the check mark
                                              menuSetState(() {});
                                            },
                                            child: Container(
                                              height: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: Row(
                                                children: [
                                                  if (isSelected)
                                                    Icon(
                                                      Icons.check_box_outlined,
                                                      size: 28.sp,
                                                    )
                                                  else
                                                    Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                      size: 28.sp,
                                                    ),
                                                  SizedBox(width: 16.w),
                                                  Expanded(
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                        fontSize: (25 -
                                                                ((25 - fs) /
                                                                    1.8))
                                                            .sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                  //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                  value: selectedItems.isEmpty
                                      ? null
                                      : selectedItems.last,
                                  onChanged: (value) {},
                                  selectedItemBuilder: (context) {
                                    return items.map(
                                      (item) {
                                        return Container(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: Text(
                                            selectedItems.join(', '),
                                            style: TextStyle(
                                              fontSize:
                                                  (25 - ((25 - fs) / 1.8)).sp,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1,
                                          ),
                                        );
                                      },
                                    ).toList();
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 8),
                                    height: 70.h,
                                    width: 140,
                                  ),
                                  menuItemStyleData: MenuItemStyleData(
                                    height: 70.h,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            )
                          ])),
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
                                child: Scrollbar(
                              thickness: 10,
                              child: ReorderableListView.builder(
                                scrollController: _scrollController,
                                scrollDirection: Axis.vertical,
                                buildDefaultDragHandles: switchBool,
                                physics: wakaran(),
                                // padding: const EdgeInsets.symmetric(horizontal: 40),
                                itemCount: _favworddata.length,
                                itemBuilder: (context, i) {
                                  return Dismissible(
                                      direction: delete(),
                                      background: Container(color: Colors.red),
                                      key: ObjectKey(_favworddata[i]),
                                      onDismissed:
                                          (DismissDirection direction) async {
                                        await Psmeandb.deletepsmean(
                                            _favworddata[i].key,
                                            _favworddata[i].dicname,
                                            _favworddata[i].word);
                                        await Favworddb.deletefavword(
                                            _favworddata[i].key,
                                            _favworddata[i].dicname,
                                            _favworddata[i].word);

                                        _favworddata.removeAt(i);
                                        Meanlist.removeAt(i);

                                        if (i < _favworddata.length) {
                                          for (int j = _favworddata.length;
                                              i < j;
                                              i++) {
                                            print("INDEX=$i");
                                            print("${_favworddata[i].key}");
                                            print("${_favworddata[i].dicname}");
                                            print("${_favworddata[i].word}");
                                            print(
                                                "${_favworddata[i].ordernumber}");
                                            var updatekey = _favworddata[i].key;
                                            var updatedicname =
                                                _favworddata[i].dicname;
                                            var updateword =
                                                _favworddata[i].word;
                                            var updatecolor =
                                                _favworddata[i].colornumber;
                                            var updateurl = _favworddata[i].url;
                                            Favworddb updata = Favworddb(
                                              dicname: updatedicname,
                                              word: updateword,
                                              key: updatekey,
                                              ordernumber: i,
                                              colornumber: updatecolor,
                                              url: updateurl,
                                            );
                                            await Favworddb.updatefavword(
                                                updata,
                                                updatekey!,
                                                updatedicname!,
                                                updateword!);
                                          }
                                        }
                                        setState(() {});
                                      },
                                      child: IgnorePointer(
                                          key: Key('$i'),
                                          ignoring: menuswitch,
                                          child: GestureDetector(
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              alignment: Alignment.centerLeft,
                                              height: widgetheight.h,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              child: ListTile(
                                                  minLeadingWidth: 100.w,
                                                  leading: Text(
                                                    '${_favworddata[i].word}',
                                                    style: TextStyle(
                                                      height: 1,
                                                      fontSize: fs.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(
                                                          _favworddata[i]
                                                              .colornumber!),
                                                    ),
                                                  ),
                                                  title: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border()),
                                                      child:
                                                          SingleChildScrollView(
                                                              physics:
                                                                  wakaran(),
                                                              child: Text(
                                                                "${Meanlist[i]}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      fs.sp,
                                                                ),
                                                              )))),
                                            ),
                                            onTap: menuswitch == true
                                                ? null
                                                : () async {
                                                    if (switchBool == false) {
                                                      print("ワード選択");
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    favwordPage(
                                                              Word:
                                                                  _favworddata[
                                                                      i],
                                                            ),
                                                          ));
                                                    } else if (switchBool ==
                                                        true) {
                                                      _favworddata[i]
                                                              .colornumber =
                                                          mycolor.value;
                                                      setState(() {});
                                                      Favworddb updatedata =
                                                          Favworddb(
                                                              dicname:
                                                                  _favworddata[
                                                                          i]
                                                                      .dicname,
                                                              word:
                                                                  _favworddata[
                                                                          i]
                                                                      .word,
                                                              key: _favworddata[
                                                                      i]
                                                                  .key,
                                                              ordernumber:
                                                                  _favworddata[
                                                                          i]
                                                                      .ordernumber,
                                                              colornumber:
                                                                  _favworddata[
                                                                          i]
                                                                      .colornumber,
                                                              url: _favworddata[
                                                                      i]
                                                                  .url);
                                                      await Favworddb
                                                          .updatefavword(
                                                              updatedata,
                                                              _favworddata[i]
                                                                  .key!,
                                                              _favworddata[i]
                                                                  .dicname!,
                                                              _favworddata[i]
                                                                  .word!);
                                                    }
                                                  },
                                          )));
                                },
                                onReorderStart: (index) {
                                  print("並び替えスタート");
                                },
                                onReorder: (int oldIndex, int newIndex) async {
                                  setState(() {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    final Favworddb item =
                                        _favworddata.removeAt(oldIndex);
                                    final String meanitem =
                                        mean.removeAt(oldIndex);
                                    _favworddata.insert(newIndex, item);
                                    mean.insert(newIndex, meanitem);
                                  });
                                  print("$oldIndex");
                                  print("${_favworddata[oldIndex].word}");
                                  print("$newIndex");
                                  print("${_favworddata[newIndex].word}");
                                  if (oldIndex < newIndex) {
                                    for (int i = oldIndex; i <= newIndex; i++) {
                                      var updatekey = _favworddata[i].key;
                                      var updatedicname =
                                          _favworddata[i].dicname;
                                      var updateword = _favworddata[i].word;
                                      var updatecolor =
                                          _favworddata[i].colornumber;
                                      var updateurl = _favworddata[i].url;
                                      Favworddb updata = Favworddb(
                                        dicname: updatedicname,
                                        word: updateword,
                                        key: updatekey,
                                        ordernumber: i,
                                        colornumber: updatecolor,
                                        url: updateurl,
                                      );
                                      await Favworddb.updatefavword(
                                          updata,
                                          updatekey!,
                                          updatedicname!,
                                          updateword!);
                                    }
                                    print("並び替え完了");
                                  } else if (oldIndex > newIndex) {
                                    for (int i = newIndex; i <= oldIndex; i++) {
                                      var updatekey = _favworddata[i].key;
                                      var updatedicname =
                                          _favworddata[i].dicname;
                                      var updateword = _favworddata[i].word;
                                      var updatecolor =
                                          _favworddata[i].colornumber;
                                      var updateurl = _favworddata[i].url;
                                      Favworddb updata = Favworddb(
                                        dicname: updatedicname,
                                        word: updateword,
                                        key: updatekey,
                                        ordernumber: i,
                                        colornumber: updatecolor,
                                        url: updateurl,
                                      );
                                      await Favworddb.updatefavword(
                                          updata,
                                          updatekey!,
                                          updatedicname!,
                                          updateword!);
                                    }
                                    print("並び替え完了");
                                  } else {
                                    print("変化なし");
                                  }
                                  setState(() {});
                                },
                              ),
                            )),
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
                              icon: Icon(
                                Icons.edit,
                                color: iconcolor2,
                              ),
                              onPressed: () {
                                if (switchBool == false &&
                                    editBool == true &&
                                    selectedItems.length == 4) {
                                  iconcolor = Colors.grey;
                                  iconcolor2 = Colors.red;
                                  textfieldcolor = Colors.grey;
                                  Listswitch();
                                } else if (switchBool == true) {
                                  iconcolor = Colors.white;
                                  iconcolor2 = Colors.white;
                                  textfieldcolor = Colors.black;
                                  Listswitch();
                                }
                                setState(() {});
                              },
                            )),
                        Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              iconSize: 28.sp,
                              icon: Icon(
                                Icons.add,
                                color: iconcolor,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => addwordPage(
                                        folderkey: widget.folderkey!,
                                      ),
                                    ));
                              },
                            )),
                      ],
                    ),
                  ),
                  drawer: showsidemenu(fontsize: fs),
                  floatingActionButton: coloriconsw(),
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
