import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/stats_screen.dart';
import 'utils/localization.dart';

void main() {
  runApp(const HabitApp());
}

class HabitApp extends StatefulWidget {
  const HabitApp({super.key});

  @override
  State<HabitApp> createState() => _HabitAppState();
}

class _HabitAppState extends State<HabitApp> {
  Locale _locale = const Locale('vi');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Habit Tracker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('vi')],
      localizationsDelegates: Localization.localizationsDelegates,
      home: HomeScreen(setLocale: setLocale),
      routes: {
        '/about': (context) => const AboutScreen(),
        '/stats': (context) => const StatsScreen(),
      },
    );
  }
}
