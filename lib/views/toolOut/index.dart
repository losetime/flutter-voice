import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/globalProvider.dart';
import '../../components/home/header.dart';

class ToolOut extends StatefulWidget {
  const ToolOut({Key? key}) : super(key: key);
  @override
  State<ToolOut> createState() => _ToolOut();
}

class _ToolOut extends State<ToolOut> with SingleTickerProviderStateMixin {
  late HomeProvider provider;

  List<String> tableHeader = <String>[
    '名称',
    '器具编号',
    '类别',
    '标签',
    '型号',
    '仓位',
  ];
  List<String> rowKey = [
    'toolName',
    'bidNo',
    'toolTypeName',
    'toolTagName',
    'id',
    'expectPosition',
  ];

  List sourceData = [];

  @override
  void initState() {
    super.initState();
  }

  /*
   * @desc 初始化Provider 
   */
  void initProvider(context) {
    provider = Provider.of<HomeProvider>(context);
    provider.addListener(() {
      setState(() {
        sourceData = provider.socketInfo['toolRecList'];
      });
    });
  }

  /*
   * @desc 渲染人员信息
   */
  Widget renderPersonInfo() {
    var personInfoWrap = Container(
      width: 325,
      height: 354,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
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
                margin: EdgeInsets.only(left: 6),
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              '姓名：常逢灏',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const Image(
            image: AssetImage('assets/images/avatar.png'),
            width: 158,
            height: 202,
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
    Widget returnedWrap = Container(
      width: 325,
      height: 190,
      padding: const EdgeInsets.all(20),
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
                      '领用总数',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      '14',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      '本次归还',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      '剩余数量',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      '12',
                      style: TextStyle(
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
  Widget renderCardInfo() {
    Widget cardInfoWrap = Container(
      // width: 466,
      // height: 269,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/daiguihuan.png'),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 2,
                  color: Color.fromRGBO(18, 155, 255, 1),
                ),
              ),
            ),
            child: Text(
              '工器具名称：扳手',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 2,
                  color: Color.fromRGBO(18, 155, 255, 1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '器具编号：xxxxx',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 193, 255, 1),
                    fontSize: 18,
                  ),
                ),
                Text(
                  '放至',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 193, 255, 1),
                    fontSize: 20,
                  ),
                ),
                Text(
                  '仓位2',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 193, 255, 1),
                    fontSize: 30,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 2,
                  color: Color.fromRGBO(18, 155, 255, 1),
                ),
              ),
            ),
            child: Text(
              '归还情况：待归还',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
    return cardInfoWrap;
  }

  /*
   * @desc 渲染仓位Table 
   **/
  Widget renderTable() {
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
    initProvider(context);
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: const BoxDecoration(
          color: Color(0xFF040404),
        ),
        child: Column(
          children: [
            const HeaderWrap(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [renderPersonInfo(), renderReturned()],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Expanded(
                          //   child: renderCardInfo(),
                          // ),
                          // Expanded(
                          //   child: renderCardInfo(),
                          // ),
                          renderCardInfo(),
                          renderCardInfo(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
            // Container(
            //   padding: const EdgeInsets.only(
            //     top: 30,
            //   ),
            //   child: Row(
            //     children: const [
            //       Text(
            //         '工器具出库',
            //         style: TextStyle(
            //           color: Color.fromRGBO(18, 155, 255, 1),
            //         ),
            //       ),
            //       Padding(
            //         padding: EdgeInsets.only(
            //           left: 30,
            //         ),
            //         child: Text(
            //           '(姓名：常逢灏)',
            //           style: TextStyle(
            //             color: Color.fromRGBO(18, 155, 255, 1),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     top: 10,
            //   ),
            //   child: renderTable(),
            // ),
          ],
        ),
      ),
    );
  }
}
