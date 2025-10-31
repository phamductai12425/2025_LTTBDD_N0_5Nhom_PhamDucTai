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
    final code = notifier!.value;
    return _map[code]?[key] ?? key;
  }
}

void main() {
  runApp(const MoodApp());
}

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
    _load();
  }

  void _load() async {
    _entries = await storage.load();
    setState(() {});
  }

  void _save(Map<String, MoodEntry> m) async {
    setState(() => _entries = m);
    await storage.save(m);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(entries: _entries, onSave: _save, localeCode: _locale.value),
      AboutScreen(onLocaleChange: (v) => setState(() => _locale.value = v), localeCode: _locale.value),
    ];

    // 🎨 Vibrant Mood Spectrum màu rực rỡ
    const primaryColor = Color(0xFFFF5F6D); // Hồng đỏ năng lượng
    const secondaryColor = Color(0xFFFFC371); // Vàng cam ấm áp
    const backgroundColor = Color(0xFFFFF8E7); // Kem nhạt dịu mắt

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: Colors.white,
        onPrimary: Colors.white,
        onBackground: Colors.black87,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.interTextTheme().apply(bodyColor: Colors.black87),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 3,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );

    return TranslationProvider(
      notifier: _locale,
      child: MaterialApp(
        title: 'Mood Tracker',
        debugShowCheckedModeBanner: false,
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

class _BottomNavState extends State<_BottomNav> with SingleTickerProviderStateMixin {
  int _index = 0;
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = TranslationProvider.of(context)!.t;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: widget.pages[_index],
        transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
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
            currentIndex: _index,
            onTap: (i) {
              setState(() => _index = i);
              _anim.forward(from: 0);
            },
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showSelectedLabels: true,
            showUnselectedLabels: true,
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
