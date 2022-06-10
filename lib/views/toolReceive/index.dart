import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/globalProvider.dart';
import '../../components/home/header.dart';

class ToolReceive extends StatefulWidget {
  const ToolReceive({Key? key}) : super(key: key);
  @override
  State<ToolReceive> createState() => _ToolReceive();
}

class _ToolReceive extends State<ToolReceive>
    with SingleTickerProviderStateMixin {
  late HomeProvider provider;

  Map personInfo = {};

  Map toolStats = {};

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
   * @desc 领用情况
   */
  Widget renderReturned() {
    String receiveNum = toolStats.isNotEmpty ? toolStats['receiveNum'] : '';
    Widget returnedWrap = Container(
      width: 250,
      height: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(11, 40, 66, 1),
        borderRadius: BorderRadius.circular(10.0), //3像素圆角
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '本次领用情况',
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
            child: Row(
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
                        color: Color.fromRGBO(18, 155, 255, 1),
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '领用完成',
                  style: TextStyle(
                    color: Color.fromRGBO(26, 155, 39, 1),
                    fontSize: 30,
                  ),
                ),
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
    List<Widget> cardInfoList = sourceData.map((item) {
      print('model: ${item['model']}');
      String imgPath = 'assets/images/daiguihuan.png';
      Color statusColor = const Color.fromRGBO(18, 155, 255, 1);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
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
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
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
                      '器具编号：${item['codeNumber']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
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
                      '类别：${item['toolTypeName']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
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
                      '标签：${item['toolTagName']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
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
                      '型号：${item['model']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
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
                      '仓位：${item['expectPosition']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
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

  @override
  Widget build(BuildContext context) {
    initProvider(context);
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF040404),
        ),
        child: Column(
          children: [
            const HeaderWrap(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [renderPersonInfo(), renderReturned()],
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: GridView.count(
                        //水平子Widget之间间距
                        crossAxisSpacing: 10.0,
                        //垂直子Widget之间间距
                        // mainAxisSpacing: 20.0,
                        //GridView内边距
                        // padding: EdgeInsets.all(10.0),
                        //一行的Widget数量
                        crossAxisCount: 2,
                        //子Widget宽高比例
                        childAspectRatio: 1.6,
                        shrinkWrap: true,
                        //子Widget列表
                        children: renderCardInfo(),
                      ),
                    ),
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
