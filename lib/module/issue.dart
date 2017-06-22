import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/model/issue.dart';
import 'package:ompclient/module/keyvalue.dart';
import 'package:ompclient/store/issue.dart';

class IssuePage extends StatefulWidget {
  final String title;
  final Store store;
  IssuePage({Key, key, this.title, this.store}) : super(key: key);
  @override
  _IssuePageState createState() => new _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  @override
  Widget build(BuildContext context) {
    IssueState _state = widget.store.state.getState(issuekey);
    Issue _issue = _state.selected;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        children: [
          new KeyValueItem(title: "事件单号", value: "${_issue.id}"),
          new KeyValueItem(title: "事件标题", value: _issue.name),
          new KeyValueItem(title: "事件来源", value: _issue.source ?? ""),
          new KeyValueItem(title: "事件描述", value: _issue.depict ?? ""),
          new KeyValueItem(title: "创建人", value: _issue.createName),
          new KeyValueItem(title: "创建时间", value: _issue.create_time.toString()),
          new KeyValueItem(title: "服务目录", value: _issue.serverName),
          new KeyValueItem(title: "紧急度", value: "${_issue.urgent}"),
          new KeyValueItem(title: "响应度", value: "${_issue.urgent}"),
        ],
      ),
    );
  }
}
