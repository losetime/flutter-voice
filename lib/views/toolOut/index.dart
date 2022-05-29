import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/globalProvider.dart';

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
    'content',
    'content',
    'content',
    'content',
    'msgTime',
    'content',
  ];
  List sourceData = [
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

  @override
  void initState() {
    super.initState();
  }

  /*
   * @desc 处理从websockt获取的表格数据 
   **/
  void formatTableData() {
    switch (provider.socketInfo['type']) {
      case 'toolLog':
        var temp = [...sourceData];
        // 如果大于10条则删除最后一条
        if (temp.length > 10) {
          temp.removeAt(temp.length - 1);
        }
        // 向首部插入
        temp.insert(0, provider.socketInfo);
        setState(() {
          sourceData = temp;
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
            Container(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: Row(
                children: const [
                  Text(
                    '工器具出库',
                    style: TextStyle(
                      color: Color.fromRGBO(18, 155, 255, 1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                    ),
                    child: Text(
                      '(姓名：常逢灏)',
                      style: TextStyle(
                        color: Color.fromRGBO(18, 155, 255, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: renderTable(),
            ),
          ],
        ),
      ),
    );
  }
}
