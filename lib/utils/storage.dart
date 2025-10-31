import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class Storage {
  Future<Map<String, MoodEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('moods_v1') ?? [];
    final map = <String, MoodEntry>{};
    for (var s in list) {
      try {
        final e = MoodEntry.fromJson(s);
        map[e.date] = e;
      } catch (_) {}
    }
    return map;
  }

  Future<void> save(Map<String, MoodEntry> map) async {
    final prefs = await SharedPreferences.getInstance();
    final list = map.values.map((e) => e.toJson()).toList();
    await prefs.setStringList('moods_v1', list);
  }
}

final storage = Storage();
