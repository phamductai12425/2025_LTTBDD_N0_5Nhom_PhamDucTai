import 'dart:convert';

class MoodEntry {
  final String date;
  final String mood;
  final String? note;

  MoodEntry({required this.date, required this.mood, this.note});

  String toJson() => jsonEncode({'date': date, 'mood': mood, 'note': note});
  factory MoodEntry.fromJson(String s) {
    final m = jsonDecode(s);
    return MoodEntry(date: m['date'], mood: m['mood'], note: m['note']);
  }
}
