import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/type.dart';
import './undo-manager.dart';

class PlayController extends PlayState {
  final UndoManager _undoManager = UndoManager();

  void undo() {
    _undoManager.undo(this);
  }

  void redo() {
    _undoManager.redo(this);
  }

  bool canUndo() {
    return _undoManager.undoStack.isNotEmpty;
  }

  bool canRedo() {
    return _undoManager.redoStack.isNotEmpty;
  }

  int get bankerIndex {
    if (kDebugMode) {
      print('banker: $banker');
      print('score:${players[0] + players[1] + players[2] + players[3]}');
    }

    return banker[0] % players.length;
  }

  int get bankerNumber {
    return banker[1];
  }

  bool isEnd() {
    return players.any((item) => item == 0);
  }

  int getBankerScore(int n, {bool isLong = false}) {
    const base = 5;
    const gup = 2;
    const long = 24;
    return n * gup + (isLong ? long : base);
  }

  @override
  void dispatch(Action action, String name, int attach,
      {bool ziMo = false, bool isLong = false}) {
    // stack
    _undoManager.push(UndoAction(this,
        name: name,
        attach: attach,
        isLong: isLong,
        ziMo: ziMo,
        action: action));

    if (action == Action.hu || action == Action.zimo) {
      _onHu(name, attach, ziMo: ziMo, isLong: isLong);
    } else if (action == Action.gang) {
      _onGang(name, attach);
    } else {
      reset();
    }
  }

  void resetState() {
    dispatch(Action.reset, '', 0);
  }

  void _onGang(String name, int attach) {
    final index = names.indexOf(name);
    gangs[index] += attach;
  }

  void _onHu(String name, int attach,
      {bool ziMo = false, bool isLong = false}) {
    final index = names.indexOf(name);

    int preBankerNumber = banker[1];

    if (index != bankerIndex) {
      banker[1] = 0;
    } else {
      banker[1] += 1;
    }

    final baseScore = getBankerScore(banker[1], isLong: isLong);

    int winScore = baseScore + attach;
    if (ziMo) {
      winScore *= 2;
    }

    int indexScore = 0;
    for (int i = 0; i < players.length; i++) {
      if (i != index) {
        if (i == bankerIndex) {
          int preBankerBase = getBankerScore(preBankerNumber + 1);
          int win = preBankerBase + attach;

          if (ziMo) {
            win *= 2;
          }
          indexScore += min(win, players[i]);
          players[i] -= min(win, players[i]);
        } else {
          indexScore += min(winScore, players[i]);
          players[i] -= min(winScore, players[i]);
        }
      }
    }

    if (index != bankerIndex) {
      banker[0] += 1;
    }
    players[index] += indexScore;
    start += 1;
  }

  int getPlayerScore(String name) {
    final index = names.indexOf(name);
    return players[index];
  }

  int getPlayerGang(String name) {
    final index = names.indexOf(name);
    return gangs[index];
  }

  int getPlayerRealGang(String name) {
    final index = names.indexOf(name);

    int otherGang = 0;
    for (int i = 0; i < gangs.length; i++) {
      if (i != index) {
        otherGang += gangs[i];
      }
    }

    return gangs[index] + otherGang;
  }
}
