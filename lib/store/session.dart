import 'dart:async';
import 'package:redux/redux.dart';
import 'package:ompclient/store/defination.dart';
import 'package:ompclient/api/session.dart' as api;
import 'package:redux_epics/redux_epics.dart';

const String sessionkey = 'session';

class SessionState {
  String session;
  bool loading;
  Exception error;
}

class SessionActionPayload {
  String account;
  String password;
  String session;
  Exception error;
  SessionActionPayload({this.account, this.password, this.session, this.error});
}

class SessionAction implements Action {
  String type;
  SessionActionPayload payload;
  bool error;
  String meta;
  SessionAction({this.type, this.payload, this.error : false, this.meta = sessionkey});
}

class SessionReducer extends Reducer<SessionState, SessionAction> {
  reduce(SessionState state, SessionAction action) {
    switch (action.type) {
      case 'SIGNIN_REQUEST':
        state.loading = true;
        return state;
      case 'SIGNIN_SUCCESS':
        state.loading = false;
        state.session = action.payload.session;
        return state;
      case 'SIGNIN_FAILED':
        state.loading = false;
        state.error = action.payload.error;
        return state;
      default:
        return state;
    }
  }
}

class SessionEpic extends Epic<AppState, Action> {
  @override
  Stream<Action> map(Stream<Action> actions, EpicStore<AppState, Action> store) {
    return actions
      .where((action) => action is SessionAction && (action as SessionAction).type == 'SIGNIN_REQUEST')
      .map((action) => (action as SessionAction).payload)
      .asyncMap((payload) =>
          api.signIn(payload.account, payload.password)
          .then((String session) => new SessionAction(type: 'SIGNIN_SUCCESS', payload: new SessionActionPayload(session: session), error: false))
          .catchError((error) => new SessionAction(type: 'SIGNIN_FAILED', payload: new SessionActionPayload(error: error), error: true))
      );
  }
}

void signIn(Store store, String account, String password) {
  store.dispatch(new SessionAction(
        type: 'SIGNIN_REQUEST',
        payload: new SessionActionPayload(
          account: account,
          password: password,
          ),
        ));
}
