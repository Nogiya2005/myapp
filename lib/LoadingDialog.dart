import 'package:flutter/material.dart';

Future<void> showLoadingDialog({
  required BuildContext context,
}) async {
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 100), //画面遷移時間
      barrierColor: Colors.black.withOpacity(0.5), // 画面マスクの透明度
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //クルクルの実装とスタイルの変更
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  backgroundColor: Colors.white,
                ),

                // Text("処理中", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      });
}
