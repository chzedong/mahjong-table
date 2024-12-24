import 'package:flutter/material.dart';
import 'package:flutter_application_1/playctl.dart';
import 'package:flutter_application_1/player.dart';

class Play extends StatefulWidget {
  const Play({Key? key}) : super(key: key);

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  final PlayController playController = PlayController();

  Iterable<Widget> getPlayers() {
    return playController.names.map((name) {
      return Expanded(
          child: Player(
              isBanker: playController.bankerIndex ==
                      playController.names.indexOf(name)
                  ? playController.bankerNumber + 1
                  : -1,
              name: name,
              score: playController.getPlayerScore(name),
              kong: playController.getPlayerGang(name),
              onHu: (name, baseScore) {
                setState(() {
                  playController.onHu(name, baseScore);
                });
              },
              onGang: (name, baseScore) {
                setState(() {
                  playController.onGang(name, baseScore);
                });
              },
              onZimo: (name, baseScore) {
                setState(() {
                  playController.onHu(name, baseScore, ziMo: true);
                });
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
              flex: 0,
              child: Container(
                color: Colors.lightBlue,
                width: double.infinity,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        '第 ${(playController.start + 1).toString()} 局',
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white),
                      )),
                      ElevatedButton(
                          onPressed: () {
                            // 点击按钮的时候，警告弹框提示是否要重置
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text('重开'),
                                      content: const Text('是否要重新开始？'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              playController.reset();
                                            });
                                          },
                                          child: Text('确认'),
                                        )
                                      ]);
                                });
                          },
                          child: const Text('重开'))
                    ],
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                  width: double.infinity,
                  child: Column(
                    children: getPlayers().toList(),
                  )))
        ],
      ),
    );
  }
}
