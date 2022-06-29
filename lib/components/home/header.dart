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
    const weekday = [" ", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];
    dateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime currentDate = DateTime.now();
      setState(() {
        nowTime = '${formatDate(currentDate, [
              yyyy,
              '-',
              mm,
              '-',
              dd
            ])}  ${weekday[currentDate.weekday]}  ${formatDate(currentDate, [
              HH,
              ':',
              nn,
              ':',
              ss
            ])}';
        // +
        //     weekday[currentDate.weekday] +
        //     formatDate(currentDate, [HH, ':', nn, ':', ss]);
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              top: 8,
            ),
            child: Text(
              nowTime,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 20,
              top: 8,
            ),
            child: const RealTimeWeather(),
          ),
        ],
      ),
    );
  }
}
