import 'dart:async';
import "dart:convert";
import "dart:core";
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/report.dart';

Future fetchReports({int page = 1}) {
  Future<Map> future = new Future(() {
    var body = """
{"total":1,"page":1,"records":7,"rows":[{"p_guid":52,"r_type":4,"r_name":"cpu1","r_period":10,"r_isusing":1,"r_email":null,"r_createtime":{"date":10,"day":1,"hours":10,"minutes":10,"month":3,"nanos":0,"seconds":50,"time":1491790250000,"timezoneOffset":-480,"year":117},"r_produce":"HostProcessor#1#asc","r_judgeofflinetime":null,"r_istiming":0,"r_senduser":null,"reportTime":"2017-04-10 10:10:51","reportPath":"CPUTop/immediately/522017-04-10.html"},{"p_guid":53,"r_type":4,"r_name":"cpuqq","r_period":10,"r_isusing":1,"r_email":null,"r_createtime":{"date":10,"day":1,"hours":15,"minutes":48,"month":3,"nanos":0,"seconds":8,"time":1491810488000,"timezoneOffset":-480,"year":117},"r_produce":"HostProcessor#1#asc","r_judgeofflinetime":null,"r_istiming":0,"r_senduser":null,"reportTime":"2017-04-10 15:48:11","reportPath":"CPUTop/immediately/532017-04-10.html"},{"p_guid":61,"r_type":1,"r_name":"dsad","r_period":10,"r_isusing":1,"r_email":null,"r_createtime":{"date":11,"day":2,"hours":11,"minutes":22,"month":3,"nanos":0,"seconds":55,"time":1491880975000,"timezoneOffset":-480,"year":117},"r_produce":"usageRate#30#60#80,phyMemUsageRate#30#60#80","r_judgeofflinetime":null,"r_istiming":0,"r_senduser":null,"reportTime":"2017-04-11 11:22:57","reportPath":"ServerCapacity/immediately/612017-04-11.html"},{"p_guid":62,"r_type":2,"r_name":"dsada","r_period":10,"r_isusing":1,"r_email":null,"r_createtime":{"date":11,"day":2,"hours":11,"minutes":23,"month":3,"nanos":0,"seconds":23,"time":1491881003000,"timezoneOffset":-480,"year":117},"r_produce":"utilization#30#60#80,inUtilization#30#60#80,outUtilization#30#60#80","r_judgeofflinetime":null,"r_istiming":0,"r_senduser":null,"reportTime":"2017-04-11 11:23:24","reportPath":"Interface/immediately/622017-04-11.html"},{"p_guid":64,"r_type":0,"r_name":"离线0412","r_period":10,"r_isusing":1,"r_email":null,"r_createtime":{"date":12,"day":3,"hours":16,"minutes":11,"month":3,"nanos":0,"seconds":45,"time":1491984705000,"timezoneOffset":-480,"year":117},"r_produce":"offlinNum,offlineTime,offlineCountNum,offlinDetail","r_judgeofflinetime":120,"r_istiming":0,"r_senduser":"8","reportTime":"2017-04-12 16:11:45","reportPath":"offlineReport/immediately/642017-04-12.html"},{"p_guid":65,"r_type":4,"r_name":"cpu11","r_period":10,"r_isusing":1,"r_email":null,"r_createtime":{"date":12,"day":3,"hours":16,"minutes":14,"month":3,"nanos":0,"seconds":16,"time":1491984856000,"timezoneOffset":-480,"year":117},"r_produce":"HostProcessor#1#asc","r_judgeofflinetime":null,"r_istiming":0,"r_senduser":"8","reportTime":"2017-04-12 16:14:18","reportPath":"CPUTop/immediately/652017-04-12.html"},{"p_guid":66,"r_type":0,"r_name":"0413离线","r_period":10,"r_isusing":1,"r_email":null,"r_createtime":{"date":13,"day":4,"hours":8,"minutes":40,"month":3,"nanos":0,"seconds":45,"time":1492044045000,"timezoneOffset":-480,"year":117},"r_produce":"offlinNum,offlineTime,offlineCountNum,offlinDetail","r_judgeofflinetime":120,"r_istiming":0,"r_senduser":null,"reportTime":"2017-04-13 08:40:45","reportPath":"offlineReport/immediately/662017-04-13.html"}]}
    """;
    return JSON.decode(body);
  });
  return future
    /*
  return http.post(server + "reportview/getreportviewTable", body: { "page": "$page", "rows": "10"})
    .then(checkStatus)
    .then(parseJson)
    */
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
        report.r_createtime = new DateTime.fromMillisecondsSinceEpoch(x["r_createtime"]["time"]);
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
