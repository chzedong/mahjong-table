import 'package:flutter/material.dart';
import 'package:flutter_application_1/entity/playctl.dart';

class Settle extends StatelessWidget {
  final PlayController playController;

  Settle({
    super.key,
    required this.playController,
  });

  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();

  showSettleDialog(BuildContext context) {
    // 弹框
    final market = int.parse(_textEditingController.text);
    final gangMoney = int.parse(_textEditingController2.text);
    final realSettle = playController.settle(market, gangMoney);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('结算'),
            content:
                // 列表
                Column(
              // 高度自适应
              mainAxisSize: MainAxisSize.min,
              children: realSettle.asMap().entries.map((entry) {
                int index = entry.key;
                int score = entry.value;
                return ListTile(
                  title: Text('${playController.names[index]} : ${score} 元'),
                );
              }).toList(),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('确定'),
              ),
            ],
          );
        });
  }

  onPressed(BuildContext context) {
    _textEditingController.text = '20';
    _textEditingController2.text = '2';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('结算'),
            content:
                // 列表
                Column(
              // 高度自适应
              mainAxisSize: MainAxisSize.min,
              children: [
                // 必填项
                TextField(
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    labelText: '官儿钱（元）',
                    errorText:
                        _textEditingController.text.isEmpty ? '必填' : null,
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  controller: _textEditingController2,
                  decoration: InputDecoration(
                    labelText: '杠钱（元）',
                    errorText:
                        _textEditingController2.text.isEmpty ? '必填' : null,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // 校验
                  if (_textEditingController.text.isEmpty ||
                      _textEditingController2.text.isEmpty) {
                    return;
                  }

                  Navigator.of(context).pop();
                  showSettleDialog(context);
                },
                child: const Text('确定'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check),
      title: const Text('结算'),
      onTap: () {
        Navigator.of(context).pop();
        onPressed(context);
      },
    );
  }
}
