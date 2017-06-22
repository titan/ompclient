import 'package:redux/redux.dart';
import 'package:ompclient/store/defination.dart';
import 'package:ompclient/store/session.dart';
import 'package:ompclient/store/warning.dart';
import 'package:ompclient/store/report.dart';
import 'package:ompclient/store/issue.dart';
import 'package:ompclient/store/component.dart';
import 'package:redux_epics/redux_epics.dart';

class AppReducer extends Reducer<AppState, Action> {
  Map<String, Reducer<Object, Action>> reducers;

  AppReducer() {
    this.reducers = new Map<String, Reducer<Object, Action>>();
  }

  void putReducer(String tag, Reducer<Object, Action> reducer) {
    this.reducers[tag] = reducer;
  }

  AppState reduce(AppState state, Action action) {
    Object substate = state.getState(action.meta);
    if (substate != null) {
      state.putState(action.meta, this.reducers[action.meta].reduce(substate, action));
    }
    return state;
  }
}

Store createStore() {
  final reducer = new AppReducer();
  final state = new AppState();
  final epicMiddleware = new EpicMiddleware(new CombinedEpic<AppState, Action>([
    new SessionEpic(),
    new WarningEpic(),
    new ReportEpic(),
    new IssueEpic(),
    new ComponentEpic(),
    new ComponentDetailEpic(),
  ]));

  reducer.putReducer(sessionkey, new SessionReducer());
  state.putState(sessionkey, new SessionState());
  reducer.putReducer(warningkey, new WarningReducer());
  state.putState(warningkey, {"selected": null, "1,2": new WarningState(), "3,4": new WarningState(), "6,9": new WarningState()});
  reducer.putReducer(reportkey, new ReportReducer());
  state.putState(reportkey, new ReportState());
  reducer.putReducer(issuekey, new IssueReducer());
  state.putState(issuekey, new IssueState());
  reducer.putReducer(componentkey, new ComponentReducer());
  state.putState(componentkey, new ComponentState());
  return new Store(reducer, middleware: [epicMiddleware], initialState: state);
}
