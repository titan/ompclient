import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/session.dart';
import 'package:ompclient/model/warning.dart';

Future fetchWarnings(Session session, {int page = 1, String level}) {
  var client = createHttpClient();
  return checkSessionThenGet(session, client,
          "${server}potalshow/findIncident?page=$page&rows=10&level=$level")
      .then(checkStatus)
      .then(checkToken)
      .then(parseJsonMap)
      .then((Map json) {
    CollectionResponse<Warning> response = new CollectionResponse<Warning>();
    response.rows = [];
    for (var x in json["rows"]) {
      Warning warning = new Warning();
      warning.uptime = DateTime.parse(x["uptime"]);
      warning.P_Guid = x["P_Guid"];
      warning.D_Title = x["D_Title"];
      warning.D_Detail = x["D_Detail"];
      warning.itcompId = x["itcompId"];
      warning.D_Urgency = x["D_Urgency"];
      warning.D_PRI = x["D_PRI"];
      warning.itId = x["itId"];
      warning.ip = x["ip"];
      warning.bsname = x["bsname"];
      warning.D_MState = x["D_MState"];
      response.rows.add(warning);
    }
    response.records = json["records"];
    response.total = json["total"];
    response.page = json["page"];
    return response;
  });
}
