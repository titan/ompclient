import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/model/issue.dart';
import 'package:ompclient/store/issue.dart';

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
  @override
  void initState() {
    super.initState();
    IssueState _state = widget.store.state.getState(issuekey);
    if (!_state.nomore && _state.rows.length == 0) {
      fetchIssues(widget.store, _state.page);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IssueState _state = widget.store.state.getState(issuekey);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        children: _state.rows.map((Issue issue) {
          return new Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new IssueItem(
                issue: issue,
                onTap: () {
                  selectIssue(widget.store, issue);
                  Navigator.pushNamed(context, '/issue');
                }),
          );
        }).toList(),
      ),
    );
  }
}
