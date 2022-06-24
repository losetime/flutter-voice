import 'package:flutter/material.dart';
import 'dart:async';

class YmTable extends StatefulWidget {
  final List<String> header;
  final List<String> rowKey;
  final List sourceData;
  final double tableHeight;
  final String indicatorPosition;
  const YmTable({
    Key? key,
    required this.header,
    required this.rowKey,
    required this.sourceData,
    required this.tableHeight,
    this.indicatorPosition = 'left',
  }) : super(key: key);
  @override
  State<YmTable> createState() => _YmTable();
}

class _YmTable extends State<YmTable> {
  late ScrollController _scrollController;

  double offset = 0;

  late Timer scrollTimer;

  List<List> twoDimTableData = [];

  int indicator = 0;

  @override
  void initState() {
    formattTableData();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      offset = _scrollController.offset;
    });
    setTableScroll();
    super.initState();
  }

  /*
   * @desc 分割表格数据
   */
  void formattTableData() {
    int len = 7;
    int index = 1;
    while (true) {
      if (index * len < widget.sourceData.length) {
        List temp =
            widget.sourceData.skip((index - 1) * len).take(len).toList();
        twoDimTableData.add(temp);
        index++;
        continue;
      }
      List temp = widget.sourceData.skip((index - 1) * len).toList();
      twoDimTableData.add(temp);
      break;
    }
  }

  /*
   * @desc 渲染表格信息
   */
  Widget renderTable() {
    List<Widget> listHeader = widget.header.map((item) {
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

    var tableWrap = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
            height: widget.tableHeight,
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
            child: renderTableBody()),
      ],
    );

    return tableWrap;
  }

  /*
   * @desc 渲染仓位Table 
   **/
  Widget renderTableBody() {
    // 列表行
    List<Widget> listViewWrap = twoDimTableData[indicator].map((item) {
      return Container(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 61, 143, 1),
          ),
          child: Row(
            children: renderField(item),
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
  List<Widget> renderField(Map sourceMap) {
    return widget.rowKey.map((item) {
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

  /*
   * @desc 渲染分页器
   */
  Widget renderPagination() {
    List<Widget> paginationList = [];
    for (int i = 0; i < twoDimTableData.length; i++) {
      Widget paginationItem = Container(
        width: 25,
        height: 25,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(0, 60, 141, 1),
          ),
          color: indicator == i ? const Color.fromRGBO(0, 61, 143, 1) : null,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(
          child: Text(
            (i + 1).toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      paginationList.add(paginationItem);
    }
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: widget.indicatorPosition == 'left'
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: paginationList,
      ),
    );
  }

  /*
   * @desc 设置列表滚动 
   */
  void setTableScroll() {
    scrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (indicator + 1 >= twoDimTableData.length) {
        setState(() {
          indicator = 0;
        });
      } else {
        setState(() {
          indicator += 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          renderTable(),
          renderPagination(),
        ],
      ),
    );
  }
}
