import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/component.dart';
import 'package:ompclient/store/component.dart';
import 'package:ompclient/store/session.dart';

class ComponentsPage extends StatefulWidget {
  final String title;
  final Store store;
  ComponentsPage({Key key, this.title, this.store}) : super(key: key);
  @override
  _ComponentsPageState createState() => new _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  final ScrollController _scrollController = new ScrollController();
  bool _reported = false;

  bool _handleScrollNotification(
      ScrollNotification notification, Store store, ComponentState state) {
    if (notification.depth == 0 && notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        // got to the end of scrollable
        if (!state.nomore) {
          fetchComponents(widget.store, state.page + 1);
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    final ComponentState _state = widget.store.state.getState(componentkey);
    if (!_state.nomore && _state.rows.length == 0) {
      fetchComponents(widget.store, _state.page);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ComponentState _state = widget.store.state.getState(componentkey);
    final ThemeData theme = Theme.of(context);
    final List<Widget> items = <Widget>[];
    if (_state.error == null) {
      items.addAll(_state.rows.map(
        (Component component) {
          return new Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new Container(
              decoration: new BoxDecoration(
                color: theme.canvasColor,
                border: new Border(
                  bottom: new BorderSide(
                    color: theme.dividerColor,
                  ),
                ),
              ),
              child: new ListTile(
                title: new Text(
                    component.D_ControlAdderss + "(${component.P_Guid})"),
                subtitle: new Text(component.deItfunctionName),
                onTap: () {
                  selectComponent(
                    widget.store,
                    component,
                  );
                  Navigator.pushNamed(
                    context,
                    '/component',
                  );
                },
              ),
            ),
          );
        },
      ).toList());
      if (_state.loading) {
        items.add(new Center(
          child: new CircularProgressIndicator(),
        ));
      }
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: _state.error != null
            ? new Center(
                child: new Text(_state.error.toString()),
              )
            : new NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  return _handleScrollNotification(
                      notification, widget.store, _state);
                },
                child: new ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  children: items,
                ),
              ));
  }
}
