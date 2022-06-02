import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../enums/commonEnum.dart' show appId, appSecret;

class RealTimeWeather extends StatefulWidget {
  const RealTimeWeather({Key? key}) : super(key: key);
  @override
  State<RealTimeWeather> createState() => _RealTimeWeather();
}

class _RealTimeWeather extends State<RealTimeWeather>
    with SingleTickerProviderStateMixin {
  String weatherStatus = '';
  String temperature = '';
  int weatherImg = 0xe615;

  @override
  void initState() {
    initWeather();
    super.initState();
  }

  /*
   * @desc 
   */
  initWeather() async {
    try {
      Response response = await Dio().get(
          'https://www.yiketianqi.com/free/day?appid=${appId}&appsecret=${appSecret}&unescape=1');
      var result = response.data;
      setState(() {
        weatherStatus = result['wea'];
        temperature = result['tem'] + '℃';
        weatherImg = handleWeatherImg(result['wea_img']);
      });
    } catch (e) {
      print(e);
    }
  }

  /*
   * @desc 处理天气图标
   */
  handleWeatherImg(weaStatus) {
    switch (weaStatus) {
      case 'yun':
        return 0xe617;
      case 'qing':
        return 0xe615;
      case 'yin':
        return 0xe61d;
      case 'yu':
        return 0xe61a;
      case 'xue':
        return 0xe61b;
      case 'lei':
        return 0xe61e;
      case 'shachen':
        return 0xe61f;
      case 'wu':
        return 0xe620;
      case 'bingbao':
        return 0xe622;
      default:
        return 0xe615;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          IconData(weatherImg,
              fontFamily: 'iconfont', matchTextDirection: true),
          size: 16,
          color: const Color.fromRGBO(33, 150, 243, 1),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
          child: Text(
            weatherStatus,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Text(
          temperature,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
