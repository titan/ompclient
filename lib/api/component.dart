import 'dart:async';
import "dart:convert";
import 'package:flutter/services.dart';
import 'package:ompclient/api/defination.dart';
import 'package:ompclient/model/component.dart';
import 'package:ompclient/model/session.dart';

Future fetchComponents(Session session, {int page = 1}) {
  var client = createHttpClient();
  return checkSessionThenGet(session, client,
          "${server}itcompmanage/finditCompList?page=1&rows=10")
      .then(checkStatus)
      .then(checkToken)
      .then(parseJsonMap)
      .then((Map json) {
    CollectionResponse<Component> response =
        new CollectionResponse<Component>();
    response.rows = [];
    for (var x in json["rows"]) {
      Component component = new Component();
      component.P_Guid = x["P_Guid"];
      component.AF_Pid = x["AF_Pid"];
      component.D_AVA_STATE = x["D_AVA_STATE"] != null ? x["D_AVA_STATE"] : 0;
      component.D_CAP_STATE = x["D_CAP_STATE"] != null ? x["D_CAP_STATE"] : 0;
      component.D_STATE = x["D_STATE"];
      component.IsOffline = x["IsOffline"];
      component.Com_Duration = x["Com_Duration"];
      component.Com_StartTime = x["Com_StartTime"];
      component.Com_EndTime = x["Com_EndTime"];
      component.Com_A_IsUserComfirmed = x["Com_A_IsUserComfirmed"];
      component.A_CanManage = x["A_CanManage"] ?? false;
      component.A_CanMonitor = x["A_CanMonitor"] ?? false;
      component.A_IsStop = x["A_IsStop"];
      component.A_CIChanged = x["A_CIChanged"];
      component.A_IsEdge = x["A_IsEdge"];
      component.D_BusinessName = x["D_BusinessName"];
      component.D_Useage = x["D_Useage"];
      component.D_Descr = x["D_Descr"];
      component.D_BusinessCode = x["D_BusinessCode"];
      component.D_HostName = x["D_HostName"];
      component.D_ControlAdderss = x["D_ControlAdderss"];
      component.DE_UseState = x["DE_UseState"];
      component.DF_DutyRole = x["DF_DutyRole"];
      component.DF_DutyUser = x["DF_DutyUser"];
      component.DE_ITCatalog = x["DE_ITCatalog"];
      component.DE_ITFunction = x["DE_ITFunction"];
      component.DE_ITManufacturer = x["DE_ITManufacturer"];
      component.DE_ITProductSeries = x["DE_ITProductSeries"];
      component.DF_Path_Site = x["DF_Path_Site"];
      component.DF_Path_Location = x["DF_Path_Location"];
      component.DF_Path_Custom = x["DF_Path_Custom"];
      component.DF_Right_R = x["DF_Right_R"];
      component.DF_Right_W = x["DF_Right_W"];
      component.D_CPU_Unilization = x["D_CPU_Unilization"];
      component.D_Mem_Unilization = x["D_Mem_Unilization"];
      component.D_CPU_State = x["D_CPU_State"];
      component.D_Mem_State = x["D_Mem_State"];
      component.D_CIP_Building = x["D_CIP_Building"];
      component.D_CIP_Floor = x["D_CIP_Floor"];
      component.D_CIP_OPSystem = x["D_CIP_OPSystem"];
      component.D_CIP_Bed = x["D_CIP_Bed"];
      component.D_CIP_SlotInBed = x["D_CIP_SlotInBed"];
      component.D_CIP_Room = x["D_CIP_Room"];
      component.DF_CreateUserId = x["DF_CreateUserId"];
      component.D_CreateTime = x["D_CreateTime"];
      component.DF_UpdateUserId = x["DF_UpdateUserId"];
      component.D_UpdateTime = x["D_UpdateTime"];
      component.DF_CheckUserId = x["DF_CheckUserId"];
      component.D_CheckTime = x["D_CheckTime"];
      component.D_Price = x["D_Price"];
      component.D_UsefulYear = x["D_UsefulYear"];
      component.D_NetSalvageValue = x["D_NetSalvageValue"];
      component.D_ExternalSN = x["D_ExternalSN"];
      component.D_ProductSN = x["D_ProductSN"];
      component.D_Brand = x["D_Brand"];
      component.D_BuyTime = x["D_BuyTime"];
      component.D_BuyCost = x["D_BuyCost"];
      component.D_WarrantyTime = x["D_WarrantyTime"];
      component.DF_CostCustomer = x["DF_CostCustomer"];
      component.DF_CostUser = x["DF_CostUser"];
      component.D_ImageUrl = x["D_ImageUrl"];
      component.D_RunTime = x["D_RunTime"];
      component.D_AssetCode = x["D_AssetCode"];
      component.D_ProviderOrg = x["D_ProviderOrg"];
      component.D_BuyContract = x["D_BuyContract"];
      component.D_ServiceOrg = x["D_ServiceOrg"];
      component.D_ServiceRole = x["D_ServiceRole"];
      component.D_ServiceContract = x["D_ServiceContract"];
      component.D_OldAssetValue = x["D_OldAssetValue"];
      component.D_FixedAssetValue = x["D_FixedAssetValue"];
      component.D_CIP_BusinessDepart = x["D_CIP_BusinessDepart"];
      component.D_CIP_Cabinets = x["D_CIP_Cabinets"];
      component.D_CIP_Model = x["D_CIP_Model"];
      component.D_CIP_CPU = x["D_CIP_CPU"];
      component.D_CIP_Memory = x["D_CIP_Memory"];
      component.D_CIP_HDD = x["D_CIP_HDD"];
      component.D_CIP_NIC = x["D_CIP_NIC"];
      component.D_CIP_FiberCard = x["D_CIP_FiberCard"];
      component.D_CIP_Power = x["D_CIP_Power"];
      component.D_CIP_UsedPowerCount = x["D_CIP_UsedPowerCount"];
      component.D_CIP_DataBase = x["D_CIP_DataBase"];
      component.D_CIP_Middleware = x["D_CIP_Middleware"];
      component.D_CIP_Administrator = x["D_CIP_Administrator"];
      component.D_CIP_Developer = x["D_CIP_Developer"];
      component.D_CIP_StartUseTime = x["D_CIP_StartUseTime"];
      component.D_CIP_ServiceStartTime = x["D_CIP_ServiceStartTime"];
      component.D_CIP_ServiceEndTime = x["D_CIP_ServiceEndTime"];
      component.D_CIP_ServiceProvider = x["D_CIP_ServiceProvider"];
      component.D_CIP_Contact = x["D_CIP_Contact"];
      component.D_CIP_ContactTel = x["D_CIP_ContactTel"];
      component.D_IPLong = x["D_IPLong"] ?? 0;
      component.D_ControlUrl = x["D_ControlUrl"];
      component.DF_LinkTopoID = x["DF_LinkTopoID"];
      component.D_CIP_BatchNumber = x["D_CIP_BatchNumber"];
      component.D_Affect = x["D_Affect"];
      component.D_Urgency = x["D_Urgency"];
      component.DF_LifeCycle = x["DF_LifeCycle"];
      component.D_SupportCompModel = x["D_SupportCompModel"];
      component.D_CIP_SlotCount = x["D_CIP_SlotCount"];
      component.D_ExpiryDate = x["D_ExpiryDate"];
      component.AF_SlaId = x["AF_SlaId"];
      component.F_MonitorTaskId = x["F_MonitorTaskId"];
      component.D_IsDelete = x["D_IsDelete"];
      component.D_LinkManId = x["D_LinkManId"];
      component.D_BackerId = x["D_BackerId"];
      component.D_ReadNum = x["D_ReadNum"];
      component.D_serialNumber = x["D_serialNumber"];
      component.D_type = x["D_type"];
      component.D_workStateReason = x["D_workStateReason"];
      component.D_onlineStateReason = x["D_onlineStateReason"];
      component.devEquNo = x["devEquNo"];
      component.devId = x["devId"];
      component.devSource = x["devSource"];
      component.sourceIp = x["sourceIp"];
      component.sourcePort = x["sourcePort"];
      component.sourceApp = x["sourceApp"];
      component.deItfunctionName = x["deItfunctionName"];
      component.dKey = x["dKey"];
      component.defCompId = x["defCompId"];
      component.yrname = x["yrname"];
      component.credences = x["credences"];
      response.rows.add(component);
    }
    response.records = json["records"];
    response.total = json["total"];
    response.page = json["page"];
    return response;
  });
}

Future fetchComponent(Session session, int id) {
  var client = createHttpClient();
  return checkSessionThenGet(
          session, client, "${server}ItComp/getItCompDetail?itCompID=$id")
      .then(checkStatus)
      .then(checkToken)
      .then(parseJsonList)
      .then((List json) {
    for (var x in json) {
      ComponentDetail detail = new ComponentDetail();
      detail.ACanmanage = x["ACanmanage"];
      detail.ACanmonitor = x["ACanmonitor"];
      detail.ACichanged = x["ACichanged"];
      detail.AIsedge = x["AIsedge"];
      detail.AIsstop = x["AIsstop"];
      detail.CIDetails = x["CIDetails"];
      detail.CRedences = [];
      detail.DAffect = x["DAffect"];
      detail.DAssetcode = x["DAssetcode"];
      detail.DAvaState = x["DAvaState"];
      detail.DBackerid = x["DBackerid"];
      detail.DBrand = x["DBrand"];
      detail.DBusinesscode = x["DBusinesscode"];
      detail.DBusinessname = x["DBusinessname"];
      detail.DBuycontract = x["DBuycontract"];
      detail.DBuycost = x["DBuycost"];
      detail.DBuytime = x["DBuytime"];
      detail.DCapState = x["DCapState"];
      detail.DChecktime = x["DChecktime"];
      detail.DCipAdministrator = x["DCipAdministrator"];
      detail.DCipBatchnumber = x["DCipBatchnumber"];
      detail.DCipBed = x["DCipBed"];
      detail.DCipBuilding = x["DCipBuilding"];
      detail.DCipBusinessdepart = x["DCipBusinessdepart"];
      detail.DCipCabinets = x["DCipCabinets"];
      detail.DCipContact = x["DCipContact"];
      detail.DCipContacttel = x["DCipContacttel"];
      detail.DCipCpu = x["DCipCpu"];
      detail.DCipDatabase = x["DCipDatabase"];
      detail.DCipDeveloper = x["DCipDeveloper"];
      detail.DCipFibercard = x["DCipFibercard"];
      detail.DCipFloor = x["DCipFloor"];
      detail.DCipHdd = x["DCipHdd"];
      detail.DCipMemory = x["DCipMemory"];
      detail.DCipMiddleware = x["DCipMiddleware"];
      detail.DCipModel = x["DCipModel"];
      detail.DCipNic = x["DCipNic"];
      detail.DCipOpsystem = x["DCipOpsystem"];
      detail.DCipPower = x["DCipPower"];
      detail.DCipRoom = x["DCipRoom"];
      detail.DCipServiceendtime = x["DCipServiceendtime"];
      detail.DCipServiceprovider = x["DCipServiceprovider"];
      detail.DCipServicestarttime = x["DCipServicestarttime"];
      detail.DCipSlotcount = x["DCipSlotcount"];
      detail.DCipSlotinbed = x["DCipSlotinbed"];
      detail.DCipStartusetime = x["DCipStartusetime"];
      detail.DCipUsedpowercount = x["DCipUsedpowercount"];
      detail.DControladderss = x["DControladderss"];
      detail.DControlurl = x["DControlurl"];
      detail.DCpuState = x["DCpuState"];
      detail.DCpuUnilization = x["DCpuUnilization"];
      detail.DCreatetime = x["DCreatetime"];
      detail.DDescr = x["DDescr"];
      detail.DExpirydate = x["DExpirydate"];
      detail.DExternalsn = x["DExternalsn"];
      detail.DFixedassetvalue = x["DFixedassetvalue"];
      detail.DHostname = x["DHostname"];
      detail.DImageurl = x["DImageurl"];
      detail.DIplong = x["DIplong"];
      detail.DIsdelete = x["DIsdelete"];
      detail.DLinkmanid = x["DLinkmanid"];
      detail.DMemState = x["DMemState"];
      detail.DMemUnilization = x["DMemUnilization"];
      detail.DNetsalvagevalue = x["DNetsalvagevalue"];
      detail.DOldassetvalue = x["DOldassetvalue"];
      detail.DPrice = x["DPrice"];
      detail.DProductsn = x["DProductsn"];
      detail.DProviderorg = x["DProviderorg"];
      detail.DRuntime = x["DRuntime"];
      detail.DServicecontract = x["DServicecontract"];
      detail.DServiceorg = x["DServiceorg"];
      detail.DServicerole = x["DServicerole"];
      detail.DState = x["DState"];
      detail.DSupportcompmodel = x["DSupportcompmodel"];
      detail.DUpdatetime = x["DUpdatetime"];
      detail.DUrgency = x["DUrgency"];
      detail.DUseage = x["DUseage"];
      detail.DUsefulyear = x["DUsefulyear"];
      detail.DWarrantytime = x["DWarrantytime"];
      detail.FMonitortaskid = x["FMonitortaskid"];
      detail.PGuid = x["PGuid"];
      detail.afPid = x["afPid"];
      detail.afSlaid = x["afSlaid"];
      detail.cabname = x["cabname"];
      detail.comAIsusercomfirmed = x["comAIsusercomfirmed"];
      detail.comDuration = x["comDuration"];
      detail.comEndtime = x["comEndtime"];
      detail.comStarttime = x["comStarttime"];
      detail.compu = x["compu"];
      detail.credences = x["credences"];
      detail.deItcatalog = x["deItcatalog"];
      detail.deItcatalogName = x["deItcatalogName"];
      detail.deItfunction = x["deItfunction"];
      detail.deItfunctionName = x["deItfunctionName"];
      detail.deItmanufacturer = x["deItmanufacturer"];
      detail.deItmanufacturerName = x["deItmanufacturerName"];
      detail.deItproductseries = x["deItproductseries"];
      detail.deItproductseriesName = x["deItproductseriesName"];
      detail.deUsestate = x["deUsestate"];
      detail.defCompId = x["defCompId"];
      detail.defCompName = x["defCompName"];
      detail.detail = [];
      detail.dfCheckuserid = x["dfCheckuserid"];
      detail.dfCostcustomer = x["dfCostcustomer"];
      detail.dfCostuser = x["dfCostuser"];
      detail.dfCreateuserid = x["dfCreateuserid"];
      detail.dfDutyrole = x["dfDutyrole"];
      detail.dfDutyuser = x["dfDutyuser"];
      detail.dfLifecycle = x["dfLifecycle"];
      detail.dfLinktopoid = x["dfLinktopoid"];
      detail.dfPathCustom = x["dfPathCustom"];
      detail.dfPathLocation = x["dfPathLocation"];
      detail.dfPathSite = x["dfPathSite"];
      detail.dfRightR = x["dfRightR"];
      detail.dfRightW = x["dfRightW"];
      detail.dfUpdateuserid = x["dfUpdateuserid"];
      detail.isoffline = x["isoffline"];
      detail.itCompTyleDKey = x["itCompTyleDKey"];
      detail.itCompdCredencetype = x["itCompdCredencetype"];
      detail.situation = x["situation"];
      detail.slot = x["slot"];
      detail.yrname = x["yrname"];

      for (var credence in x["CRedences"]) {
        Credence c = new Credence();
        c.AIsuse = credence["AIsuse"];
        c.AIsuse = credence["AIsuse"];
        c.AState = credence["AState"];
        c.DInstancename = credence["DInstancename"];
        c.DIp = credence["DIp"];
        c.DObjectname = credence["DObjectname"];
        c.DPassword = credence["DPassword"];
        c.DPort = credence["DPort"];
        c.DSnmpcwordor = credence["DSnmpcwordor"];
        c.DSnmpcwordrw = credence["DSnmpcwordrw"];
        c.DTimeoutMs = credence["DTimeoutMs"];
        c.DUsername = credence["DUsername"];
        c.PGuid = credence["PGuid"];
        c.aeType = credence["aeType"];
        c.afItcompid = credence["afItcompid"];
        detail.CRedences.add(c);
      }

      for (var d in x["detail"]) {
        ComponentDetailItem i = new ComponentDetailItem();
        i.Dkey = d["Dkey"];
        i.DivAddress = d["DivAddress"];
        i.DCaption = d["DCaption"];
        i.DetailList = [];
        for (var l in d["DetailList"]) {
          ComponentDetailItemValue v = new ComponentDetailItemValue();
          v.DivName = l["DivName"];
          v.TableNameCh = [];
          v.McimValue = l["McimValue"];
          v.TableNameEn = [];
          for (var c in l["TableNameCh"]) {
            v.TableNameCh.add(c);
          }
          for (var e in l["TableNameEn"]) {
            v.TableNameEn.add(e);
          }
          i.DetailList.add(v);
        }
        detail.detail.add(i);
      }
      return detail;
    }
  });
}
