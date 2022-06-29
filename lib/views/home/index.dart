import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../provider/globalProvider.dart';
import '../../enums/homeEnum.dart'
    show freightSpaceHeader, freightSpaceRowKey, toolHeader, toolRowKey;
import '../../components/home/header.dart';
import '../../components/common/YmTable.dart';
import '../../utils/base.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);
  @override
  State<HomeIndex> createState() => _HomeIndex();
}

class _HomeIndex extends State<HomeIndex> with SingleTickerProviderStateMixin {
  late HomeProvider provider;

  late BaseUtils baseUtils;

  List<List> toolLogList = [];

  List<List> storeLogList = [];

  Map overviewData = {
    'receiveNum': '',
    'returnNum': '',
    'storeNum': '',
    'toolNum': '',
    'toolTypeNum': ''
  };

  late TabController _tabController;

  int tabIndex = 0;

  late Timer switchTabsTimer;

  late Timer switchTableTimer;

  late double listViewHeight;

  int indicatorOne = 0;

  int indicatorTwo = 0;

  @override
  void initState() {
    super.initState();
    baseUtils = BaseUtils();
    Future.microtask(() => initProvider());
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      //点击tab回调一次，滑动切换tab不会回调
      if (_tabController.indexIsChanging) {
        setState(() {
          tabIndex = _tabController.index;
        });
      }
    });
    setTimingSwitchTab();
    changeIndicator();
  }

  @override
  void dispose() {
    _tabController.dispose();
    switchTabsTimer.cancel();
    switchTableTimer.cancel();
    super.dispose();
  }

  /*
   * @desc 初始化Provider 
   */
  void initProvider() {
    provider = Provider.of<HomeProvider>(context, listen: false);
    provider.addListener(() {
      setState(() {
        storeLogList = baseUtils.formattTableData(
            provider.socketInfo['storeList'], listViewHeight);
        toolLogList = baseUtils.formattTableData(
            provider.socketInfo['toolIncorrectList'], listViewHeight);
        overviewData = provider.socketInfo['toolSum'];
      });
    });
  }

  /*
   * @desc 修改指示器
   */
  void changeIndicator() {
    switchTableTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      switch (tabIndex) {
        case 0:
          if (indicatorOne + 1 >= storeLogList.length) {
            setState(() {
              indicatorOne = 0;
            });
          } else {
            setState(() {
              indicatorOne += 1;
            });
          }
          break;
        case 1:
          if (indicatorTwo + 1 >= toolLogList.length) {
            setState(() {
              indicatorTwo = 0;
            });
          } else {
            setState(() {
              indicatorTwo += 1;
            });
          }
          break;
      }
    });
  }

  /*
   * @desc 设置定时切换Tab
   **/
  void setTimingSwitchTab() {
    switchTabsTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (tabIndex == 0 && toolLogList[0].isNotEmpty) {
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
    var tabsWrap = SizedBox(
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
    );
    return tabsWrap;
  }

  @override
  Widget build(BuildContext context) {
    listViewHeight = MediaQuery.of(context).size.height - 162 - 35 - 40 - 60;
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 16, 76, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: tabIndex == 0
                ? YmTable(
                    header: freightSpaceHeader,
                    rowKey: freightSpaceRowKey,
                    sourceData: storeLogList,
                    tableHeight: listViewHeight,
                    indicator: indicatorOne,
                  )
                : YmTable(
                    header: toolHeader,
                    rowKey: toolRowKey,
                    sourceData: toolLogList,
                    tableHeight: listViewHeight,
                    indicator: indicatorTwo,
                  ),
          ),
        ],
      ),
    );
  }
}
