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
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '工器具类型',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            overviewData['toolTypeNum'],
                            style: const TextStyle(
                              color: Color.fromRGBO(18, 155, 255, 1),
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '工器具总数量',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            overviewData['toolNum'],
                            style: const TextStyle(
                              color: Color.fromRGBO(18, 155, 255, 1),
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '总仓位',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            overviewData['storeNum'],
                            style: const TextStyle(
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
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '领取数量',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            overviewData['receiveNum'],
                            style: const TextStyle(
                              color: Color.fromRGBO(18, 155, 255, 1),
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '归还数量',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            overviewData['returnNum'],
                            style: const TextStyle(
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
          height: 40,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(14, 43, 69, 1),
            border: Border(
              left: BorderSide(
                color: Color.fromRGBO(18, 155, 255, 1),
              ),
              right: BorderSide(
                color: Color.fromRGBO(18, 155, 255, 1),
              ),
              top: BorderSide(
                color: Color.fromRGBO(18, 155, 255, 1),
              ),
            ),
          ),
          child: Row(
            children: listHeader,
          ),
        ),
        Container(
            height: listViewHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(18, 155, 255, 1),
              ),
            ),
            child: renderTable(header, rowKey, sourceData)),
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
    List<Widget> listViewWrap = sourceData.map((item) {
      return Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(18, 155, 255, 1),
            ),
          ),
        ),
        child: Row(
          children: renderField(rowKey, item),
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
      return Expanded(
        child: Text(
          sourceMap[item],
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
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
        color: Color(0xFF040404),
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage('assets/images/footer.png'),
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const HeaderWrap(),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
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
