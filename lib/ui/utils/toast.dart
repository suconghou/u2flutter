import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart' show navigatorKey;

class Toast {
  static OverlayEntry? _overlayEntry; //toast靠它加到屏幕上
  static bool _showing = false; //toast是否正在showing
  static DateTime _startedTime =
      DateTime.now(); //开启一个新toast的当前时间，用于对比是否已经展示了足够时间
  static String _msg = "";
  static void toast(String msg) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    _msg = msg;
    _startedTime = DateTime.now();
    //获取OverlayState
    OverlayState overlayState = Overlay.of(context);
    _showing = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          //top值，可以改变这个值来改变toast在屏幕中的位置
          top: MediaQuery.of(context).size.height * 2 / 3,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: AnimatedOpacity(
                opacity: _showing ? 1.0 : 0.0, //目标透明度
                duration: _showing
                    ? const Duration(milliseconds: 100)
                    : const Duration(milliseconds: 400),
                child: _buildToastWidget(),
              ),
            ),
          ),
        ),
      );
      overlayState.insert(_overlayEntry!);
    } else {
      //重新绘制UI，类似setState
      _overlayEntry!.markNeedsBuild();
    }
    await Future.delayed(const Duration(milliseconds: 2000)); //等待两秒

    //2秒后 到底消失不消失
    if (DateTime.now().difference(_startedTime).inMilliseconds >= 2000) {
      _showing = false;
      _overlayEntry!.markNeedsBuild();
    }
  }

  //toast绘制
  static Center _buildToastWidget() {
    return Center(
      child: Card(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Text(
            _msg,
            style: const TextStyle(fontSize: 14.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

void toast(String msg) {
  Toast.toast(msg);
}
