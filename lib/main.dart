import 'package:flutter/material.dart';
import 'package:myapp/EJdicPage.dart';
import 'package:myapp/dicdb.dart';
import 'package:flutter/services.dart';
// import 'package:device_preview/device_preview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    // 縦向き
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
        // DevicePreview(builder: (context) =>
        MyApp()
        // )
        );
  });
}

List<Dicdb> dicdata = [];

void loaddic() async {
  dicdata = await Dicdb.getallwords("");
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

@override
void initState() {
  loaddic();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // fontFamily: 'Murecho'
      ),
      navigatorObservers: <NavigatorObserver>[routeObserver],
      home: EJdicPage(),
    );
  }
}
