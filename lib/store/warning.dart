import 'dart:async';
import 'package:redux/redux.dart';
import 'package:ompclient/store/defination.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/api/warning.dart' as api;
import 'package:ompclient/model/warning.dart';
import 'package:redux_epics/redux_epics.dart';

const String warningkey = 'warning';

class WarningState {
  int total = 0;
  int page = 1;
  int records = 0;
  int offset = 0;
  List<Warning> rows = [];
  Warning selected;
  bool loading = false;
  bool nomore = false;
  String level;
  Exception error;
}

class WarningActionPayload {
  int page;
  String level;
  Exception error;
  CollectionResponse<Warning> response;
  Warning selected;
  WarningActionPayload({ this.page = 1, this.level = "1,2", this.error, this.response, this.selected });
}

class WarningAction implements Action {
  String type;
  WarningActionPayload payload;
  bool error;
  String meta;
  WarningAction({this.type, this.payload, this.error, this.meta = warningkey});
}

class WarningReducer extends Reducer<Map<String, WarningState>, WarningAction> {
  reduce(Map<String, WarningState> states, WarningAction action) {
    String level = action.payload.level;
    WarningState state = states[level];
    switch (action.type) {
      case 'WARNINGS_REQUEST':
        state.loading = true;
        return states;
      case 'WARNINGS_SUCCESS':
        var response = action.payload.response;
        var state = states[level];
        state.loading = false;
        state.nomore = (response.rows.length + state.rows.length >= response.records);
        state.total = response.total;
        state.page = response.page;
        state.records = response.records;
        state.rows.addAll(response.rows);
        return states;
      case 'WARNINGS_FAILED':
        state.loading = false;
        state.error = action.payload.error;
        return states;
      case 'WARNINGS_SELECT':
        states["selected"] = states[level];
        state.selected = action.payload.selected;
        return states;
      default:
        return states;
    }
  }
}

class WarningEpic extends Epic<AppState, Action> {
  @override
  Stream<Action> map(Stream<Action> actions, EpicStore<AppState, Action> store) {
    return actions
      .where((action) => action is WarningAction && (action as WarningAction).type == 'WARNINGS_REQUEST')
      .map((action) => (action as WarningAction).payload)
      .asyncMap((payload) =>
          api.fetchWarnings(page: payload.page, level: payload.level)
          .then((CollectionResponse<Warning> response) => new WarningAction(type: 'WARNINGS_SUCCESS', payload: new WarningActionPayload(response: response, level: payload.level), error: false))
          .catchError((error) { print(error); return new WarningAction(type: 'WARNINGS_FAILED', payload: new WarningActionPayload(error: error, level: payload.level), error: true);})
          );
  }
}

void fetchWarnings(Store store, String level, int page) {
  store.dispatch(new WarningAction(
        type: 'WARNINGS_REQUEST',
        payload: new WarningActionPayload(
          level: level,
          page: page,
          ),
        )
      );
}

void selectWarning(Store store, Warning warning) {
  store.dispatch(new WarningAction(
        type: 'WARNINGS_SELECT',
        payload: new WarningActionPayload(
          selected: warning,
          ),
        )
      );
}

