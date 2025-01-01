import 'package:flutter/material.dart' hide Action;
import 'package:flutter_application_1/components/settle.dart';
import 'package:flutter_application_1/components/undo.dart';
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
    resetWidget() {
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
    }

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: getPlayers().toList(),
                  ))),
          Expanded(
              flex: 0,
              child: Container(
                color: Colors.grey[900],
                width: double.infinity,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '第 ${(playController.start + 1).toString()} 局',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      // 更多按钮
                      TextButton.icon(
                          onPressed: () {
                            // 底部抽屉
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  // 列表
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.refresh),
                                        title: const Text('重开'),
                                        onTap: () {
                                          // 重开逻辑
                                          Navigator.of(context).pop();
                                          resetWidget();
                                        },
                                      ),
                                      Settle(playController: playController),
                                      ListTile(
                                        // 禁止点击反显
                                        enabled: playController.canUndo(),
                                        leading: const Icon(Icons.undo),
                                        title: const Text('撤销'),
                                        onTap: () {
                                          // 撤销逻辑
                                          if (playController.canUndo()) {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              playController.undo();
                                            });
                                          }
                                        },
                                      ),
                                      ListTile(
                                        // 禁止点击反显
                                        enabled: playController.canRedo(),
                                        leading: const Icon(Icons.redo),
                                        title: const Text('重做'),
                                        onTap: () {
                                          // 重做逻辑
                                          if (playController.canRedo()) {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              playController.redo();
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          label: const Icon(Icons.more_horiz,
                              color: Colors.white)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
