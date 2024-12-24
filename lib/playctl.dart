import 'dart:math';

import 'package:flutter/foundation.dart';

class PlayController {
  List<int> players = [100, 100, 100, 100];

  List<int> gangs = [0, 0, 0, 0];

  List<int> banker = [0, 0];

  List<String> names = ['东', '南', '西', '北'];

  int start = 0;

  int get bankerIndex {
    if (kDebugMode) {
      print('bankerIndex: $banker');
      print('score:' +
          (players[0] + players[1] + players[2] + players[3]).toString());
    }
    return banker[0] % players.length;
  }

  int get bankerNumber {
    return banker[1];
  }

  void reset() {
    players = [100, 100, 100, 100];
    gangs = [0, 0, 0, 0];
    banker = [0, 0];
    start = 0;
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

  void onGang(String name, int attach) {
    final index = names.indexOf(name);
    gangs[index] += attach;
  }

  void onHu(String name, int attach, {bool ziMo = false, bool isLong = false}) {
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
