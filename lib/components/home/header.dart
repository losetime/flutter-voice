import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'dart:async';
import '../../components/common/weather.dart';
import 'package:provider/provider.dart';
import '../../provider/globalProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/app_cache.dart';

class HeaderWrap extends StatefulWidget {
  const HeaderWrap({Key? key}) : super(key: key);
  @override
  State<HeaderWrap> createState() => _HeaderWrap();
}

class _HeaderWrap extends State<HeaderWrap>
    with SingleTickerProviderStateMixin {
  late DomainProvider provider;

  String nowTime = '';

  String domainHost = '';

  late Timer dateTimer;

  late TextEditingController _textFieldController;

  @override
  void initState() {
    super.initState();
    getNowTime();
    _textFieldController = TextEditingController();
    _textFieldController.value = _textFieldController.value.copyWith(
        text: 'ws://192.168.35.159:32244/person/websocket/toolScreen');
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (AppCache.host!.isNotEmpty) {
        provider.setDomainHost(AppCache.host as String);
      }
    });
  }

  @override
  void dispose() {
    dateTimer.cancel();
    super.dispose();
  }

  /*
   * @desc 初始化Provider 
   */
  void initProvider(context) {
    provider = Provider.of<DomainProvider>(context, listen: false);
  }

  /*
   * @desc 设置当前时间
   */
  void getNowTime() {
    dateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        nowTime = formatDate(DateTime.now(),
            [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
      });
    });
  }

  /*
   * @desc 设置域名
   */
  void setDomain() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('连接地址'),
          content: TextField(
            controller: _textFieldController,
            autofocus: true, // 输入完成回调
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(0),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (_textFieldController.text.isEmpty) {
                  Fluttertoast.showToast(msg: '域名地址不能为空');
                } else {
                  provider.setDomainHost(_textFieldController.text);
                  AppCache.setHost(_textFieldController.text);
                  Navigator.of(context).pop(0);
                }
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initProvider(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      // alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/header-bg.png'),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              nowTime,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              '智慧仓储大屏',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(18, 155, 255, 1),
                fontSize: 30,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: RealTimeWeather(),
          ),
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(
              right: 10,
              top: 20,
            ),
            child: FloatingActionButton(
              focusColor: const Color.fromRGBO(18, 155, 255, 1),
              backgroundColor: const Color.fromRGBO(4, 4, 4, 1),
              onPressed: setDomain,
              tooltip: 'Increment',
              child: const Icon(
                Icons.settings,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
