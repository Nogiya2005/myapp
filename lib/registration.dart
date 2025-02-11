import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/dicdb.dart';
import 'package:myapp/folreg.dart';
import 'package:myapp/ResultPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menuClass.dart';
// import 'main.dart';

class registrationPage extends StatefulWidget {
  const registrationPage(
      {Key? key, this.dicname, this.word, this.mean, this.url})
      : super(key: key);
  final dicname;
  final word;
  final List<Mean>? mean; //謎
  final url;
  @override
  State<registrationPage> createState() => _registrationPage();
}

class _registrationPage extends State<registrationPage> {
  double? fontsize;
  List<Foldb> lists = [];
  List<String> wordlists = [];
  List<String> _lists = [];
  String? slValue;
  var selectedValue;
  List<Mean> meanlist = [];
  int _index = 0;

  Future<void> saveFavDb(double sV) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontsize', sV);
  }

  _loadfs() async {
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
            DropdownButtonFormField<String>(
                style: TextStyle(fontSize: fs.sp, color: Colors.black),
                itemHeight: 70.h,
                decoration: InputDecoration(border: OutlineInputBorder()),
                value: selectedValue,
                items: _lists
                    .map((String list) =>
                        DropdownMenuItem(value: list, child: Text(list)))
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
          child: Text('キャンセル', style: TextStyle(fontSize: buttonsize.sp)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
            child: Text("フォルダ追加", style: TextStyle(fontSize: buttonsize.sp)),
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
            var insertkey = lists[_index].keynumber;
            var favwordlist = await Favworddb.getkeyfavword(insertkey!);
            var insertorderindex = favwordlist.length;
            var insertdicname = widget.dicname;
            var insertword = widget.word;
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

              for (int i = 0; i < meanlist.length; i++) {
                final insertpsmean = Psmeandb(
                  dicname: insertdicname,
                  word: insertword,
                  mean: meanlist[i].wordmean,
                  key: insertkey,
                  colornumber: meanlist[i].favmean,
                );
                print('${meanlist[i].favmean}');
                await Psmeandb.insertpsmean(insertpsmean);
              }
              Navigator.of(context).pop();
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
          },
        ),
      ],
    );
  }

  Future<bool> _willPopcallback() async {
    return false;
  }
}
