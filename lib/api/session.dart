import 'dart:async';
import 'package:ompclient/api/defination.dart';

final String url = server + "admin/login";

class SignInException implements Exception {
  String _message;

  SignInException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}

Future signIn(String account, String password) {
  return http.get(url).then((http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode > 199 && statusCode < 307) {
      return response;
    } else {
      throw new SignInException("Error while signing in [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
    }
  }).then((http.Response response) {
    if (response.headers.containsKey('set-cookie')) {
      var pair = response.headers['set-cookie'].split(';')[0];
      var session = pair.split('=')[1];
      return session;
    } else {
      throw new SignInException("Session not found");
    }
  }).then((String session) {
    print("session is [$session]");
    return http.post(url, body: {"username": account, "password": password}).then((http.Response response) {
      final statusCode = response.statusCode;
      if (statusCode == 200) {
        return session;
      } else {
        throw new SignInException("Error while signing in [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }
    });
  });
}
