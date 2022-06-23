import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'dart:async';
import '../../components/common/weather.dart';

class HeaderWrap extends StatefulWidget {
  const HeaderWrap({Key? key}) : super(key: key);
  @override
  State<HeaderWrap> createState() => _HeaderWrap();
}

class _HeaderWrap extends State<HeaderWrap>
    with SingleTickerProviderStateMixin {
  String nowTime = '';

  late Timer dateTimer;

  @override
  void initState() {
    super.initState();
    getNowTime();
  }

  @override
  void dispose() {
    dateTimer.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}
