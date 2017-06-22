import 'dart:async';
import 'package:redux/redux.dart';
import 'package:ompclient/store/defination.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/api/report.dart' as api;
import 'package:ompclient/model/report.dart';
import 'package:redux_epics/redux_epics.dart';

const String reportkey = 'report';

class ReportState {
  int total = 0;
  int page = 1;
  int records = 0;
  int offset = 0;
  List<Report> rows = [];
  Report selected = null;
  bool loading = false;
  bool nomore = false;
  Exception error = null;
}

class ReportActionPayload {
  final int page;
  final Exception error;
  final CollectionResponse<Report> response;
  final Report selected;
  ReportActionPayload(
      {this.page = 1, this.error, this.response, this.selected});
}

class ReportAction implements Action {
  String type;
  ReportActionPayload payload;
  bool error;
  String meta;
  ReportAction({this.type, this.payload, this.error, this.meta = reportkey});
}

class ReportReducer extends Reducer<ReportState, ReportAction> {
  reduce(ReportState state, ReportAction action) {
    switch (action.type) {
      case 'REPORTS_REQUEST':
        state.loading = true;
        return state;
      case 'REPORTS_SUCCESS':
        var response = action.payload.response;
        state.loading = false;
        state.nomore =
            (response.rows.length + state.rows.length >= response.records);
        state.total = response.total;
        state.page = response.page;
        state.records = response.records;
        state.rows.addAll(response.rows);
        return state;
      case 'REPORTS_FAILED':
        state.loading = false;
        state.error = action.payload.error;
        return state;
      case 'REPORTS_SELECT':
        state.selected = action.payload.selected;
        return state;
      default:
        return state;
    }
  }
}

class ReportEpic extends Epic<AppState, Action> {
  @override
  Stream<Action> map(
      Stream<Action> actions, EpicStore<AppState, Action> store) {
    return actions
        .where((action) =>
            action is ReportAction &&
            (action as ReportAction).type == 'REPORTS_REQUEST')
        .map((action) => (action as ReportAction).payload)
        .asyncMap((payload) => api
                .fetchReports(page: payload.page)
                .then((CollectionResponse<Report> response) => new ReportAction(
                    type: 'REPORTS_SUCCESS',
                    payload: new ReportActionPayload(response: response),
                    error: false))
                .catchError((error) {
              print(error.stackTrace);
              return new ReportAction(
                  type: 'REPORTS_FAILED',
                  payload: new ReportActionPayload(error: error),
                  error: true);
            }));
  }
}

void fetchReports(Store store, int page) {
  store.dispatch(new ReportAction(
    type: 'REPORTS_REQUEST',
    payload: new ReportActionPayload(
      page: page,
    ),
  ));
}

void selectReport(Store store, Report report) {
  store.dispatch(new ReportAction(
    type: 'REPORTS_SELECT',
    payload: new ReportActionPayload(
      selected: report,
    ),
  ));
}
