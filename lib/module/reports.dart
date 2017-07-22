import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/report.dart';
import 'package:ompclient/store/report.dart';
import 'package:ompclient/store/session.dart';

class ReportsPage extends StatefulWidget {
  final String title;
  final Store store;
  ReportsPage({Key key, this.title, this.store}) : super(key: key);
  @override
  _ReportsPageState createState() => new _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final ScrollController _scrollController = new ScrollController();
  bool _reported = false;

  bool _handleScrollNotification(
      ScrollNotification notification, Store store, ReportState state) {
    if (notification.depth == 0 && notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        // got to the end of scrollable
        if (!state.nomore) {
          fetchReports(widget.store, state.page + 1);
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    ReportState _state = widget.store.state.getState(reportkey);
    if (!_state.nomore && _state.rows.length == 0) {
      fetchReports(widget.store, _state.page);
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
    ReportState _state = widget.store.state.getState(reportkey);
    final ThemeData theme = Theme.of(context);
    final List<Widget> items = <Widget>[];
    if (_state.error == null) {
      items.addAll(_state.rows.map((Report report) {
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
                selectReport(
                  widget.store,
                  report,
                );
                Navigator.pushNamed(
                  context,
                  '/report',
                );
              },
            ),
          ),
        );
      }).toList());
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
                    vertical: 2.0,
                    horizontal: 8.0,
                  ),
                  children: items,
                ),
              ));
  }
}
