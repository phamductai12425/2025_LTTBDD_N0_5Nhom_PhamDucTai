class Habit {
  final String title;
  final bool done;

  const Habit({
    required this.title,
    this.done = false,
  });

  Habit copyWith({
    String? title,
    bool? done,
  }) {
    return Habit(
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toMap() => {'title': title, 'done': done};

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      title: (map['title']?.toString()) ?? 'Untitled',
      done: (map['done'] is bool) ? map['done'] as bool : false,
    );
  }

  @override
  String toString() => 'Habit(title: $title, done: $done)';
}
