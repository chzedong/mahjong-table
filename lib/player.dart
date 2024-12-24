import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/radio.dart';

enum Action { hu, zimo, gang }

Map _colorMap = {
  '东': const Color.fromARGB(228, 78, 163, 248),
  '南': const Color.fromARGB(255, 111, 155, 216),
  '西': const Color.fromARGB(255, 9, 100, 174),
  '北': const Color.fromARGB(255, 140, 187, 220),
};

class Player extends StatelessWidget {
  final String name;
  final int score;
  final int kong;
  final int isBanker;
  final Function(String name, int baseScore)? onHu;
  final Function(String name, int baseScore)? onZimo;
  final Function(String name, int baseScore)? onGang;

  Player({
    super.key,
    required this.name,
    required this.score,
    required this.kong,
    this.isBanker = -1,
    this.onHu,
    this.onZimo,
    this.onGang,
  });

  final Map<Action, String> actionMap = {
    Action.hu: '胡',
    Action.zimo: '自摸',
    Action.gang: '杠',
  };

  // TextEditingController
  final TextEditingController _textEditingController = TextEditingController();

  void showInputDialog(BuildContext context, Action action) {
    // 使用showDialog来显示一个对话框
    _textEditingController.text = '';

    Widget content = TextField(
      controller: _textEditingController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: '几个风',
        border: OutlineInputBorder(),
      ),
    );

    if (action == Action.gang) {
      content = RadioSelection(
        onSelectionChanged: (value) {
          _textEditingController.text = value;
        },
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(actionMap[action] ?? '未知'),
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // 取消按钮
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_textEditingController.text);

                if (action == Action.hu) {
                  if (_textEditingController.text == '') {
                    _textEditingController.text = '0';
                  }
                  onHu?.call(name, int.parse(_textEditingController.text));
                } else if (action == Action.zimo) {
                  if (_textEditingController.text == '') {
                    _textEditingController.text = '0';
                  }
                  onZimo?.call(name, int.parse(_textEditingController.text));
                } else if (action == Action.gang) {
                  if (_textEditingController.text == '') {
                    _textEditingController.text = '1';
                  }

                  onGang?.call(name, int.parse(_textEditingController.text));
                }
              },
              child: const Text('提交'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _colorMap[name] ?? Colors.white,
      child: Row(children: [
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBanker != -1 ? '庄家: 第$isBanker局' : '闲家',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: isBanker != -1
                            ? const Color.fromARGB(255, 155, 60, 4)
                            : const Color.fromARGB(255, 208, 172, 9)),
                  ),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  Text(
                    '点数： $score',
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  Text(
                    '杠： $kong',
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ],
              ),
            )),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        child: const Text('胡'),
                        onPressed: () {
                          showInputDialog(context, Action.hu);
                        }),
                    const SizedBox(height: 10), //
                    ElevatedButton(
                        child: const Text('自摸'),
                        onPressed: () {
                          showInputDialog(context, Action.zimo);
                        }),
                    const SizedBox(height: 10), //
                    ElevatedButton(
                        child: const Text('杠'),
                        onPressed: () {
                          showInputDialog(context, Action.gang);
                        }),
                  ]),
            )),
      ]),
    );
  }
}
