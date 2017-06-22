import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/model/component.dart';
import 'package:ompclient/store/component.dart';

class ComponentsPage extends StatefulWidget {
  final String title;
  final Store store;
  ComponentsPage({Key key, this.title, this.store}) : super(key: key);
  @override
  _ComponentsPageState createState() => new _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  @override
  void initState() {
    super.initState();
    ComponentState _state = widget.store.state.getState(componentkey);
    if (!_state.nomore && _state.rows.length == 0) {
      fetchComponents(widget.store, _state.page);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ComponentState _state = widget.store.state.getState(componentkey);
    final ThemeData theme = Theme.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        children: _state.rows.map((Component component) {
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
                title: new Text(component.D_ControlAdderss),
                subtitle: new Text(component.deItfunctionName),
                onTap: () {
                  selectComponent(widget.store, component);
                  Navigator.pushNamed(context, '/component');
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
