import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/store/store.dart';
import 'package:ompclient/module/launcher.dart';
import 'package:ompclient/module/login.dart';
import 'package:ompclient/module/home.dart';
import 'package:ompclient/module/warnings.dart';
import 'package:ompclient/module/warning.dart';
import 'package:ompclient/module/reports.dart';
import 'package:ompclient/module/report.dart';
import 'package:ompclient/module/issues.dart';
import 'package:ompclient/module/issue.dart';
import 'package:ompclient/module/components.dart';
import 'package:ompclient/module/component.dart';

void main() {
  runApp(new AppWidget());
}

class AppWidget extends StatefulWidget {

  @override
  _AppState createState() => new _AppState();

}

class _AppState extends State<AppWidget> {

  Store store = createStore();

  @override
  void initState() {
    super.initState();
    store.onChange.listen((_) {
      setState((){});
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'OMP Client',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting
        // the app, try changing the primarySwatch below to Colors.green
        // and press "r" in the console where you ran "flutter run".
        // We call this a "hot reload". Notice that the counter didn't
        // reset back to zero -- the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: new LauncherPage(title: 'Launcher', store: store),
      routes: <String, WidgetBuilder> {
      '/': (BuildContext context) => new LauncherPage(store: store),
      '/home': (BuildContext context) => new HomePage(title: 'Home', store: store),
      '/login': (BuildContext context) => new LoginPage(title: '用户登录', store: store),
      '/warnings': (BuildContext context) => new WarningsPage(title: '设备告警', store: store),
      '/warning': (BuildContext context) => new WarningPage(title: '设备告警详情', store: store),
      '/reports': (BuildContext context) => new ReportsPage(title: '检测报表', store: store),
      '/report': (BuildContext context) => new ReportPage(title: '检测报表详情', store: store),
      '/issues': (BuildContext context) => new IssuesPage(title: '工单管理', store: store),
      '/issue': (BuildContext context) => new IssuePage(title: '工单详情', store: store),
      '/components': (BuildContext context) => new ComponentsPage(title: '设备监测', store: store),
      '/component': (BuildContext context) => new ComponentPage(title: '设备详情', store: store),
      },
    );
  }
}
