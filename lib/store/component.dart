import 'dart:async';
import 'package:ompclient/api/component.dart' as api;
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/component.dart';
import 'package:ompclient/store/defination.dart';
import 'package:ompclient/store/session.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

const String componentkey = 'component';

class ComponentState {
  int total = 0;
  int page = 1;
  int records = 0;
  int offset = 0;
  List<Component> rows = [];
  Component selected = null;
  ComponentDetail detail = null;
  bool loading = false;
  bool nomore = false;
  Exception error = null;
}

class ComponentActionPayload {
  final int page;
  final Exception error;
  final CollectionResponse<Component> response;
  final Component selected;
  final ComponentDetail detail;
  ComponentActionPayload({
    this.page = 1,
    this.error,
    this.response,
    this.selected,
    this.detail,
  });
}

class ComponentAction implements Action {
  String type;
  ComponentActionPayload payload;
  bool error;
  String meta;
  ComponentAction({
    this.type,
    this.payload,
    this.error,
    this.meta = componentkey,
  });
}

class ComponentReducer extends Reducer<ComponentState, ComponentAction> {
  reduce(ComponentState state, ComponentAction action) {
    switch (action.type) {
      case 'COMPONENTS_REQUEST':
        state.loading = true;
        return state;
      case 'COMPONENTS_SUCCESS':
        var response = action.payload.response;
        state.loading = false;
        state.nomore =
            (response.rows.length + state.rows.length >= response.records);
        state.total = response.total;
        state.page = response.page;
        state.records = response.records;
        state.rows.addAll(response.rows);
        return state;
      case 'COMPONENTS_FAILED':
        state.loading = false;
        state.error = action.payload.error;
        return state;
      case 'COMPONENTS_SELECT':
        state.selected = action.payload.selected;
        state.detail = null;
        return state;
      case 'COMPONENT_REQUEST':
        state.loading = true;
        return state;
      case 'COMPONENT_SUCCESS':
        state.loading = false;
        state.detail = action.payload.detail;
        return state;
      case 'COMPONENT_FAILED':
        state.loading = false;
        state.error = action.payload.error;
        return state;
      default:
        return state;
    }
  }
}

class ComponentEpic extends Epic<AppState, Action> {
  @override
  Stream<Action> map(
      Stream<Action> actions, EpicStore<AppState, Action> store) {
    return actions
        .where((action) =>
            action is ComponentAction && action.type == 'COMPONENTS_REQUEST')
        .map((action) => (action as ComponentAction).payload)
        .asyncMap((payload) => api
                .fetchComponents(store.state.getState(sessionkey).session,
                    page: payload.page)
                .then((CollectionResponse<Component> response) =>
                    new ComponentAction(
                      type: 'COMPONENTS_SUCCESS',
                      payload: new ComponentActionPayload(response: response),
                      error: false,
                    ))
                .catchError((error) {
              print(error);
              if (error is Error) {
                print(error.stackTrace);
              }
              return new ComponentAction(
                type: 'COMPONENTS_FAILED',
                payload: new ComponentActionPayload(
                  error: (error is Exception)
                      ? error
                      : new Exception("${error}${error.stackTrace}"),
                ),
                error: true,
              );
            }));
  }
}

class ComponentDetailEpic extends Epic<AppState, Action> {
  @override
  Stream<Action> map(
      Stream<Action> actions, EpicStore<AppState, Action> store) {
    return actions
        .where((action) =>
            action is ComponentAction &&
            (action as ComponentAction).type == 'COMPONENT_REQUEST')
        .map((action) => (action as ComponentAction).payload)
        .asyncMap((payload) => api
                .fetchComponent(store.state.getState(sessionkey).session,
                    payload.selected.P_Guid)
                .then((ComponentDetail detail) => new ComponentAction(
                      type: 'COMPONENT_SUCCESS',
                      payload: new ComponentActionPayload(detail: detail),
                      error: false,
                    ))
                .catchError((error) {
              print(error);
              if (error is Error) {
                print(error.stackTrace);
              }
              return new ComponentAction(
                type: 'COMPONENT_FAILED',
                payload: new ComponentActionPayload(
                  error: (error is Exception)
                      ? error
                      : new Exception("${error}${error.stackTrace}"),
                ),
                error: true,
              );
            }));
  }
}

void fetchComponents(Store store, int page) {
  store.dispatch(new ComponentAction(
    type: 'COMPONENTS_REQUEST',
    payload: new ComponentActionPayload(
      page: page,
    ),
  ));
}

void selectComponent(Store store, Component component) {
  store.dispatch(new ComponentAction(
    type: 'COMPONENTS_SELECT',
    payload: new ComponentActionPayload(
      selected: component,
    ),
  ));
}

void fetchComponent(Store store) {
  var selected = store.state.getState(componentkey).selected;
  if (selected == null) {
    store.dispatch(new ComponentAction(
      type: 'COMPONENT_FAILED',
      payload: new ComponentActionPayload(
        error: new Exception("Component not selected"),
      ),
    ));
  } else {
    store.dispatch(new ComponentAction(
      type: 'COMPONENT_REQUEST',
      payload: new ComponentActionPayload(
        selected: selected,
      ),
    ));
  }
}
