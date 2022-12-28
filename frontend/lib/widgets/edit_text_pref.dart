import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditTextPrefWidget extends StatefulWidget {
  final String prefKey;
  final String label;
  final String defValue;

  const EditTextPrefWidget(
      {super.key,
      required this.prefKey,
      required this.label,
      required this.defValue});

  @override
  State<EditTextPrefWidget> createState() => EditTextPrefWidgetState();
}

class EditTextPrefWidgetState extends State<EditTextPrefWidget> {
  TextEditingController controller = TextEditingController();

  void init() async {
    var prefs = await SharedPreferences.getInstance();
    controller.text = prefs.getString(widget.prefKey) ?? widget.defValue;
    controller.addListener(() {
      prefs.setString(widget.prefKey, controller.text);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).highlightColor, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2.0),
        ),
        hintText: widget.label,
      ),
    );
  }
}
