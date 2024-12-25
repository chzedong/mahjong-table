enum Action { hu, zimo, gang, reset }

abstract class PlayState {
  late List<int> players;

  late List<int> gangs;

  late List<int> banker;

  late int start;

  late List<String> names;

  void dispatch(Action action, String name, int attach,
      {bool ziMo = false, bool isLong = false});

  void reset() {
    players = [100, 100, 100, 100];
    gangs = [0, 0, 0, 0];
    banker = [0, 0];
    start = 0;
    names = ['东', '南', '西', '北'];
  }

  PlayState() {
    reset();
  }
}
