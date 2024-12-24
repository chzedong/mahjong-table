import 'package:flutter/material.dart';

class RadioSelection extends StatefulWidget {
  // 通知外层组件 radio的改动
  final Function(String) onSelectionChanged;

  const RadioSelection({super.key, required this.onSelectionChanged});

  @override
  _RadioSelectionState createState() => _RadioSelectionState();
}

class _RadioSelectionState extends State<RadioSelection> {
  // 用于存储当前选中的值
  String _selectedOption = '1';

  // 通知外层组件 radio的改动
  void _notifySelectionChanged() {
    widget.onSelectionChanged(_selectedOption);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RadioListTile<String>(
          title: const Text('明杠'),
          value: '1',
          groupValue: _selectedOption,
          onChanged: (String? value) {
            setState(() {
              _selectedOption = value!;
            });
            _notifySelectionChanged();
          },
        ),
        RadioListTile<String>(
          title: const Text('暗杠'),
          value: '2',
          groupValue: _selectedOption,
          onChanged: (String? value) {
            setState(() {
              _selectedOption = value!;
            });
            _notifySelectionChanged();
          },
        ),
      ],
    );
  }
}
