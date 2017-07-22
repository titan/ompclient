import 'dart:async';
import "dart:convert";
import 'package:flutter/services.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/issue.dart';
import 'package:ompclient/model/session.dart';

Future fetchIssues(Session session, {int page = 1}) {
  var client = createHttpClient();
  return checkSessionThenGet(session, client,
          "${server}task/findTasks?page=$page&rows=10")
      .then(checkStatus)
      .then(checkToken)
      .then(parseJsonMap)
      .then((Map json) {
    CollectionResponse<Issue> response = new CollectionResponse<Issue>();
    response.rows = [];
    for (var x in json["rows"]) {
      Issue issue = new Issue();

      issue.id = x["id"];
      issue.name = x["name"];
      issue.source = x["source"];
      issue.source_id = x["source_id"];
      issue.urgent = x["urgent"];
      issue.affect = x["affect"];
      issue.server_id = x["server_id"];
      issue.depict = x["depict"];
      issue.level = x["level"];
      issue.status = x["status"];
      issue.creator = x["creator"];
      issue.create_time = DateTime.parse(x["create_time"]);
      issue.end_time = x["end_time"] != null ? DateTime.parse(x["end_time"]) : null;
      issue.suggest = x["suggest"];
      issue.evaluate = x["evaluate"] ?? 0;
      issue.property = x["property"];
      issue.cus_name = x["cus_name"];
      issue.cus_phone = x["cus_phone"];
      issue.respose_time = x["respose_time"]["time"] != null
          ? new DateTime.fromMillisecondsSinceEpoch(x["respose_time"]["time"])
          : null;
      issue.solve_time = x["solve_time"] != null
          ? new DateTime.fromMillisecondsSinceEpoch(x["solve_time"]["time"])
          : null;
      issue.copy_id = x["copy_id"];
      issue.category = x["category"];
      issue.t_state = x["t_state"];
      issue.solve_appendix = x["solve_appendix"];
      issue.is_klg = x["is_klg"];
      issue.asset_id = x["asset_id"];
      issue.serverName = x["serverName"];
      issue.action = x["action"];
      issue.action_user_id = x["action_user_id"];
      issue.target_user_id = x["target_user_id"];
      issue.operateName = x["operateName"];
      issue.result = x["result"];
      issue.createName = x["createName"];
      issue.taskStatus = x["taskStatus"];

      response.rows.add(issue);
    }
    response.records = json["records"];
    response.total = json["total"];
    response.page = json["page"];
    return response;
  });
}
