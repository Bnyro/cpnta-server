import 'package:cpnta/constants.dart';
import 'package:cpnta/widgets/edit_text_pref.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: const [
              EditTextPrefWidget(
                  prefKey: "apiUrl", label: "API Url", defValue: defaultApiUrl),
              SizedBox(height: 10.0),
              EditTextPrefWidget(
                  prefKey: "token", label: "Auth token", defValue: defaultToken)
            ],
          ),
        ));
  }
}
