import 'package:cpnta/extensions/let.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SliderPref extends StatefulWidget {
  final String title;
  final String prefKey;
  final double defaultValue;
  final double min;
  final double max;
  bool? unlimitedSelection = false;

  SliderPref(
      {super.key,
      required this.title,
      required this.prefKey,
      required this.defaultValue,
      required this.min,
      required this.max,
      this.unlimitedSelection});
  @override
  State<SliderPref> createState() => SliderPrefState();
}

class SliderPrefState extends State<SliderPref> {
  double _currentValue = 0;

  void _init() async {
    _currentValue = widget.defaultValue;
    final prefs = await SharedPreferences.getInstance();
    prefs.getDouble(widget.prefKey)?.let((value) {
      setState(() {
        _currentValue = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _onChange(double newValue) async {
    setState(() {
      _currentValue = newValue;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(widget.prefKey, newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.title),
        Slider(
          value: _currentValue,
          onChanged: _onChange,
          min: widget.min,
          max: widget.max,
          label: _currentValue.toStringAsFixed(2),
          divisions: widget.unlimitedSelection == true
              ? null
              : widget.max.toInt() - widget.min.toInt(),
        )
      ],
    );
  }
}
