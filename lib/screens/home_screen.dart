import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_tile.dart';
import '../widgets/language_switcher.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const HomeScreen({super.key, required this.setLocale});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Habit> _habits = [
    const Habit(title: "Uống 2 lít nước"),
    const Habit(title: "Tập thể dục 30 phút"),
  ];

  void _toggleHabit(int index) {
    setState(() {
      _habits[index] =
          _habits[index].copyWith(done: !_habits[index].done);
    });
  }

  void _addHabit(String title) {
    setState(() {
      _habits.add(Habit(title: title));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.pushNamed(context, '/stats'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
          LanguageSwitcher(onChange: widget.setLocale),
        ],
      ),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          return HabitTile(
            habit: _habits[index],
            onTap: () => _toggleHabit(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newHabit = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
          if (newHabit != null) _addHabit(newHabit);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
