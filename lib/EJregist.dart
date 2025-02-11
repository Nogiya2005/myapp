import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/dicdb.dart';
import 'package:myapp/folreg.dart';
import 'package:myapp/ResultPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'menuClass.dart';

class EJregistPage extends StatefulWidget {
  const EJregistPage(
      {Key? key, this.dicname, this.word, this.mean, this.url, this.itemlist})
      : super(key: key);
  final dicname;
  final word;
  final List<Mean>? mean; //謎
  final url;
  final itemlist;
  @override
  State<EJregistPage> createState() => _EJregistPage();
}

class _EJregistPage extends State<EJregistPage> {
  double? fontsize;
  List<Foldb> lists = [];
  List<String> wordlists = [];
  List<String> _lists = [];
  String? slValue;
  var selectedValue;
  List<Mean> meanlist = [];
  int _index = 0;

  final List<String> items = [];
  List<String> selectedItems = [];

  Future<void> saveFavDb(double sV) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontsize', sV);
  }

  _loadfs() async {
    items.addAll(widget.itemlist);
    final prefs = await SharedPreferences.getInstance();
    lists = await Foldb.getallfolders();
    int j = lists.length;
    for (int i = 0; i < j; i++) {
      wordlists.add("${lists[i].foldername}");
    }
    slValue = "${lists[0].foldername}";
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      _lists = wordlists;
      selectedValue = slValue;
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
  //   _loadfs();
  // }

  @override
  void initState() {
    super.initState();
    _loadfs();
    meanlist = widget.mean!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'フォルダ選択',
        style: TextStyle(fontSize: titlesize.sp),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                iconStyleData: IconStyleData(iconSize: 28.sp),
                isExpanded: true,
                hint: Text(
                  '単語選択',
                  style: TextStyle(
                    fontSize: 25.sp,
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
                        final isSelected = selectedItems.contains(item);
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                if (isSelected)
                                  Icon(
                                    Icons.check_box_outlined,
                                    size: 25.sp,
                                  )
                                else
                                  Icon(
                                    Icons.check_box_outline_blank,
                                    size: 25.sp,
                                  ),
                                SizedBox(width: 16.w),
                                Flexible(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: fs.sp,
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
                value: selectedItems.isEmpty ? null : selectedItems.last,
                onChanged: (value) {},
                selectedItemBuilder: (context) {
                  return items.map(
                    (item) {
                      return Container(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          selectedItems.join(', '),
                          style: TextStyle(
                            fontSize: 25.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      );
                    },
                  ).toList();
                },
                buttonStyleData: ButtonStyleData(
                  height: 70.h,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    color: Colors.white,
                  ),
                  elevation: 2,
                ),
                menuItemStyleData: MenuItemStyleData(
                  height: 70.h,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            DropdownButtonFormField<String>(
                iconSize: 28.sp,
                style: TextStyle(fontSize: 25.sp, color: Colors.black),
                itemHeight: 70.h,
                decoration: InputDecoration(border: OutlineInputBorder()),
                value: selectedValue,
                items: _lists
                    .map((String list) => DropdownMenuItem(
                        value: list,
                        child: Text(
                          list,
                          style: TextStyle(fontSize: fs.sp),
                        )))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _index = _lists.indexOf(value!);
                    selectedValue = value;
                    print("$_index");
                  });
                })
          ])),
      actions: <Widget>[
        TextButton(
          child: Text(
            'キャンセル',
            style: TextStyle(fontSize: buttonsize.sp),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
            child: Text(
              "フォルダ追加",
              style: TextStyle(fontSize: buttonsize.sp),
            ),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return folregPage(
                      dicname: widget.dicname,
                      word: widget.word,
                      next: 1,
                    );
                  }).then((value) async {
                wordlists.clear();
                lists = await Foldb.getallfolders();
                int j = lists.length;
                for (int i = 0; i < j; i++) {
                  wordlists.add("${lists[i].foldername}");
                }
                slValue = "${lists[0].foldername}";
                setState(() {
                  selectedValue = slValue;
                  _lists = wordlists;
                });
              });
            }),
        ElevatedButton(
          child: Text(
            '保存',
            style: TextStyle(fontSize: buttonsize.sp),
          ),
          onPressed: () async {
            if (selectedItems.isEmpty == true) {
              await showDialog<void>(
                context: context, //必須の引数
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('エラー'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('選択されていません'),
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
            } else if (selectedItems.isEmpty == false) {
              for (int i = 0; i < selectedItems.length; i++) {
                var insertkey = lists[_index].keynumber;
                var favwordlist = await Favworddb.getkeyfavword(insertkey!);
                var insertorderindex = favwordlist.length;
                var insertdicname = widget.dicname;
                var insertword = selectedItems[i];
                var inserturl = widget.url;
                var samewordj = await Favworddb.getkeysameword(
                    insertkey, insertdicname, insertword);
                if (samewordj.isEmpty == true) {
                  final insertfavwordlist = Favworddb(
                      dicname: insertdicname,
                      word: insertword,
                      key: insertkey,
                      ordernumber: insertorderindex,
                      colornumber: 4278190080,
                      url: inserturl);
                  print('$insertdicname');
                  print('$insertword');
                  print('$insertkey');
                  print('$insertorderindex');

                  await Favworddb.insertfavword(insertfavwordlist);

                  final insertpsmean = Psmeandb(
                    dicname: insertdicname,
                    word: insertword,
                    mean: widget.word,
                    key: insertkey,
                    colornumber: 4278190080,
                  );
                  await Psmeandb.insertpsmean(insertpsmean);
                } else {
                  await showDialog<void>(
                    context: context, //必須の引数
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('エラー'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('このフォルダ内に${selectedItems[i]}が存在しています。'),
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
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
