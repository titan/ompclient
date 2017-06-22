import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/model/warning.dart';
import 'package:ompclient/store/warning.dart';

class _Page {
  _Page({this.label, this.level, this.color});
  final String label;
  final String level;
  final Color color;
}

final List<_Page> _pages = <_Page>[
  new _Page(label: '普通', level: "1,2", color: new Color(0xfff6b734)),
  new _Page(label: '重要', level: "3,4", color: new Color(0xfffe6a00)),
  new _Page(label: '严重', level: "6,9", color: new Color(0xffc20102)),
];

class WarningItem extends StatelessWidget {
  final Warning warning;
  final GestureTapCallback onTap;
  final Color color;
  WarningItem({Key key, this.warning, this.onTap, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new InkWell(
      onTap: onTap,
      child: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        decoration: new BoxDecoration(
          color: theme.canvasColor,
          border: new Border(
            bottom: new BorderSide(
              color: theme.dividerColor,
            ),
          ),
        ),
        child: new Container(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: new BoxDecoration(
            color: theme.canvasColor,
            border: new Border(
              left: new BorderSide(
                width: 4.0,
                color: color ?? theme.dividerColor,
              ),
            ),
          ),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                warning.D_Title,
                softWrap: true,
                style: new TextStyle(
                  fontSize: theme.textTheme.subhead.fontSize,
                  color: color ?? theme.textTheme.subhead.color,
                ),
              ),
              new Text(
                warning.D_Detail,
                softWrap: true,
                style: theme.textTheme.body1,
              ),
              new Text(warning.uptime.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class WarningsPage extends StatefulWidget {
  final String title;
  final Store store;
  WarningsPage({Key key, this.title, this.store}) : super(key: key);
  @override
  _WarningsPageState createState() => new _WarningsPageState();
}

class _WarningsPageState extends State<WarningsPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  _Page _selectedPage = _pages[0];
  Map<String, WarningState> _warning_states;

  void _handleTabSelection() {
    setState(() {
      _selectedPage = _pages[_controller.index];
      WarningState _state = _warning_states[_selectedPage.level];
      if (!_state.nomore && _state.rows.length == 0) {
        fetchWarnings(widget.store, _selectedPage.level, _state.page);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = new TabController(vsync: this, length: _pages.length);
    _controller.addListener(_handleTabSelection);
    _warning_states = widget.store.state.getState(warningkey);
    WarningState _state = _warning_states[_selectedPage.level];
    if (!_state.nomore && _state.rows.length == 0) {
      fetchWarnings(widget.store, _selectedPage.level, _state.page);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        bottom: new TabBar(
          tabs: _pages.map((_Page page) => new Tab(text: page.label)).toList(),
          controller: _controller,
        ),
      ),
      body: new TabBarView(
        controller: _controller,
        children: _pages.map((_Page page) {
          return new ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            children: _warning_states[page.level].rows.map((Warning warning) {
              return new Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: new WarningItem(
                    warning: warning,
                    color: page.color,
                    onTap: () {
                      selectWarning(widget.store, warning);
                      Navigator.pushNamed(context, '/warning');
                    }),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
