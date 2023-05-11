import 'package:flutter/material.dart';

class FileLabel extends StatefulWidget {
  final String textValue;

  const FileLabel({required this.textValue, super.key});

  @override
  State<FileLabel> createState() => _FileLabelState();
}

class _FileLabelState extends State<FileLabel> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Text(
          widget.textValue,
          style: textTheme.bodyLarge,
        ),
      ),
    );
  }
}