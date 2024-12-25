import 'package:flutter/material.dart';
import 'play.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('麻将桌',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.grey[900], // 设置背景颜
      ),
      body: const Center(child: Play()),
    );
  }
}
