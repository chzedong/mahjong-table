import 'package:flutter/material.dart';
import 'play.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('麻将桌',
            style: TextStyle(color: Colors.white, fontSize: 26)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue, // 设置背景颜
      ),
      body: const Center(child: Play()),
    );
  }
}
