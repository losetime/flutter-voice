import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class TtsUtil {
  late FlutterTts flutterTts;

  initTts() {
    flutterTts = FlutterTts();
  }

  Future speak(String text) async {
    /// 设置语言
    await flutterTts.setLanguage("zh-CN");

    /// 设置音量
    await flutterTts.setVolume(1);

    /// 设置语速
    await flutterTts.setSpeechRate(0.5);

    /// 音调
    await flutterTts.setPitch(1.0);

    await flutterTts.awaitSpeakCompletion(true);

    // text = "你好，我的名字是李磊，你是不是韩梅梅？";
    print(text.isNotEmpty);
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }
}
