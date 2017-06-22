import 'dart:async';
import "dart:convert";
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/warning.dart';

Future fetchWarnings({int page = 1, String level}) {
  Future<Map> future = new Future(() {
    var body = """
{"total":2,"page":1,"records":13,"rows":[{"uptime":"2017-04-17 09:24:46","P_Guid":2358,"D_Title":"192.168.1.198[HostDisk>>E:工作]可用性异常","D_Detail":"【E:工作】磁盘使用率:88.2%,大于阀值设置85","itcompId":1337,"D_Urgency":1,"D_PRI":1,"itId":1337,"ip":"192.168.1.198","bsname":"","D_MState":"告警中"},{"uptime":"2017-04-17 09:24:46","P_Guid":2359,"D_Title":"192.168.1.198[HostDisk>>C:]可用性异常","D_Detail":"【C:】磁盘使用率:87.26%,大于阀值设置85","itcompId":1337,"D_Urgency":1,"D_PRI":1,"itId":1337,"ip":"192.168.1.198","bsname":"","D_MState":"告警中"},{"uptime":"2017-04-13 18:04:20","P_Guid":2339,"D_Title":"192.168.10.213[HostCPU>>CPU0]可用性异常","D_Detail":"【CPU0】CPU使用率:98%,大于阀值设置90","itcompId":1296,"D_Urgency":2,"D_PRI":2,"itId":1296,"ip":"192.168.10.213","bsname":null,"D_MState":"告警中"},{"uptime":"2017-04-13 18:04:20","P_Guid":2340,"D_Title":"192.168.10.213[HostCPU>>CPU1]可用性异常","D_Detail":"【CPU1】CPU使用率:98%,大于阀值设置90","itcompId":1296,"D_Urgency":2,"D_PRI":2,"itId":1296,"ip":"192.168.10.213","bsname":null,"D_MState":"告警中"},{"uptime":"2017-04-13 17:48:00","P_Guid":2308,"D_Title":"192.168.10.213[HostProcessor>>CPU]可用性异常","D_Detail":"【CPU】CPU使用率:61.0%,大于阀值设置50","itcompId":1296,"D_Urgency":2,"D_PRI":2,"itId":1296,"ip":"192.168.10.213","bsname":null,"D_MState":"告警中"},{"uptime":"2017-04-13 12:30:40","P_Guid":1752,"D_Title":"192.168.20.207设备离线","D_Detail":"192.168.20.207设备处于离线状态","itcompId":1250,"D_Urgency":2,"D_PRI":null,"itId":1250,"ip":"192.168.20.207","bsname":"dt","D_MState":"告警中"},{"uptime":"2017-04-13 10:56:31","P_Guid":1551,"D_Title":"192.168.10.238设备离线","D_Detail":"192.168.10.238设备处于离线状态","itcompId":1328,"D_Urgency":2,"D_PRI":null,"itId":1328,"ip":"192.168.10.238","bsname":"","D_MState":"告警中"},{"uptime":"2017-04-13 08:37:18","P_Guid":1401,"D_Title":"192.168.10.238凭证异常","D_Detail":"192.168.10.238的SNMPV1OrV2凭证异常","itcompId":1328,"D_Urgency":2,"D_PRI":2,"itId":1328,"ip":"192.168.10.238","bsname":"","D_MState":"告警中"},{"uptime":"2017-04-12 18:01:51","P_Guid":1399,"D_Title":"192.168.10.238[Address>>192.168.10.238]容量性异常","D_Detail":"【192.168.10.238】包成功率:50.0%,小于阀值设置90","itcompId":1328,"D_Urgency":2,"D_PRI":2,"itId":1328,"ip":"192.168.10.238","bsname":"","D_MState":"告警中"},{"uptime":"2017-04-12 16:46:03","P_Guid":1358,"D_Title":"192.168.20.207凭证异常","D_Detail":"192.168.20.207的SSH凭证异常","itcompId":1250,"D_Urgency":2,"D_PRI":2,"itId":1250,"ip":"192.168.20.207","bsname":"dt","D_MState":"告警中"}]}
    """;
    return JSON.decode(body);
  });
  return future
  /*
  return http
      .post(server + "potalshow/findIncident",
          body: {"page": "$page", "rows": "10", "level": level})
      .then((http.Response response) {
        response.body = '{ "page": 1, "total": 1, "records": 1, "rows": [ ] }';
        return response;
      })
      .then(checkStatus)
      .then(parseJson)
      */
      .then((Map json) {
        CollectionResponse<Warning> response =
            new CollectionResponse<Warning>();
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
