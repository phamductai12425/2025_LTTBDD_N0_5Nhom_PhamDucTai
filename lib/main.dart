// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/habit.dart';
import 'screens/home_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/about_screen.dart';
import 'screens/add_habit_screen.dart';
import 'utils/localization.dart';

/// ----------------------
/// Translation Provider
/// ----------------------
class TranslationProvider extends InheritedNotifier<ValueNotifier<String>> {
  static const Map<String, Map<String, String>> _strings = {
    'vi': {
      'app_title': 'Habit Tracker',
      'home': 'Trang chủ',
      'stats': 'Thống kê',
      'about': 'Giới thiệu',
      'add_habit': 'Thêm thói quen',
      'enter_habit': 'Nhập tên thói quen',
      'cancel': 'Hủy',
      'add': 'Thêm',
      'no_habits': 'Chưa có thói quen nào. Nhấn + để thêm.',
      'confirm_delete': 'Bạn chắc chắn muốn xóa?',
      'delete': 'Xóa',
      'undo': 'Hoàn tác',
      'language': 'Ngôn ngữ',
      'progress': 'Tiến độ',
    },
    'en': {
      'app_title': 'Habit Tracker',
      'home': 'Home',
      'stats': 'Stats',
      'about': 'About',
      'add_habit': 'Add habit',
      'enter_habit': 'Enter habit name',
      'cancel': 'Cancel',
      'add': 'Add',
      'no_habits': 'No habits yet. Tap + to add.',
      'confirm_delete': 'Are you sure want to delete?',
      'delete': 'Delete',
      'undo': 'Undo',
      'language': 'Language',
      'progress': 'Progress',
    }
  };

  const TranslationProvider({
    required ValueNotifier<String> notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static TranslationProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TranslationProvider>();

  String t(String key) {
    final code = notifier?.value ?? 'vi';
    return _strings[code]?[key] ?? key;
  }

  void setLocale(String code) {
    if (notifier != null && _strings.containsKey(code)) {
      notifier!.value = code;
    }
  }
}

/// ----------------------
/// Main Entry
/// ----------------------
void main() {
  runApp(const MyAppBootstrap());
}

class MyAppBootstrap extends StatefulWidget {
  const MyAppBootstrap({super.key});
  @override
  State<MyAppBootstrap> createState() => _MyAppBootstrapState();
}

class _MyAppBootstrapState extends State<MyAppBootstrap> {
  final ValueNotifier<String> _localeNotifier = ValueNotifier<String>('vi');
  List<Habit> _habits = [];
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('locale_v1') ?? 'vi';
    final stored = prefs.getStringList('habits_v1') ?? <String>[];
    final loaded = stored.map((s) {
      try {
        return Habit.fromJson(s);
      } catch (_) {
        return Habit(
            id: DateTime.now().millisecondsSinceEpoch.toString(), title: s);
      }
    }).toList();
    setState(() {
      _localeNotifier.value = lang;
      _habits = loaded;
      _ready = true;
    });
  }

  Future<void> _saveLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale_v1', code);
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _habits.map((h) => h.toJson()).toList();
    await prefs.setStringList('habits_v1', list);
  }

  void _setLocale(String code) {
    _localeNotifier.value = code;
    _saveLocale(code);
  }

  void _addHabit(String title) {
    final h = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        done: false);
    setState(() => _habits.add(h));
    _saveHabits();
  }

  void _toggleHabit(String id) {
    setState(() {
      final idx = _habits.indexWhere((e) => e.id == id);
      if (idx != -1) {
        _habits[idx] = _habits[idx].copyWith(done: !_habits[idx].done);
      }
    });
    _saveHabits();
  }

  void _deleteHabit(String id) {
    setState(() => _habits.removeWhere((e) => e.id == id));
    _saveHabits();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    return TranslationProvider(
      notifier: _localeNotifier,
      child: MaterialApp(
        title: 'Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
        ),
        locale: Locale(_localeNotifier.value),
        supportedLocales: AppLocalization.supportedLocales,
        localizationsDelegates: AppLocalization.localizationsDelegates,
        home: RootPage(
          habits: _habits,
          onAdd: _addHabit,
          onToggle: _toggleHabit,
          onDelete: _deleteHabit,
          setLocale: _setLocale,
        ),
        routes: {
          '/about': (_) => const AboutScreen(),
          '/stats': (_) => StatsScreen(habits: _habits),
        },
      ),
    );
  }
}

/// ----------------------
/// RootPage with bottom navigation
/// ----------------------
class RootPage extends StatefulWidget {
  final List<Habit> habits;
  final void Function(String title) onAdd;
  final void Function(String id) onToggle;
  final void Function(String id) onDelete;
  final void Function(String code) setLocale;

  const RootPage({
    super.key,
    required this.habits,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
    required this.setLocale,
  });

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final tr = TranslationProvider.of(context)!.t;
    final pages = <Widget>[
      HomeScreen(
        habits: widget.habits,
        onAdd: widget.onAdd,
        onToggle: widget.onToggle,
        onDelete: widget.onDelete,
      ),
      StatsScreen(habits: widget.habits),
      const AboutScreen(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: tr('home')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart), label: tr('stats')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.info_outline), label: tr('about')),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () async {
                final title = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                );
                if (title != null && title.trim().isNotEmpty) {
                  widget.onAdd(title.trim());
                }
              },
              child: const Icon(Icons.add),
              tooltip: tr('add_habit'),
            )
          : null,
    );
  }
}
