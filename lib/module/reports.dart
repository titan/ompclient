import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/model/report.dart';
import 'package:ompclient/store/report.dart';

class ReportsPage extends StatefulWidget {
  final String title;
  final Store store;
  ReportsPage({Key key, this.title, this.store}) : super(key: key);
  @override
  _ReportsPageState createState() => new _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    ReportState _state = widget.store.state.getState(reportkey);
    if (!_state.nomore && _state.rows.length == 0) {
      fetchReports(widget.store, _state.page);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ReportState _state = widget.store.state.getState(reportkey);
    final ThemeData theme = Theme.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        children: _state.rows.map((Report report) {
          return new Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                title: new Text(report.r_name),
                subtitle: new Text(report.reportTime.toString()),
                onTap: () {
                  selectReport(widget.store, report);
                  Navigator.pushNamed(context, '/report');
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
