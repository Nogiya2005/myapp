import 'package:flutter/material.dart';
import 'package:myapp/EJdicPage.dart';
import 'package:myapp/favoritefolderPage.dart';
import 'package:myapp/quizmenuPage.dart';
import 'SettingPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class showsidemenu extends StatelessWidget {
  const showsidemenu({Key? key, this.fontsize}) : super(key: key);
  final double? fontsize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Drawer(
        shadowColor: Colors.black, //背景の影の色
        elevation: 100.0, //背景の影の濃さ？
        child: ListView(
          children: [
            SizedBox(
              height: 100.sp,
              child: DrawerHeader(
                child: Text(
                  'メニューリスト',
                  style: TextStyle(
                    fontSize: fontsize!.sp,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.black,
                    width: 1.w,
                  )),
                ),
                child: ListTile(
                  title: Text(
                    "和英・英和辞書",
                    style: TextStyle(fontSize: fontsize!.sp),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EJdicPage(),
                        )).then((value) {});
                  },
                )),
            Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                height: 80.h,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.black,
                    width: 1.w,
                  )),
                ),
                child: ListTile(
                  title: Text(
                    "単語帳",
                    style: TextStyle(fontSize: fontsize!.sp),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => favoritefolderPage(),
                        ));
                  },
                )),
            Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                height: 80.h,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.black,
                    width: 1.w,
                  )),
                ),
                child: ListTile(
                  title: Text(
                    "クイズ",
                    style: TextStyle(fontSize: fontsize!.sp),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizmenuPage(),
                        ));
                  },
                )),
            Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                height: 80.h,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.black,
                    width: 1.w,
                  )),
                ),
                child: ListTile(
                  title: Text(
                    "設定",
                    style: TextStyle(fontSize: fontsize!.sp),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingPage(),
                        ));
                  },
                ))
          ],
        ),
      ),
    );
  }
}
