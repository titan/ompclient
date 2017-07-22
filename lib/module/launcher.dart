import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/store/store.dart';
import 'package:ompclient/store/session.dart';
import 'package:ompclient/module/login.dart';
import 'package:ompclient/module/home.dart';

class LauncherPage extends StatefulWidget {
  final String title;
  final Store store;

  LauncherPage({Key key, this.title, this.store}) : super(key: key);

  @override
  _LauncherPageState createState() => new _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  bool _logined = false;

  @override
  void initState() {
    super.initState();
    widget.store.onChange.listen((state) {
      if (state.getState(sessionkey).session != null &&
          state.getState(sessionkey).session.access_token != null) {
        setState(() {
          _logined = true;
        });
      } else {
        setState(() {
          _logined = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_logined) {
      return new HomePage(
        title: '主页',
        store: widget.store,
      );
    } else {
      return new LoginPage(
        title: '用户登录',
        store: widget.store,
      );
    }
  }
}
