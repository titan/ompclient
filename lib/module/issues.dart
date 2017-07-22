import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/issue.dart';
import 'package:ompclient/store/issue.dart';
import 'package:ompclient/store/session.dart';

class IssueItem extends StatelessWidget {
  final Issue issue;
  final GestureTapCallback onTap;
  IssueItem({Key key, this.issue, this.onTap}) : super(key: key);
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
                color: Colors.blue[500],
              ),
            ),
          ),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                issue.name,
                softWrap: true,
                style: new TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[500],
                ),
              ),
              new Text(
                issue.serverName,
                softWrap: true,
                style: theme.textTheme.body1,
              ),
              new Text(issue.create_time.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class IssuesPage extends StatefulWidget {
  final String title;
  final Store store;
  IssuesPage({Key key, this.title, this.store}) : super(key: key);
  @override
  _IssuesPageState createState() => new _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  final ScrollController _scrollController = new ScrollController();
  bool _reported = false;

  bool _handleScrollNotification(
      ScrollNotification notification, Store store, IssueState state) {
    if (notification.depth == 0 && notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        // got to the end of scrollable
        if (!state.nomore) {
          fetchIssues(widget.store, state.page + 1);
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    IssueState _state = widget.store.state.getState(issuekey);
    if (!_state.nomore && _state.rows.length == 0) {
      fetchIssues(widget.store, _state.page);
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
    IssueState _state = widget.store.state.getState(issuekey);
    final ThemeData theme = Theme.of(context);
    final List<Widget> items = <Widget>[];
    if (_state.error == null) {
      items.addAll(_state.rows.map((Issue issue) {
        return new Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: new IssueItem(
            issue: issue,
            onTap: () {
              selectIssue(
                widget.store,
                issue,
              );
              Navigator.pushNamed(
                context,
                '/issue',
              );
            },
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
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  children: items,
                ),
              ));
  }
}
