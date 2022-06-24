import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../provider/globalProvider.dart';
import '../../enums/homeEnum.dart'
    show freightSpaceHeader, freightSpaceRowKey, toolHeader, toolRowKey;
import '../../components/home/header.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);
  @override
  State<HomeIndex> createState() => _HomeIndex();
}

class _HomeIndex extends State<HomeIndex> with SingleTickerProviderStateMixin {
  late HomeProvider provider;
  List toolLogList = [];

  List storeLogList = [];

  Map overviewData = {
    'receiveNum': '',
    'returnNum': '',
    'storeNum': '',
    'toolNum': '',
    'toolTypeNum': ''
  };

  late TabController _tabController;

  late ScrollController _scrollController;

  int tabIndex = 0;

  late Timer switchTimer;

  late Timer scrollTimer;

  late double listViewHeight;

  double offset = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    _tabController.addListener(() {
      //点击tab回调一次，滑动切换tab不会回调
      if (_tabController.indexIsChanging) {
        setState(() {
          tabIndex = _tabController.index;
          offset = 0;
        });
      }
    });
    _scrollController.addListener(() {
      offset = _scrollController.offset;
    });
    setTimingSwitchTab();
    setListViewJump();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    switchTimer.cancel();
    scrollTimer.cancel();
    super.dispose();
  }

  /*
   * @desc 初始化Provider 
   */
  void initProvider(context) {
    listViewHeight = MediaQuery.of(context).size.height - 162 - 35 - 40 - 30;
    provider = Provider.of<HomeProvider>(context);
    provider.addListener(() {
      setState(() {
        storeLogList = provider.socketInfo['storeList'];
        toolLogList = provider.socketInfo['toolIncorrectList'];
        overviewData = provider.socketInfo['toolSum'];
      });
    });
  }

  /*
   * @desc 设置定时切换Tab
   **/
  void setTimingSwitchTab() {
    switchTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (tabIndex == 0) {
        setState(() {
          tabIndex = 1;
          _tabController.index = 1;
        });
      } else {
        setState(() {
          tabIndex = 0;
          _tabController.index = 0;
        });
      }
    });
  }

  /*
   * @desc 设置列表滚动 
   */
  void setListViewJump() {
    scrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      List sourceData = tabIndex == 0 ? storeLogList : toolLogList;
      if (sourceData.length * 40 - offset > listViewHeight) {
        offset += 40;
      } else {
        offset = 0;
      }
      _scrollController.animateTo((offset),
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    });
  }

  /*
   * @desc 渲染统计部分
   **/
  Widget renderOverview() {
    var overviewWrap = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '工器具信息',
                style: TextStyle(
                  color: Color.fromRGBO(40, 219, 254, 1),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                margin: const EdgeInsets.only(
                  top: 5.0,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 92, 173, 1),
                      Color.fromRGBO(0, 57, 138, 1),
                    ],
                  ),
                  border: Border.all(
                    color: const Color.fromRGBO(7, 187, 237, 1),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '工器具类型',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            overviewData['toolTypeNum'],
                            style: const TextStyle(
                              color: Color.fromRGBO(61, 255, 247, 1),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '工器具总数量',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            overviewData['toolNum'],
                            style: const TextStyle(
                              color: Color.fromRGBO(251, 213, 68, 1),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '总仓位',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            overviewData['storeNum'],
                            style: const TextStyle(
                              color: Color.fromRGBO(68, 244, 126, 1),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
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
        const SizedBox(
          width: 100,
          height: 50,
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '今日领还',
                style: TextStyle(
                  color: Color.fromRGBO(40, 219, 254, 1),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                margin: const EdgeInsets.only(
                  top: 5.0,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 92, 173, 1),
                      Color.fromRGBO(0, 57, 138, 1),
                    ],
                  ),
                  border: Border.all(
                    color: const Color.fromRGBO(7, 187, 237, 1),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '领取数量',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            overviewData['receiveNum'],
                            style: const TextStyle(
                              color: Color.fromRGBO(40, 213, 253, 1),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '归还数量',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            overviewData['returnNum'],
                            style: const TextStyle(
                              color: Color.fromRGBO(68, 244, 126, 1),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
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
    List<String> header = tabIndex == 0 ? freightSpaceHeader : toolHeader;
    List<String> rowKey = tabIndex == 0 ? freightSpaceRowKey : toolRowKey;
    List sourceData = tabIndex == 0 ? storeLogList : toolLogList;

    List<Widget> listHeader = header.map((item) {
      return Expanded(
        child: Text(
          item,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }).toList();

    var tabsWrap = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 220,
          height: 35,
          child: TabBar(
            controller: _tabController,
            indicator: const BoxDecoration(
              gradient: LinearGradient(
                //渐变位置
                begin: Alignment.topCenter, //右上
                end: Alignment.bottomCenter, //左下
                stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                //渐变颜色[始点颜色, 结束颜色]
                colors: [
                  Color.fromRGBO(18, 155, 255, 0.4),
                  Color.fromRGBO(18, 155, 255, 1),
                ],
              ),
              border: Border(
                top: BorderSide(
                  color: Color.fromRGBO(18, 155, 255, 1),
                ),
                left: BorderSide(
                  color: Color.fromRGBO(18, 155, 255, 1),
                ),
                right: BorderSide(
                  color: Color.fromRGBO(18, 155, 255, 1),
                ),
              ),
            ),
            tabs: const [
              Tab(
                child: Text(
                  '仓位状态',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  '异常工器具',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        // 表头
        Container(
          // height: 40,
          padding: const EdgeInsets.all(1.0),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Color.fromRGBO(28, 113, 220, 1),
              ),
              right: BorderSide(
                color: Color.fromRGBO(28, 113, 220, 1),
              ),
              top: BorderSide(
                color: Color.fromRGBO(28, 113, 220, 1),
              ),
            ),
          ),
          child: Container(
            height: 36,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 129, 241, 1),
            ),
            child: Row(
              children: listHeader,
            ),
          ),
        ),
        Container(
            height: listViewHeight,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Color.fromRGBO(28, 113, 220, 1),
                ),
                right: BorderSide(
                  color: Color.fromRGBO(28, 113, 220, 1),
                ),
                bottom: BorderSide(
                  color: Color.fromRGBO(28, 113, 220, 1),
                ),
              ),
            ),
            child: renderTableBody(header, rowKey, sourceData)),
      ],
    );

    return tabsWrap;
  }

  /*
   * @desc 渲染仓位Table 
   **/
  Widget renderTableBody(
      List<String> tableHeader, List<String> rowKey, List sourceData) {
    // 列表行
    List<Widget> listViewWrap = sourceData.map((item) {
      return Container(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 61, 143, 1),
          ),
          child: Row(
            children: renderField(rowKey, item),
          ),
        ),
        // children: ,
      );
    }).toList();
    // 生成表格
    ListView tableWrap = ListView.builder(
      itemCount: listViewWrap.length,
      itemExtent: 40,
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        return listViewWrap[index];
      },
    );

    return tableWrap;
  }

  /*
   * @desc 渲染表格字段
   **/
  List<Widget> renderField(List<String> keyList, Map sourceMap) {
    return keyList.map((item) {
      switch (item) {
        case 'status':
          return Expanded(
            child: Text(
              sourceMap[item] == '0' ? '异常' : '正常',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        case 'toolIncorrectSum':
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                sourceMap[item] == '0'
                    ? const Text(
                        '正常',
                        style: TextStyle(
                          color: Color.fromRGBO(68, 244, 126, 1),
                        ),
                      )
                    : Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Color.fromRGBO(255, 148, 0, 1), size: 12),
                          const Text(
                            '放置错误',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 148, 0, 1),
                            ),
                          ),
                          Text(
                            '(${sourceMap[item]})',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );
        // 当前仓位
        case 'currentPosition':
          return Expanded(
            child: Text(
              sourceMap[item],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(255, 153, 0, 1),
              ),
            ),
          );
        // 正确仓位
        case 'expectPosition':
          return Expanded(
            child: Text(
              sourceMap[item],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(255, 153, 0, 1),
              ),
            ),
          );
        default:
          return Expanded(
            child: Text(
              sourceMap[item],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    initProvider(context);
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 16, 76, 1),
      ),
      child: Column(
        children: [
          const HeaderWrap(),
          Padding(
            padding: const EdgeInsets.only(
              // top: 10,
              bottom: 10,
              left: 50,
              right: 50,
            ),
            child: renderOverview(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: renderTabs(),
          ),
        ],
      ),
    );
  }
}
