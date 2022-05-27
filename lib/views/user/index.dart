import 'package:flutter/material.dart';

class UserIndex extends StatefulWidget {
  @override
  _UserIndex createState() => _UserIndex();
}

class _UserIndex extends State<UserIndex> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
