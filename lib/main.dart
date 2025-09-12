import 'package:flutter/material.dart';

void main() {
  runApp(const HabitApp());
}

class HabitApp extends StatelessWidget {
  const HabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HabitHomePage(),
    );
  }
}

class HabitHomePage extends StatefulWidget {
  const HabitHomePage({super.key});

  @override
  State<HabitHomePage> createState() => _HabitHomePageState();
}

class _HabitHomePageState extends State<HabitHomePage> {
  // Danh sách thói quen
  final List<Map<String, dynamic>> _habits = [
    {"title": "Uống 2 lít nước", "done": false},
    {"title": "Đọc sách 30 phút", "done": false},
    {"title": "Tập thể dục", "done": false},
  ];

  void _toggleHabit(int index) {
    setState(() {
      _habits[index]["done"] = !_habits[index]["done"];
    });
  }

  void _addHabit() {
    setState(() {
      _habits.add({"title": "Thói quen mới", "done": false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Tracker"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(
              _habits[index]["title"],
              style: TextStyle(
                decoration: _habits[index]["done"]
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            value: _habits[index]["done"],
            onChanged: (_) => _toggleHabit(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        tooltip: 'Thêm thói quen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
