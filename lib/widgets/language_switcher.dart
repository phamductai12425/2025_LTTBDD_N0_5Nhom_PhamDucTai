import 'package:flutter/material.dart';

class LanguageSwitcher extends StatelessWidget {
  final Function(Locale) onChange;

  const LanguageSwitcher({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: onChange,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: Locale('vi'),
          child: Text("Tiếng Việt"),
        ),
        const PopupMenuItem(
          value: Locale('en'),
          child: Text("English"),
        ),
      ],
    );
  }
}
