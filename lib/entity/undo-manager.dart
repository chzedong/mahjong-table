import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/type.dart';

// snapshot
class Snapshot {
  late List<int> players;
  late List<int> gangs;
  late List<int> banker;
  late int start;
  late List<String> names;

  Snapshot(PlayState playController) {
    players = playController.players.toList();
    gangs = playController.gangs.toList();
    banker = playController.banker.toList();
    start = playController.start;
    names = playController.names.toList();
  }
}

// preAction
class PreAction {
  String name;
  int attach;
  bool isLong;
  bool ziMo;
  Action action;

  PreAction(this.name, this.attach, this.isLong, this.ziMo, this.action);
}

class UndoAction {
  late Snapshot _snapshot;
  late PreAction _preAction;

  void undo(PlayState playController) {
    final players = _snapshot.players;
    final gangs = _snapshot.gangs;
    final banker = _snapshot.banker;
    final start = _snapshot.start;
    final names = _snapshot.names;

    playController.players = players;
    playController.gangs = gangs;
    playController.banker = banker;
    playController.start = start;
    playController.names = names;

    if (kDebugMode) {
      print(
          'undo action: ${_preAction.toString()}, snapshot: ${_snapshot.toString()}');
    }
  }

  void redo(PlayState playController) {
    final name = _preAction.name;
    final attach = _preAction.attach;
    final ziMo = _preAction.ziMo;
    final isLong = _preAction.isLong;
    final action = _preAction.action;

    playController.dispatch(action, name, attach, ziMo: ziMo, isLong: isLong);

    if (kDebugMode) {
      print(
          'redo action: ${_preAction.toString()}, snapshot: ${_snapshot.toString()}');
    }
  }

  UndoAction(
    PlayState playController, {
    required Action action,
    required String name,
    required int attach,
    required bool isLong,
    required bool ziMo,
  }) {
    _snapshot = Snapshot(playController);
    _preAction = PreAction(name, attach, isLong, ziMo, action);
  }
}

class UndoManager {
  List<UndoAction> undoStack = [];
  List<UndoAction> redoStack = [];

  void push(UndoAction action) {
    undoStack.add(action);
    // redoStack.clear();

    if (kDebugMode) {
      print('undo stack: ${undoStack.length}, redo stack: ${redoStack.length}');
    }
  }

  void undo(PlayState playController) {
    if (undoStack.isNotEmpty) {
      UndoAction action = undoStack.removeLast();
      action.undo(playController);
      redoStack.add(action);
    }

    if (kDebugMode) {
      print('undo stack: ${undoStack.length}, redo stack: ${redoStack.length}');
    }
  }

  void redo(PlayState playController) {
    if (redoStack.isNotEmpty) {
      UndoAction action = redoStack.removeLast();
      action.redo(playController);
      // undoStack.add(action);
    }

    if (kDebugMode) {
      print('undo stack: ${undoStack.length}, redo stack: ${redoStack.length}');
    }
  }
}
