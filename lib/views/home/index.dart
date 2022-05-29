import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import '../../provider/globalProvider.dart';
import '../../enums/homeEnum.dart'
    show freightSpaceHeader, freightSpaceRowKey, toolHeader, toolRowKey;

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);
  @override
  State<HomeIndex> createState() => _HomeIndex();
}

class _HomeIndex extends State<HomeIndex> with SingleTickerProviderStateMixin {
  late HomeProvider provider;
  List toolLogList = [
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'}
  ];

  List freightSpaceLogList = [
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'},
    {'msgTime': '2021-12-11', 'content': '放置错误'}
  ];

  late TabController _tabController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      //点击tab回调一次，滑动切换tab不会回调
      if (_tabController.indexIsChanging) {
        setState(() {
          tabIndex = _tabController.index;
        });
      }
    });
    getHttp();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /*
  * Base64解密
  */
  static String base64Decode(String data) {
    List<int> bytes = convert.base64Decode(data);
    // 网上找的很多都是String.fromCharCodes，这个中文会乱码
    //String txt1 = String.fromCharCodes(bytes);
    String result = convert.utf8.decode(bytes);
    return result;
  }

  void getHttp() async {
    try {
      var response = await Dio().get(
          'http://tts.youdao.com/fanyivoice?word=你好，我是你好&le=zh&keyfrom=speaker-target');
      print('response, ${response}');
    } catch (e) {
      print(e);
    }
  }

  /*
   * @desc 处理从websockt获取的表格数据 
   **/
  void formatTableData() {
    switch (provider.socketInfo['type']) {
      case 'toolLog':
        var temp = [...toolLogList];
        // 如果大于10条则删除最后一条
        if (temp.length > 10) {
          temp.removeAt(temp.length - 1);
        }
        // 向首部插入
        temp.insert(0, provider.socketInfo);
        setState(() {
          toolLogList = temp;
          tabIndex = 1;
          _tabController.index = 1;
        });
        break;
    }
  }

  /*
   * @desc 渲染Header
   **/
  Widget renderHeader() {
    var headerWrap = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text(
          '2021-12-28 10:43:37',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Container(
          width: 400,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/header-title-bg.png'),
            ),
          ),
          child: const Text(
            '智慧仓储大屏',
            style: TextStyle(
              color: Color.fromRGBO(18, 155, 255, 1),
              fontSize: 44,
            ),
          ),
        ),
        const Text(
          '多云 12℃',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
    return headerWrap;
  }

  /*
   * @desc 渲染统计部分
   **/
  Widget renderOverview() {
    var overviewWrap = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(
                  color: Color.fromRGBO(18, 155, 255, 1),
                  width: 2,
                ))),
                child: const Text(
                  '工器具信息',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '工器具类型',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '999',
                            style: TextStyle(
                              color: Color.fromRGBO(18, 155, 255, 1),
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '工器具总数量',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '999',
                            style: TextStyle(
                              color: Color.fromRGBO(18, 155, 255, 1),
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '总仓位',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '999',
                            style: TextStyle(
                              color: Color.fromRGBO(18, 155, 255, 1),
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(
                  color: Color.fromRGBO(18, 155, 255, 1),
                  width: 2,
                ))),
                child: const Text(
                  '今日领还',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '领取数量',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '999',
                            style: TextStyle(
                              color: Color.fromRGBO(18, 155, 255, 1),
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '归还数量',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '999',
                            style: TextStyle(
                              color: Color.fromRGBO(18, 155, 255, 1),
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    return overviewWrap;
  }

  /*
   * @desc 渲染Tabs 
   **/
  Widget renderTabs() {
    var tabsWrap = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 220,
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(18, 155, 255, 1),
              ),
            ),
            tabs: const [
              Tab(
                child: Text(
                  '仓位状态',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  '异常工器具',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        tabIndex == 0
            ? renderTable(
                freightSpaceHeader, freightSpaceRowKey, freightSpaceLogList)
            : renderTable(toolHeader, toolRowKey, toolLogList)
      ],
    );

    return tabsWrap;
  }

  /*
   * @desc 渲染仓位Table 
   **/
  Widget renderTable(
      List<String> tableHeader, List<String> rowKey, List sourceData) {
    // 列表行
    List<TableRow> tableRowList = sourceData.map((item) {
      return TableRow(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(18, 155, 255, 1),
            ),
          ),
        ),
        children: renderField(rowKey, item),
        // renderField(rowKey, item)
      );
    }).toList();
    // 生成表格
    Table tableWrap = Table(
      border: const TableBorder(
        top: BorderSide(
          color: Color.fromRGBO(18, 155, 255, 1),
          width: 1,
          style: BorderStyle.solid,
        ),
        left: BorderSide(
          color: Color.fromRGBO(18, 155, 255, 1),
          width: 1,
          style: BorderStyle.solid,
        ),
        right: BorderSide(
          color: Color.fromRGBO(18, 155, 255, 1),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(14, 43, 69, 1),
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(18, 155, 255, 1),
              ),
            ),
          ),
          children: tableHeader.map((item) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
        ...tableRowList,
      ],
    );

    return tableWrap;
  }

  /*
   * @desc 渲染表格字段
   **/
  List<Widget> renderField(List<String> keyList, Map sourceMap) {
    return keyList.map((item) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Text(
          sourceMap[item],
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeProvider>(context);
    provider.addListener(() {
      formatTableData();
    });
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        decoration: const BoxDecoration(
          color: Color(0xFF040404),
        ),
        child: Column(
          children: [
            renderHeader(),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 20,
              ),
              child: renderOverview(),
            ),
            renderTabs(),
          ],
        ),
      ),
    );
  }
}
