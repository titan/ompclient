import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class HomeMenu {
  final String title;
  final Color color;
  final String emoji;
  final String route;
  HomeMenu({this.title, this.color, this.emoji, this.route});
}

class HomePage extends StatelessWidget {
  final String title;
  final Store store;
  final List<HomeMenu> _menus = <HomeMenu>[
    new HomeMenu(
        title: '设备告警',
        color: new Color(0xfff46a43),
        emoji: '\u{1F4E2}',
        route: "/warnings"),
    new HomeMenu(
        title: '工单管理',
        color: new Color(0xfff8a32f),
        emoji: '\u{1F4DD}',
        route: "/issues"),
    new HomeMenu(
        title: '设备监测',
        color: new Color(0xff2684c1),
        emoji: '\u{1F4BB}',
        route: "/components"),
    new HomeMenu(
        title: '监测报表',
        color: new Color(0xff83b32c),
        emoji: '\u{1F4CA}',
        route: "/reports"),
  ];
  HomePage({Key key, this.title, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that
        // was created by the App.build method, and use it to set
        // our appbar title.
        title: new Text(title),
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              padding: const EdgeInsets.all(4.0),
              childAspectRatio: 1.0,
              children: _menus.map((HomeMenu menu) {
                return new Container(
                  child: new ClipRRect(
                    borderRadius: new BorderRadius.circular(12.0),
                    child: new InkWell(
                      onTap: () {
                        if (menu.route != null) {
                          Navigator.pushNamed(context, menu.route);
                        }
                      },
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            menu.emoji,
                            style: new TextStyle(
                              fontFamily: 'EmojiSymbols',
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          ),
                          new Text(
                            menu.title,
                            style: new TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                  ),
                  decoration: new BoxDecoration(color: menu.color),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
