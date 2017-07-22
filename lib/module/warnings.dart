import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/api/defination.dart';
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
  bool _reported = false;
  final ScrollController _scrollController = new ScrollController();
  TabController _controller;
  _Page _selectedPage = _pages[0];
  Map<String, WarningState> _warningStates;

  void _handleTabSelection() {
    setState(() {
      _selectedPage = _pages[_controller.index];
      WarningState _state = _warningStates[_selectedPage.level];
      if (!_state.nomore && _state.rows.length == 0) {
        fetchWarnings(
          widget.store,
          _selectedPage.level,
          _state.page,
        );
      }
    });
  }

  bool _handleScrollNotification(ScrollNotification notification, Store store,
      WarningState state, String level) {
    if (notification.depth == 0 && notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        // got to the end of scrollable
        if (!state.nomore) {
          fetchWarnings(widget.store, level, state.page + 1);
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _controller = new TabController(
      vsync: this,
      length: _pages.length,
    );
    _controller.addListener(_handleTabSelection);
    _warningStates = widget.store.state.getState(warningkey);
    WarningState _state = _warningStates[_selectedPage.level];
    if (!_state.nomore && _state.rows.length == 0) {
      fetchWarnings(
        widget.store,
        _selectedPage.level,
        _state.page,
      );
    }
    widget.store.onChange.listen((state) {
      if (_state.error != null &&
          _state.error is TokenException &&
          !_reported) {
        _reported = true; // make sure just report once
        reportInvalidToken(widget.store, _state.error);
        if (context != null) {
          Navigator.of(context).popUntil((route) {
            if (route is MaterialPageRoute && route.settings.name == "/") {
              return true;
            }
            return false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WarningState _state = _warningStates[_selectedPage.level];
    final Map<String, List<Widget>> items = new Map<String, List<Widget>>();
    for (_Page page in _pages) {
      String level = page.level;
      WarningState _state = _warningStates[level];
      List<Widget> list = <Widget>[];
      items[level] = list;
      if (_state.error == null) {
        list.addAll(_warningStates[level].rows.map((Warning warning) {
          return new Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new WarningItem(
              warning: warning,
              color: page.color,
              onTap: () {
                selectWarning(
                  widget.store,
                  warning,
                );
                Navigator.pushNamed(
                  context,
                  '/warning',
                );
              },
            ),
          );
        }).toList());
        if (_state.loading) {
          list.add(new Center(
            child: new CircularProgressIndicator(),
          ));
        }
      }
    }
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
          return _warningStates[page.level].error != null
              ? new Center(
                  child: new Text(_state.error.toString()),
                )
              : new NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    return _handleScrollNotification(
                        notification, widget.store, _state, page.level);
                  },
                  child: new ListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    children: items[page.level],
                  ),
                );
        }).toList(),
      ),
    );
  }
}
