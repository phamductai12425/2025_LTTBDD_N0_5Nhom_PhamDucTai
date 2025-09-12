class Habit {
  final String title;
  final bool done;

  const Habit({
    required this.title,
    this.done = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'done': done,
    };
  }

  /// Create object from Map safely
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      title: (map['title']?.toString()) ?? 'Untitled',
      done: (map['done'] is bool) ? map['done'] as bool : false,
    );
  }

  
  Habit copyWith({
    String? title,
    bool? done,
  }) {
    return Habit(
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  @override
  String toString() => 'Habit(title: $title, done: $done)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Habit && other.title == title && other.done == done;
  }

  @override
  int get hashCode => title.hashCode ^ done.hashCode;
}
