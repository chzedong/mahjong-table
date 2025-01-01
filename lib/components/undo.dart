import 'package:flutter/material.dart';

class Undo extends StatelessWidget {
  final Function undo;
  final Function redo;
  final bool canUndo;
  final bool canRedo;

  const Undo(
      {super.key,
      required this.undo,
      required this.redo,
      required this.canUndo,
      required this.canRedo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
              foregroundColor: canUndo ? Colors.white : Colors.grey[400]),
          onPressed: () {
            undo();
          },
          child: const Text('撤销'),
        ),
        TextButton(
          style: TextButton.styleFrom(
              foregroundColor: canRedo ? Colors.white : Colors.grey[400]),
          onPressed: () {
            redo();
          },
          child: const Text('重做'),
        ),
      ],
    );
  }
}
