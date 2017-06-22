import 'dart:async';
import 'package:redux/redux.dart';
import 'package:ompclient/store/defination.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/api/issue.dart' as api;
import 'package:ompclient/model/issue.dart';
import 'package:redux_epics/redux_epics.dart';

const String issuekey = 'issue';

class IssueState {
  int total = 0;
  int page = 1;
  int records = 0;
  int offset = 0;
  List<Issue> rows = [];
  Issue selected = null;
  bool loading = false;
  bool nomore = false;
  Exception error = null;
}

class IssueActionPayload {
  final int page;
  final Exception error;
  final CollectionResponse<Issue> response;
  final Issue selected;
  IssueActionPayload(
      {this.page = 1, this.error, this.response, this.selected});
}

class IssueAction implements Action {
  String type;
  IssueActionPayload payload;
  bool error;
  String meta;
  IssueAction({this.type, this.payload, this.error, this.meta = issuekey});
}

class IssueReducer extends Reducer<IssueState, IssueAction> {
  reduce(IssueState state, IssueAction action) {
    switch (action.type) {
      case 'ISSUES_REQUEST':
        state.loading = true;
        return state;
      case 'ISSUES_SUCCESS':
        var response = action.payload.response;
        state.loading = false;
        state.nomore =
            (response.rows.length + state.rows.length >= response.records);
        state.total = response.total;
        state.page = response.page;
        state.records = response.records;
        state.rows.addAll(response.rows);
        return state;
      case 'ISSUES_FAILED':
        state.loading = false;
        state.error = action.payload.error;
        return state;
      case 'ISSUES_SELECT':
        state.selected = action.payload.selected;
        return state;
      default:
        return state;
    }
  }
}

class IssueEpic extends Epic<AppState, Action> {
  @override
  Stream<Action> map(
      Stream<Action> actions, EpicStore<AppState, Action> store) {
    return actions
        .where((action) =>
            action is IssueAction &&
            (action as IssueAction).type == 'ISSUES_REQUEST')
        .map((action) => (action as IssueAction).payload)
        .asyncMap((payload) => api
                .fetchIssues(page: payload.page)
                .then((CollectionResponse<Issue> response) => new IssueAction(
                    type: 'ISSUES_SUCCESS',
                    payload: new IssueActionPayload(response: response),
                    error: false))
                .catchError((error) {
              print(error.stackTrace);
              return new IssueAction(
                  type: 'ISSUES_FAILED',
                  payload: new IssueActionPayload(error: error),
                  error: true);
            }));
  }
}

void fetchIssues(Store store, int page) {
  store.dispatch(new IssueAction(
    type: 'ISSUES_REQUEST',
    payload: new IssueActionPayload(
      page: page,
    ),
  ));
}

void selectIssue(Store store, Issue issue) {
  store.dispatch(new IssueAction(
    type: 'ISSUES_SELECT',
    payload: new IssueActionPayload(
      selected: issue,
    ),
  ));
}
