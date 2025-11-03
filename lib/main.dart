import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/mood_entry.dart';
import 'utils/storage.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';


class TranslationProvider extends InheritedNotifier<ValueNotifier<String>> {
  static const _map = {
    'vi': {'app_title': 'Theo dõi cảm xúc', 'home': 'Trang chủ', 'about': 'Giới thiệu'},
    'en': {'app_title': 'Mood Tracker', 'home': 'Home', 'about': 'About'},
  };

  const TranslationProvider({required super.notifier, required super.child});

  static TranslationProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TranslationProvider>();

  String t(String key) {
    final code = notifier?.value ?? 'vi';
    return _map[code]?[key] ?? key;
  }
}

void main() => runApp(const MoodApp());

class MoodApp extends StatefulWidget {
  const MoodApp({super.key});
  @override
  State<MoodApp> createState() => _MoodAppState();
}

class _MoodAppState extends State<MoodApp> {
  final _locale = ValueNotifier('vi');
  Map<String, MoodEntry> _entries = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await storage.load();
    if (mounted) setState(() => _entries = data);
  }

  Future<void> _saveData(Map<String, MoodEntry> m) async {
    setState(() => _entries = m);
    await storage.save(m);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF5F6D),
        primary: const Color(0xFFFF5F6D),
        secondary: const Color(0xFFFFC371),
        background: const Color(0xFFFFF8E7),
        onPrimary: Colors.white,
        onBackground: Colors.black87,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFFF5F6D),
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF8E7),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFF5F6D),
        foregroundColor: Colors.white,
      ),
    );

    final pages = [
      HomeScreen(entries: _entries, onSave: _saveData, localeCode: _locale.value),
      AboutScreen(onLocaleChange: (v) => setState(() => _locale.value = v), localeCode: _locale.value),
    ];

    return TranslationProvider(
      notifier: _locale,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mood Tracker',
        theme: theme,
        home: _BottomNav(pages: pages),
      ),
    );
  }
}

class _BottomNav extends StatefulWidget {
  final List<Widget> pages;
  const _BottomNav({required this.pages});

  @override
  State<_BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<_BottomNav> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final tr = TranslationProvider.of(context)!.t;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: widget.pages[_index],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.home_rounded), label: tr('home')),
              BottomNavigationBarItem(icon: const Icon(Icons.info_outline_rounded), label: tr('about')),
            ],
          ),
        ),
      ),
    );
  }
}
