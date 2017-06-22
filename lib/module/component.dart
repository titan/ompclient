import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:ompclient/model/component.dart';
import 'package:ompclient/module/keyvalue.dart';
import 'package:ompclient/store/component.dart';

const double kIssueItemHeight = 48.0;

class Pair<F, S> {
  final F first;
  final S second;
  Pair(this.first, this.second);
}

class PairItem extends StatelessWidget {
  final List<Pair<String, String>> pairs;
  PairItem({Key key, this.pairs}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new ListView(
        shrinkWrap: true,
        children: pairs.map((x) {
          return new KeyValueItem(title: x.first, value: x.second, height: 24.0);
        }).toList(),
      ),
    );
  }
}

class TabMenu {
  final String title;
  final String emoji;
  Color color;
  Color selectedColor;
  TabMenu({this.title, this.emoji, this.color, this.selectedColor});
}

class ComponentPage extends StatefulWidget {
  final String title;
  final Store store;
  List<TabMenu> menus;
  Color _selectedColor;
  Color _color;

  ComponentPage({Key, key, this.title, this.store})
      : _color = new Color(0xFFDEECF5),
        _selectedColor = new Color(0xFFFFFFFF),
        menus = <TabMenu>[
          new TabMenu(title: '常规信息', emoji: '\u{1F4C4}'),
          new TabMenu(title: 'CPU', emoji: '\u{1F4C8}'),
          new TabMenu(title: '内存', emoji: '\u{1F4CA}'),
          new TabMenu(title: '地址', emoji: '\u{1F4CD}'),
          new TabMenu(title: 'TCP连接数', emoji: '\u{1F517}'),
          new TabMenu(title: '磁盘', emoji: '\u{1F4BE}'),
          new TabMenu(title: '接口', emoji: '\u{1F50C}'),
          new TabMenu(title: '进程', emoji: '\u{23F3}'),
        ],
        super(key: key) {
    for (var m in menus) {
      m.color = _color;
      m.selectedColor = _selectedColor;
    }
  }
  @override
  _ComponentPageState createState() => new _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  TabMenu _selectedMenu;
  Widget _selectedWidget;
  ListView _basicView;
  ListView _cpuView;
  ListView _memoryView;
  ListView _addressView;
  ListView _tcpView;
  ListView _diskView;
  ListView _interfaceView;
  ListView _processView;

  @override
  void initState() {
    _selectedMenu = widget.menus[0];
    _selectedWidget = null;
    super.initState();
    ComponentState _state = widget.store.state.getState(componentkey);
    if (_state.detail == null) {
      fetchComponent(widget.store);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _selectMenu(TabMenu menu) {
    setState(() {
      _selectedMenu = menu;
      switch (menu.title) {
        case "CPU":
          _selectedWidget = _cpuView;
          break;
        case "内存":
          _selectedWidget = _memoryView;
          break;
        case "地址":
          _selectedWidget = _addressView;
          break;
        case "TCP连接数":
          _selectedWidget = _tcpView;
          break;
        case "磁盘":
          _selectedWidget = _diskView;
          break;
        case "接口":
          _selectedWidget = _interfaceView;
          break;
        case "进程":
          _selectedWidget = _processView;
          break;
        case "常规信息":
        default:
          _selectedWidget = _basicView;
      }
    });
  }

  Widget _buildDetailView(ComponentDetail detail, String key) {
    ComponentDetailItem item = detail.detail.firstWhere((x) => x.Dkey == key);
    List<List<Pair<String, String>>> pairgroups =
        <List<Pair<String, String>>>[];
    if (item != null && item.DetailList.length > 0) {
      ComponentDetailItemValue value = item.DetailList[0];
      for (int i = 0, ilen = value.McimValue.length; i < ilen; i++) {
        List<Pair<String, String>> pairs = <Pair<String, String>>[];
        for (int j = 0, jlen = value.TableNameEn.length; j < jlen; j++) {
          pairs.add(new Pair<String, String>(value.TableNameCh[j],
              "${value.McimValue[i][value.TableNameEn[j]] ?? ''}"));
        }
        pairgroups.add(pairs);
      }
    }
    return new ListView(
      children: pairgroups.map((x) {
        return new PairItem(pairs: x);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ComponentState _state = widget.store.state.getState(componentkey);
    ComponentDetail _detail = _state.detail;
    if (_detail != null && _basicView == null) {
      _basicView = new ListView(
        children: [
          new KeyValueItem(title: "管理地址", value: _detail.DControladderss),
          new KeyValueItem(title: "业务名称", value: _detail.DBusinessname),
          new KeyValueItem(title: "类别", value: _detail.deItcatalogName),
          new KeyValueItem(title: "功能", value: _detail.deItfunctionName),
          new KeyValueItem(title: "厂商", value: _detail.deItmanufacturerName),
          new KeyValueItem(title: "产品系列", value: _detail.deItproductseriesName),
        ],
      );
    }
    if (_detail != null && _cpuView == null) {
      _cpuView = _buildDetailView(_detail, "HostProcessor");
    }
    if (_detail != null && _memoryView == null) {
      _memoryView = _buildDetailView(_detail, "HostMemory");
    }
    if (_detail != null && _addressView == null) {
      _addressView = _buildDetailView(_detail, "Address");
    }
    if (_detail != null && _tcpView == null) {
      _tcpView = _buildDetailView(_detail, "HostTcpConnection");
    }
    if (_detail != null && _diskView == null) {
      _diskView = _buildDetailView(_detail, "HostDisk");
    }
    if (_detail != null && _interfaceView == null) {
      _interfaceView = _buildDetailView(_detail, "Interface");
    }
    if (_detail != null && _processView == null) {
      _processView = _buildDetailView(_detail, "HostProcess");
    }
    if (_selectedWidget == null && _basicView != null) {
      _selectedWidget = _basicView;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _detail == null
          ? new CircularProgressIndicator()
          : new Column(
              children: <Widget>[
                new Expanded(
                  child: new GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    padding: const EdgeInsets.all(4.0),
                    childAspectRatio: 1.0,
                    children: widget.menus.map((TabMenu menu) {
                      return new Container(
                        child: new ClipRRect(
                          borderRadius: new BorderRadius.circular(12.0),
                          child: new InkWell(
                            onTap: () {
                              _selectMenu(menu);
                            },
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Text(menu.emoji,
                                    style: new TextStyle(
                                        fontFamily: 'EmojiSymbols',
                                        fontSize: 20.0)),
                                new Text(menu.title),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            color: _selectedMenu.title == menu.title
                                ? menu.selectedColor
                                : menu.color),
                      );
                    }).toList(),
                  ),
                ),
                new Expanded(
                  flex: 2,
                  child: _selectedWidget,
                ),
              ],
            ),
    );
  }
}
