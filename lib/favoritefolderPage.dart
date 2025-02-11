import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/favwordcardPage.dart';
import 'package:myapp/folreg.dart';
import 'Sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dicdb.dart';
import 'menuClass.dart';
import 'main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class favoritefolderPage extends StatefulWidget {
  const favoritefolderPage({Key? key}) : super(key: key);
  @override
  State<favoritefolderPage> createState() => _favoritefolderPage();
}

final _editController = TextEditingController();

class _favoritefolderPage extends State<favoritefolderPage> with RouteAware {
  bool gessw = false;
  bool cansw = false;
  List<Foldb> _foldata = [];
  bool switchBool = false;
  bool menuswitch = false;
  bool editBool = true;
  String editBotton = "編集";
  Color? textfieldcolor = Colors.black;

  Color iconcolor = Colors.white;
  Color iconcolor2 = Colors.white;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final prefs = await SharedPreferences.getInstance();
    var foldata = await Foldb.getallfolders();
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
                      leading: IconButton(
                        iconSize: 28.sp,
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                        ),
                      ),
                      toolbarHeight: 60.h,
                      centerTitle: true,
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
                              style: TextStyle(fontSize: 30.sp),
                              enabled: true,
                              controller: _editController,
                              decoration: InputDecoration(
                                hintText: 'フォルダ検索',
                                hintStyle: TextStyle(
                                    color: textfieldcolor, fontSize: 30.sp),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: textfieldcolor,
                                  size: 30.sp,
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 6.0, bottom: 4.0),
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
                              child: ReorderableListView.builder(
                                buildDefaultDragHandles: switchBool,
                                physics: wakaran(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                itemCount: _foldata.length,
                                itemBuilder: (context, i) {
                                  return Dismissible(
                                      direction: delete(),
                                      background: Container(color: Colors.red),
                                      key: ObjectKey(_foldata[i]),
                                      onDismissed:
                                          (DismissDirection direction) async {
                                        await Psmeandb.deletefolmean(
                                            _foldata[i].keynumber);
                                        await Favworddb.deletefolword(
                                            _foldata[i].keynumber);
                                        await Foldb.deleteFol(
                                            _foldata[i].keynumber);
                                        setState(() {
                                          _foldata.removeAt(i);
                                        });
                                        if (i < _foldata.length) {
                                          for (int j = _foldata.length;
                                              i < j;
                                              i++) {
                                            print("INDEX=$i");
                                            print("${_foldata[i].keynumber}");
                                            print("${_foldata[i].foldername}");
                                            print("${_foldata[i].OrderIndex}");
                                            var updatekeynumber =
                                                _foldata[i].keynumber;
                                            var updatefoldername =
                                                _foldata[i].foldername;
                                            var updateDeveloper =
                                                _foldata[i].Developer;
                                            var updateOrderIndex = i;
                                            Foldb updata = Foldb(
                                                keynumber: updatekeynumber,
                                                foldername: updatefoldername,
                                                Developer: updateDeveloper,
                                                OrderIndex: updateOrderIndex);
                                            await Foldb.updateFol(
                                                updata, updatekeynumber);
                                          }
                                        }
                                        var foldata =
                                            await Foldb.getallfolders();
                                        setState(() {
                                          _foldata = foldata;
                                        });
                                        // print("${_foldata[2].keynumber}");
                                        // print("${_foldata[2].foldername}");
                                        // print("${_foldata[2].OrderIndex}");
                                      },
                                      child: IgnorePointer(
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
                                                    : () {
                                                        if (switchBool ==
                                                            false) {
                                                          int? key = _foldata[i]
                                                              .keynumber;
                                                          print("フォルダ選択");
                                                          // Navigator.push(
                                                          //     context,
                                                          //     CustomPageRoute(
                                                          //       favwordcardPage(
                                                          //         folderkey: key,
                                                          //       ),
                                                          //     ));
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        favwordcardPage(
                                                                  folderkey:
                                                                      key,
                                                                ),
                                                              ));
                                                        }
                                                      },
                                              ))));
                                },
                                onReorderStart: (index) {
                                  print("並び替えスタート");
                                },
                                onReorder: (int oldIndex, int newIndex) async {
                                  setState(() {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    final Foldb item =
                                        _foldata.removeAt(oldIndex);
                                    _foldata.insert(newIndex, item);
                                  });
                                  print("$oldIndex");
                                  print("${_foldata[oldIndex].foldername}");
                                  print("$newIndex");
                                  print("${_foldata[newIndex].foldername}");
                                  if (oldIndex < newIndex) {
                                    for (int i = oldIndex; i <= newIndex; i++) {
                                      var updatekeynumber =
                                          _foldata[i].keynumber;
                                      var updatefoldername =
                                          _foldata[i].foldername;
                                      var updateDeveloper =
                                          _foldata[i].Developer;
                                      Foldb updata = Foldb(
                                          keynumber: updatekeynumber,
                                          foldername: updatefoldername,
                                          Developer: updateDeveloper,
                                          OrderIndex: i);
                                      await Foldb.updateFol(
                                          updata, updatekeynumber);
                                      print("並び替え完了");
                                    }
                                  } else if (oldIndex > newIndex) {
                                    for (int i = newIndex; i <= oldIndex; i++) {
                                      var updatekeynumber =
                                          _foldata[i].keynumber;
                                      var updatefoldername =
                                          _foldata[i].foldername;
                                      var updateDeveloper =
                                          _foldata[i].Developer;
                                      Foldb updata = Foldb(
                                          keynumber: updatekeynumber,
                                          foldername: updatefoldername,
                                          Developer: updateDeveloper,
                                          OrderIndex: i);
                                      await Foldb.updateFol(
                                          updata, updatekeynumber);
                                      print("並び替え完了");
                                    }
                                  } else {
                                    print("変化なし");
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
                                if (switchBool == false && editBool == true) {
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
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return folregPage(
                                        next: 0,
                                      );
                                    });
                              },
                            )),
                      ],
                    ),
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
      ]),
    );
  }
}
