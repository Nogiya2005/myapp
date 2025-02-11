import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dicdb.dart';
import 'menuClass.dart';

class folregPage extends StatefulWidget {
  const folregPage({Key? key, this.dicname, this.word, this.next})
      : super(key: key);
  final dicname;
  final word;
  // final mean;
  final next;
  @override
  State<folregPage> createState() => _folregPage();
}

class _folregPage extends State<folregPage> {
  List<String> lists = [];
  String? selectedValue;
  final _editController = TextEditingController();
  int _keycounter = 0;

  Future<String> getFolname() async {
    final fulname = _editController.text;
    return fulname;
  }

  Future<void> savefs(int keycounter) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('keycounter', keycounter);
  }

  _loadfs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fs = prefs.getDouble('fontsize') ?? 19;
      _keycounter = prefs.getInt('keycounter') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadfs();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'フォルダ追加',
        style: TextStyle(fontSize: titlesize.sp),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: TextField(
            style: TextStyle(fontSize: 25.sp),
            keyboardType: TextInputType.text,
            controller: _editController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              hintText: 'フォルダ名を入力',
              icon: Icon(Icons.search),
            ),
          )),
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
        ElevatedButton(
          child: Text(
            '保存',
            style: TextStyle(fontSize: buttonsize.sp),
          ),
          onPressed: () async {
            final name = await getFolname();
            var listlength = await Foldb.getallfolders();
            _keycounter = _keycounter + 1;
            final folderdata = Foldb(
                keynumber: _keycounter,
                foldername: name,
                Developer: 0,
                OrderIndex: listlength.length);
            await Foldb.insertFol(folderdata);
            await savefs(_keycounter);
            print("$_keycounter");
            print(name);
            print("${listlength.length}");
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Future<bool> _willPopcallback() async {
    return false;
  }
}
