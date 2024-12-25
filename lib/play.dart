import 'package:flutter/material.dart' hide Action;
import 'package:flutter_application_1/entity/playctl.dart';
import 'package:flutter_application_1/player.dart';
import 'package:flutter_application_1/type.dart';

class Play extends StatefulWidget {
  const Play({super.key});

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  final PlayController playController = PlayController();

  _dispatch(Action action, String name, int attach,
      {bool ziMo = false, bool isLong = false}) {
    setState(() {
      playController.dispatch(action, name, attach, ziMo: ziMo, isLong: isLong);
    });
  }

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
                _dispatch(Action.hu, name, baseScore);
              },
              onGang: (name, baseScore) {
                _dispatch(Action.gang, name, baseScore);
              },
              onZimo: (name, baseScore) {
                _dispatch(Action.zimo, name, baseScore, ziMo: true);
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: playController.canUndo()
                                ? Colors.white
                                : Colors.grey),
                        onPressed: () {
                          setState(() {
                            playController.undo();
                          });
                        },
                        child: const Text('撤销'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: playController.canRedo()
                                ? Colors.white
                                : Colors.grey),
                        onPressed: () {
                          setState(() {
                            playController.redo();
                          });
                        },
                        child: const Text('重做'),
                      ),
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
                                              playController.resetState();
                                            });
                                          },
                                          child: const Text('确认'),
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
              child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: getPlayers().toList(),
                  )))
        ],
      ),
    );
  }
}
