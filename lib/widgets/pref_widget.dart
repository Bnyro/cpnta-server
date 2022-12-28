import 'package:flutter/material.dart';

class PrefWidget extends StatelessWidget {
  final String title;
  final String summary;
  final VoidCallback onClick;

  const PrefWidget(
      {super.key,
      required this.title,
      required this.summary,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(summary)
        ],
      ),
      onTap: onClick,
    );
  }
}
