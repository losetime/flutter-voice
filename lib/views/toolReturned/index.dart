import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/globalProvider.dart';
import '../../components/home/header.dart';
import '../../enums/homeEnum.dart'
    show
        toolReturnedHistoryHeader,
        toolReturnedHistoryKey,
        toolReturnedRealTimeHeader,
        toolReturnedRealTimeKey,
        testTableData;
import '../../components/common/YmTable.dart';

class ToolReturned extends StatefulWidget {
  const ToolReturned({Key? key}) : super(key: key);
  @override
  State<ToolReturned> createState() => _ToolReturned();
}

class _ToolReturned extends State<ToolReturned>
    with SingleTickerProviderStateMixin {
  late HomeProvider provider;

  Map personInfo = {};

  Map toolStats = {};

  List tableData = [];

  late double listViewHeight;

  int historyIndicator = 0;

  @override
  void initState() {
    super.initState();
  }

  /*
   * @desc 初始化Provider 
   */
  void initProvider(context) {
    listViewHeight = MediaQuery.of(context).size.height - 162 - 35 - 40 - 30;
    provider = Provider.of<HomeProvider>(context);
    provider.addListener(() {
      setState(() {
        tableData = provider.socketInfo['toolRetList'];
        personInfo = provider.socketInfo.containsKey('peopleInfo')
            ? provider.socketInfo['peopleInfo']
            : {};
        toolStats = provider.socketInfo.containsKey('toolSingleSumPO')
            ? provider.socketInfo['toolSingleSumPO']
            : {};
      });
    });
  }

  /*
   * @desc 渲染人员信息
   */
  Widget renderPersonInfo() {
    var photoUrl =
        personInfo.containsKey('photoUrl') ? personInfo['photoUrl'] : '';
    var userName =
        personInfo.containsKey('userName') ? personInfo['userName'] : '';
    var personInfoWrap = Container(
      width: 250,
      height: 290,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(11, 40, 66, 1),
        borderRadius: BorderRadius.circular(10.0), //3像素圆角
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '人员信息',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 6),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                  ),
                ),
                child: const Text(
                  'OVERVIEW',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    fontSize: 10,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              '姓名：$userName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          photoUrl == ''
              ? Image.asset(
                  'assets/images/avatar.png',
                  width: 150,
                  height: 180,
                )
              : Image.network(
                  photoUrl,
                  width: 150,
                  height: 180,
                )
        ],
      ),
    );
    return personInfoWrap;
  }

  /*
   * @desc 归还情况
   */
  Widget renderReturned() {
    String receiveNum = toolStats.isNotEmpty ? toolStats['receiveNum'] : '';
    String returnNum = toolStats.isNotEmpty ? toolStats['returnNum'] : '';
    String restNum = toolStats.isNotEmpty ? toolStats['restNum'] : '';
    Widget returnedWrap = Container(
      width: 250,
      height: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(11, 40, 66, 1),
        borderRadius: BorderRadius.circular(10.0), //3像素圆角
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '归还情况',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                      ),
                    ),
                  ),
                  child: const Text(
                    'OVERVIEW',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      '领用总数 ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      receiveNum,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      '本次归还 ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      returnNum,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      '剩余数量 ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      restNum,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
    return returnedWrap;
  }

  /*
   * @desc 渲染卡片信息
   */
  List<Widget> renderCardInfo() {
    List<Widget> cardInfoList = tableData.map((item) {
      String imgPath = 'assets/images/daiguihuan.png';
      String statusLabel = '';
      Color statusColor = const Color.fromRGBO(18, 155, 255, 1);
      if (item.isNotEmpty) {
        switch (item['status']) {
          case '8': // 待归还
            imgPath = 'assets/images/daiguihuan.png';
            statusLabel = '待归还';
            statusColor = const Color.fromRGBO(18, 155, 255, 1);
            break;
          case '7': // 归还错误
            imgPath = 'assets/images/guihuancuowu.png';
            statusLabel = '归还错误';
            statusColor = const Color.fromRGBO(204, 34, 34, 1);
            break;
          case '0': // 归还完成
            imgPath = 'assets/images/guihuanwancheng.png';
            statusLabel = '归还完成';
            statusColor = const Color.fromRGBO(45, 201, 97, 1);
            break;
        }
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(imgPath),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 2,
                    color: statusColor,
                  ),
                ),
              ),
              child: Text(
                '工器具名称：${item['toolName']}',
                style: const TextStyle(
                  color: Colors.white,
                  // fontSize: 32,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 2,
                    color: statusColor,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '器具编号：${item['codeNumber']}',
                    style: const TextStyle(
                      color: Colors.white,
                      // fontSize: 18,
                    ),
                  ),
                  Text(
                    '放至',
                    style: TextStyle(
                      color: statusColor,
                      // fontSize: 20,
                    ),
                  ),
                  Text(
                    '${item['expectPosition']}',
                    style: TextStyle(
                      color: statusColor,
                      // fontSize: 30,
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 2,
                        color: statusColor,
                      ),
                    ),
                  ),
                  child: Text(
                    '归还情况：$statusLabel',
                    style: const TextStyle(
                      color: Colors.white,
                      // fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 2,
                        color: statusColor,
                      ),
                    ),
                  ),
                  child: Text(
                    '当前仓位：${item['currentPosition']}',
                    style: TextStyle(
                      color: statusColor,
                      // fontSize: 18,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }).toList();

    return cardInfoList;
  }

  /*
   * @desc 渲染表格信息
   */
  Widget renderTable(
      List<String> header, List<String> rowKey, List sourceData) {
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

    return tableWrap;
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
      // controller: _scrollController,
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

  Widget renderPagination(int indicator) {
    int pageSize = 10;
    List<Widget> paginationList = [];
    for (int i = 0; i < pageSize; i++) {
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
        children: paginationList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initProvider(context);
    return SingleChildScrollView(
      child: Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                    child: const Text(
                      '张伟涛请归还设备',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      YmTable(
                        header: toolReturnedHistoryHeader,
                        rowKey: toolReturnedHistoryKey,
                        sourceData: testTableData,
                        tableHeight: listViewHeight,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      YmTable(
                        header: toolReturnedRealTimeHeader,
                        rowKey: toolReturnedRealTimeKey,
                        sourceData: testTableData,
                        tableHeight: listViewHeight,
                        indicatorPosition: 'right',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
