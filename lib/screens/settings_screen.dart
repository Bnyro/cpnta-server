import 'package:cpnta/constants.dart';
import 'package:cpnta/extensions/capitalize.dart';
import 'package:cpnta/providers/note_provider.dart';
import 'package:cpnta/widgets/edit_text_pref.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../widgets/pref_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete all notes"),
          content: new Text(
              "Are you sure you want to delete all notes? This can't be undone!"),
          actions: <Widget>[
            TextButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: new Text("OK"),
              onPressed: () {
                deleteAllNotes();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) async {
    PackageInfo pkgInfo = await PackageInfo.fromPlatform();
    showAboutDialog(
        context: context,
        applicationName: pkgInfo.appName.capitalize(),
        applicationVersion: pkgInfo.version + " (" + pkgInfo.buildNumber + ")",
        children: [
          const Text("Licensed under the GPL-3.0"),
          const Text("Made by Bnyro with <3")
        ]);
  }

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
            children: [
              EditTextPrefWidget(
                  prefKey: "apiUrl", label: "API Url", defValue: defaultApiUrl),
              SizedBox(height: 10.0),
              EditTextPrefWidget(
                  prefKey: "token",
                  label: "Auth token",
                  defValue: defaultToken),
              SizedBox(height: 15.0),
              PrefWidget(
                title: "Delete all notes",
                summary: 'Delete all notes associated with the user token',
                onClick: () => {_showDeleteAllDialog(context)},
              ),
              SizedBox(height: 15.0),
              PrefWidget(
                title: "About",
                summary: 'About the app and the author',
                onClick: () => {_showAboutDialog(context)},
              )
            ],
          ),
        ));
  }
}
