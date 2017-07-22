import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/session.dart';

final String url = server + "admin/authorize";

class SignInException implements Exception {
  String _message;

  SignInException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}

Future signIn(String account, String password) {
  var client = createHttpClient();
  return client
      .get(url +
          "?username=" +
          account +
          "&password=" +
          password +
          "&grant_type=client_credentials")
      .then(checkStatus)
      .then(parseJsonMap)
      .then((Map json) {
    if (json.containsKey("state")) {
      throw new SignInException(
          "Error while signing in [StatusCode:${json["state"]}, Error:${json["msg"]}]");
    } else {
      var data = new Session();
      data.access_token = json["access_token"];
      data.refresh_token = json["refresh_token"];
      data.expires_at = new DateTime.fromMillisecondsSinceEpoch(
          new DateTime.now().millisecondsSinceEpoch +
              json["expires_in"] * 1000);
      return data;
    }
  }).whenComplete(client.close);
}
