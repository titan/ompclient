import 'dart:async';
import "dart:convert";
import 'package:http/http.dart' as http;
import 'package:ompclient/model/session.dart';

const server = "http://202.97.158.60:8085/nnomp/";

class TokenException implements Exception {
  String _message;

  TokenException(this._message);

  String toString() {
    return "TokenException: ${_message}";
  }
}

http.Response checkStatus(http.Response response) {
  final status = response.statusCode;
  if (status > 199 && status < 300) {
    return response;
  } else {
    throw new http.ClientException(response.body);
  }
}

http.Response checkToken(http.Response response) {
  if (response.body.indexOf("{\"state\":0,\"msg\":\"令牌不正确!\"}") != -1) {
    throw new TokenException("Access token invalid. ${response.body}");
  } else if (response.body.indexOf("{\"state\":2,\"msg\":\"令牌时间失效!\"}") != -1) {
    throw new TokenException("Access token expired. ${response.body}");
  } else {
    return response;
  }
}

Map parseJsonMap(http.Response response) {
  return JSON.decode(response.body);
}

List parseJsonList(http.Response response) {
  return JSON.decode(response.body);
}

class CollectionResponse<T> {
  List<T> rows;
  int records;
  int total;
  int page;
}

Future checkSessionThenGet(Session session, http.Client client, String url) {
  if ((new DateTime.now().millisecondsSinceEpoch + 300000) < session.expires_at.millisecondsSinceEpoch) {
    return client.get("$url&access_token=${session.access_token}");
  } else {
    // try to refresh tokens
    return client.get("${server}admin/authorize?grant_type=refresh_token&username=${session.account}&access_token=${session.access_token}&refresh_token=${session.refresh_token}")
      .then(checkStatus)
      .then(parseJsonMap)
      .then((Map json) {
        if (json.containsKey("state")) {
          // error to refresh token
          throw new TokenException("Refresh token failed. [StatusCode:${json["state"]}, Error:${json["msg"]}]");
        } else {
          session.access_token = json["access_token"];
          session.refresh_token = json["refresh_token"];
          session.expires_at = new DateTime.fromMillisecondsSinceEpoch(
              new DateTime.now().millisecondsSinceEpoch +
              json["expires_in"] * 1000);
          return client.get("$url&access_token=${session.access_token}");
        }
      });
  }
}
