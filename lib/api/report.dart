import 'dart:async';
import "dart:convert";
import 'package:flutter/services.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/report.dart';
import 'package:ompclient/model/session.dart';

Future fetchReports(Session session, {int page = 1}) {
  var client = createHttpClient();
  return checkSessionThenGet(session, client,
          "${server}reportview/getreportviewTable?page=$page&rows=10")
      .then(checkStatus)
      .then(checkToken)
      .then(parseJsonMap)
      .then((Map json) {
    CollectionResponse<Report> response = new CollectionResponse<Report>();
    response.rows = [];
    for (var x in json["rows"]) {
      Report report = new Report();
      report.p_guid = x["p_guid"];
      report.r_type = x["r_type"];
      report.r_name = x["r_name"];
      report.r_period = x["r_period"];
      report.r_isusing = x["r_isusing"];
      report.r_email = x["r_email"];
      report.r_createtime =
          new DateTime.fromMillisecondsSinceEpoch(x["r_createtime"]["time"]);
      report.r_produce = x["r_produce"];
      report.r_judgeofflinetime = x["r_judgeofflinetime"];
      report.r_istiming = x["r_istiming"];
      report.r_senduser = x["r_senduser"];
      report.reportTime = DateTime.parse(x["reportTime"]);
      report.reportPath = x["reportPath"];
      response.rows.add(report);
    }
    response.records = json["records"];
    response.total = json["total"];
    response.page = json["page"];
    return response;
  });
}
