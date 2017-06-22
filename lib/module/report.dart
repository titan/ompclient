import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/model/report.dart';
import 'package:ompclient/module/keyvalue.dart';
import 'package:ompclient/store/report.dart';

class ReportPage extends StatefulWidget {
  final String title;
  final Store store;
  ReportPage({Key, key, this.title, this.store}) : super(key: key);
  @override
  _ReportPageState createState() => new _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    ReportState _state = widget.store.state.getState(reportkey);
    Report _report = _state.selected;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        children: [
          new KeyValueItem(title: "p_guid", value: "${_report.p_guid}"),
          new KeyValueItem(title: "r_type", value: "${_report.r_type}"),
          new KeyValueItem(title: "r_name", value: _report.r_name),
          new KeyValueItem(title: "r_period", value: "${_report.r_period}"),
          new KeyValueItem(title: "r_isusing", value: "${_report.r_isusing}"),
          new KeyValueItem(title: "r_email", value: _report.r_email ?? ""),
          new KeyValueItem(title: "r_createtime", value: _report.r_createtime.toString()),
          new KeyValueItem(title: "r_produce", value: _report.r_produce),
          new KeyValueItem(title: "r_judgeofflinetime", value: "${_report.r_judgeofflinetime}"),
          new KeyValueItem(title: "r_istiming", value: "${_report.r_istiming}"),
          new KeyValueItem(title: "r_senduser", value: _report.r_senduser ?? ""),
          new KeyValueItem(title: "reportTime", value: _report.reportTime.toString()),
          new KeyValueItem(title: "reportPath", value: _report.reportPath),
        ],
      ),
    );
  }
}
