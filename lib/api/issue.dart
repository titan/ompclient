import 'dart:async';
import "dart:convert";
import "dart:core";
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/issue.dart';

Future fetchIssues({int page = 1}) {
  Future future = new Future(() {
    var body = """
{"total":2,"page":1,"records":13,"rows":[{"id":418,"name":"10.213","source":null,"source_id":484,"urgent":2,"affect":1,"server_id":"1","depict":"192.168.10.213的SNMPV1OrV2凭证异常","level":2,"status":3,"creator":8,"create_time":"2017-04-12 08:48:14","end_time":null,"suggest":null,"evaluate":null,"property":1,"cus_name":"","cus_phone":"","respose_time":{"date":12,"day":3,"hours":9,"minutes":3,"month":3,"nanos":0,"seconds":44,"time":1491959024000,"timezoneOffset":-480,"year":117},"solve_time":null,"copy_id":0,"category":0,"t_state":null,"solve_appendix":null,"is_klg":0,"asset_id":null,"serverName":"机房空间规划","action":3,"action_user_id":8,"target_user_id":null,"operateName":null,"result":"分地方上班","createName":"admin","taskStatus":3},{"id":419,"name":"1","source":null,"source_id":480,"urgent":1,"affect":1,"server_id":"1","depict":"","level":1,"status":4,"creator":8,"create_time":"2017-04-12 08:56:31","end_time":null,"suggest":null,"evaluate":null,"property":1,"cus_name":"","cus_phone":"","respose_time":{"date":12,"day":3,"hours":9,"minutes":37,"month":3,"nanos":0,"seconds":41,"time":1491961061000,"timezoneOffset":-480,"year":117},"solve_time":{"date":12,"day":3,"hours":10,"minutes":30,"month":3,"nanos":0,"seconds":13,"time":1491964213000,"timezoneOffset":-480,"year":117},"copy_id":0,"category":0,"t_state":null,"solve_appendix":null,"is_klg":2,"asset_id":null,"serverName":"机房空间规划","action":4,"action_user_id":8,"target_user_id":null,"operateName":null,"result":"阿斯顿发大水","createName":"admin","taskStatus":4},{"id":422,"name":"桌子事件","source":null,"source_id":487,"urgent":1,"affect":1,"server_id":"1","depict":"","level":1,"status":4,"creator":8,"create_time":"2017-04-12 11:00:38","end_time":null,"suggest":null,"evaluate":null,"property":1,"cus_name":"","cus_phone":"","respose_time":{"date":12,"day":3,"hours":15,"minutes":59,"month":3,"nanos":0,"seconds":17,"time":1491983957000,"timezoneOffset":-480,"year":117},"solve_time":{"date":13,"day":4,"hours":14,"minutes":43,"month":3,"nanos":0,"seconds":42,"time":1492065822000,"timezoneOffset":-480,"year":117},"copy_id":0,"category":0,"t_state":null,"solve_appendix":null,"is_klg":2,"asset_id":84,"serverName":"机房空间规划","action":4,"action_user_id":8,"target_user_id":null,"operateName":null,"result":"","createName":"admin","taskStatus":4},{"id":423,"name":"桌子问题","source":null,"source_id":437,"urgent":1,"affect":1,"server_id":"13","depict":"","level":1,"status":4,"creator":8,"create_time":"2017-04-13 17:51:12","end_time":null,"suggest":null,"evaluate":null,"property":1,"cus_name":"","cus_phone":"","respose_time":{"date":13,"day":4,"hours":17,"minutes":51,"month":3,"nanos":0,"seconds":27,"time":1492077087000,"timezoneOffset":-480,"year":117},"solve_time":{"date":13,"day":4,"hours":17,"minutes":52,"month":3,"nanos":0,"seconds":26,"time":1492077146000,"timezoneOffset":-480,"year":117},"copy_id":0,"category":1,"t_state":null,"solve_appendix":null,"is_klg":1,"asset_id":84,"serverName":"网络运行监控","action":4,"action_user_id":8,"target_user_id":null,"operateName":null,"result":"","createName":"admin","taskStatus":4},{"id":421,"name":"5","source":null,"source_id":483,"urgent":1,"affect":1,"server_id":"13","depict":"","level":1,"status":4,"creator":8,"create_time":"2017-04-12 09:49:41","end_time":null,"suggest":null,"evaluate":null,"property":1,"cus_name":"","cus_phone":"","respose_time":{"date":12,"day":3,"hours":9,"minutes":50,"month":3,"nanos":0,"seconds":3,"time":1491961803000,"timezoneOffset":-480,"year":117},"solve_time":{"date":14,"day":5,"hours":8,"minutes":56,"month":3,"nanos":0,"seconds":19,"time":1492131379000,"timezoneOffset":-480,"year":117},"copy_id":0,"category":0,"t_state":null,"solve_appendix":null,"is_klg":1,"asset_id":null,"serverName":"网络运行监控","action":4,"action_user_id":8,"target_user_id":null,"operateName":null,"result":"","createName":"admin","taskStatus":4},{"id":420,"name":"2","source":null,"source_id":482,"urgent":1,"affect":1,"server_id":"1","depict":"","level":1,"status":4,"creator":8,"create_time":"2017-04-12 09:44:38","end_time":null,"suggest":null,"evaluate":null,"property":1,"cus_name":"","cus_phone":"","respose_time":{"date":12,"day":3,"hours":9,"minutes":45,"month":3,"nanos":0,"seconds":37,"time":1491961537000,"timezoneOffset":-480,"year":117},"solve_time":{"date":14,"day":5,"hours":8,"minutes":56,"month":3,"nanos":0,"seconds":22,"time":1492131382000,"timezoneOffset":-480,"year":117},"copy_id":0,"category":0,"t_state":null,"solve_appendix":null,"is_klg":1,"asset_id":null,"serverName":"机房空间规划","action":4,"action_user_id":8,"target_user_id":null,"operateName":null,"result":"","createName":"admin","taskStatus":4},{"id":424,"name":"sdfsdfsd","source":null,"source_id":489,"urgent":2,"affect":2,"server_id":"1","depict":"","level":3,"status":1,"creator":8,"create_time":"2017-04-14 09:17:37","end_time":null,"suggest":null,"evaluate":null,"property":1,"cus_name":"","cus_phone":"","respose_time":{"date":14,"day":5,"hours":9,"minutes":17,"month":3,"nanos":0,"seconds":53,"time":1492132673000,"timezoneOffset":-480,"year":117},"solve_time":null,"copy_id":0,"category":0,"t_state":null,"solve_appendix":null,"is_klg":0,"asset_id":84,"serverName":"机房空间规划","action":7,"action_user_id":8,"target_user_id":null,"operateName":null,"result":null,"createName":"admin","taskStatus":7},{"id":425,"name":"41401","source":null,"source_id":490,"urgent":1,"affect":1,"server_id":"9","depict":"","level":1,"status":4,"creator":8,"create_time":"2017-04-14 10:06:42","end_time":null,"suggest":null,"evaluate":null,"property":1,"cus_name":"","cus_phone":"","respose_time":{"date":14,"day":5,"hours":10,"minutes":7,"month":3,"nanos":0,"seconds":35,"time":1492135655000,"timezoneOffset":-480,"year":117},"solve_time":{"date":14,"day":5,"hours":10,"minutes":8,"month":3,"nanos":0,"seconds":9,"time":1492135689000,"timezoneOffset":-480,"year":117},"copy_id":0,"category":0,"t_state":null,"solve_appendix":null,"is_klg":1,"asset_id":null,"serverName":"机房卫生","action":4,"action_user_id":8,"target_user_id":null,"operateName":null,"result":"","createName":"admin","taskStatus":4},{"id":426,"name":"41402","source":null,"source_id":491,"urgent":1,"affect":1,"server_id":"9","depict":"","level":1,"status":4,"creator":8,"create_time":"2017-04-14 10:07:07","end_time":null,"suggest":null,"evaluate":null,"property":1,"cus_name":"","cus_phone":"","respose_time":{"date":14,"day":5,"hours":10,"minutes":7,"month":3,"nanos":0,"seconds":39,"time":1492135659000,"timezoneOffset":-480,"year":117},"solve_time":{"date":14,"day":5,"hours":10,"minutes":8,"month":3,"nanos":0,"seconds":12,"time":1492135692000,"timezoneOffset":-480,"year":117},"copy_id":0,"category":0,"t_state":null,"solve_appendix":null,"is_klg":1,"asset_id":null,"serverName":"机房卫生","action":4,"action_user_id":8,"target_user_id":null,"operateName":null,"result":"","createName":"admin","taskStatus":4},{"id":427,"name":"41403","source":null,"source_id":492,"urgent":1,"affect":1,"server_id":"9","depict":"","level":1,"status":4,"creator":8,"create_time":"2017-04-14 10:07:21","end_time":null,"suggest":null,"evaluate":null,"property":1,"cus_name":"","cus_phone":"","respose_time":{"date":14,"day":5,"hours":10,"minutes":7,"month":3,"nanos":0,"seconds":41,"time":1492135661000,"timezoneOffset":-480,"year":117},"solve_time":{"date":14,"day":5,"hours":10,"minutes":8,"month":3,"nanos":0,"seconds":15,"time":1492135695000,"timezoneOffset":-480,"year":117},"copy_id":0,"category":0,"t_state":null,"solve_appendix":null,"is_klg":1,"asset_id":null,"serverName":"机房卫生","action":4,"action_user_id":8,"target_user_id":null,"operateName":null,"result":"","createName":"admin","taskStatus":4}]}
    """;
    return JSON.decode(body);
  });
  return future
    /*
  return http
      .post(server + "task/findTasks",
          body: {"page": "$page", "rows": "10"})
      .then((http.Response response) {
        print(response.body);
        return response;
      })
      .then(checkStatus)
      .then(parseJson)
      */
      .then((Map json) {
        CollectionResponse<Issue> response =
            new CollectionResponse<Issue>();
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
          issue.evaluate = x["evaluate"];
          issue.property = x["property"];
          issue.cus_name = x["cus_name"];
          issue.cus_phone = x["cus_phone"];
          issue.respose_time = x["respose_time"]["time"] != null ? new DateTime.fromMillisecondsSinceEpoch(x["respose_time"]["time"]) : null;
          issue.solve_time = x["solve_time"] != null ? new DateTime.fromMillisecondsSinceEpoch(x["solve_time"]["time"]) : null;
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
