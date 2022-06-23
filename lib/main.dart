import 'package:flutter/material.dart'; //卡片式主题
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './provider/globalProvider.dart';
import './views/index.dart';
import './utils/app_cache.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  //  这条语句一定要加上，不然会报错
  WidgetsFlutterBinding.ensureInitialized();
  //  初始化缓存工具类
  await AppCache.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => DomainProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // // 设置沉浸式状态栏
    // if (Platform.isAndroid) {
    //   SystemUiOverlayStyle systemUiOverlayStyle =
    //       const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // }

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp(
        title: '智慧仓储大屏',
        debugShowCheckedModeBanner: false, //是否显示app右上角的debug标志
        theme: ThemeData(primaryColor: const Color.fromRGBO(41, 175, 124, 1)),
        home: const IndexPage(),
      ),
    );
  }
}
