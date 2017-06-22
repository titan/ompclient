import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/model/warning.dart';
import 'package:ompclient/module/keyvalue.dart';
import 'package:ompclient/store/warning.dart';

class WarningPage extends StatefulWidget {
  final String title;
  final Store store;
  WarningPage({Key, key, this.title, this.store}) : super(key: key);
  @override
  _WarningPageState createState() => new _WarningPageState();
}

class _WarningPageState extends State<WarningPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, WarningState> _warning_states =
        widget.store.state.getState(warningkey);
    WarningState _state = _warning_states["selected"];
    Warning _warning = _state.selected;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        children: [
          new KeyValueItem(title: "uptime", value: _warning.uptime.toString()),
          new KeyValueItem(title: "P_Guid", value: "${_warning.P_Guid}"),
          new KeyValueItem(title: "D_Title", value: _warning.D_Title),
          new KeyValueItem(title: "D_Detail", value: _warning.D_Detail),
          new KeyValueItem(title: "itcompId", value: "${_warning.itcompId}"),
          new KeyValueItem(title: "D_Urgency", value: "${_warning.D_Urgency}"),
          new KeyValueItem(title: "D_PRI", value: "${_warning.D_PRI}"),
          new KeyValueItem(title: "itId", value: "${_warning.itId}"),
          new KeyValueItem(title: "ip", value: _warning.ip),
          new KeyValueItem(title: "bsname", value: _warning.bsname ?? ""),
          new KeyValueItem(title: "D_MState", value: _warning.D_MState ?? ""),
        ],
      ),
    );
  }
}
