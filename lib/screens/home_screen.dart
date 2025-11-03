import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../main.dart';
import 'add_mood_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, MoodEntry> entries;
  final ValueChanged<Map<String, MoodEntry>> onSave;
  final String localeCode;

  const HomeScreen({
    super.key,
    required this.entries,
    required this.onSave,
    this.localeCode = 'vi',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, MoodEntry> _map;

  static const primary = Color(0xFFFF5F6D);
  static const secondary = Color(0xFFFFC371);
  static const bg = Color(0xFFFFF8E7);
  static const gradient = LinearGradient(
    colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  bool get isVi => widget.localeCode == 'vi';

  @override
  void initState() {
    super.initState();
    _map = {...widget.entries};
  }

  void _openAdd({MoodEntry? existing}) async {
    final result = await Navigator.push<MoodEntry>(
      context,
      MaterialPageRoute(builder: (_) => AddMoodScreen(localeCode: widget.localeCode, existing: existing)),
    );
    if (result == null) return;
    _map[result.date] = result;
    widget.onSave(_map);
    if (!mounted) return;
    setState(() {});
    _snack(isVi ? 'Đã lưu cảm xúc 💖' : 'Mood saved 💖');
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
      );

  Future<void> _confirmDelete(String date) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isVi ? 'Xoá cảm xúc' : 'Delete mood'),
        content: Text(isVi ? 'Bạn có chắc muốn xóa?' : 'Are you sure you want to delete?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(isVi ? 'Huỷ' : 'Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(isVi ? 'Xoá' : 'Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      _map.remove(date);
      widget.onSave(_map);
      setState(() {});
      _snack(isVi ? 'Đã xoá 💔' : 'Deleted 💔');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = TranslationProvider.of(context)!.t;
    final todayKey = _fmt(DateTime.now());
    final today = _map[todayKey];
    final list = _map.values.toList()..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bg, Color(0xFFFFEFD5), Color(0xFFFFD9C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _header(tr('app_title')),
                const SizedBox(height: 12),
                _todayCard(today, todayKey),
                const SizedBox(height: 18),
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: Text(
                            isVi ? "Chưa có cảm xúc nào 🌤️" : "No mood entries yet 🌤️",
                            style: const TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (_, i) => _item(list[i]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_mood',
        backgroundColor: primary,
        icon: const Icon(Icons.add),
        label: Text(isVi ? 'Thêm cảm xúc' : 'Add Mood'),
        onPressed: () => _openAdd(),
      ),
    );
  }

  Widget _header(String title) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 22)),
          IconButton(icon: const Icon(Icons.bar_chart_rounded, color: primary), onPressed: () {}),
        ],
      );

  Widget _todayCard(MoodEntry? today, String key) => Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: primary.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        padding: const EdgeInsets.all(18),
        child: Row(children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(today != null ? Icons.mood : Icons.add_circle_outline,
                key: ValueKey(today != null), color: Colors.white, size: 48),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                today?.note ?? (isVi ? 'Hôm nay chưa ghi lại cảm xúc' : 'No entry for today'),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(today?.mood ?? key,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
          ),
          ElevatedButton(
            onPressed: () => _openAdd(existing: today),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: primary),
            child: Text(isVi ? (today != null ? 'Sửa' : 'Thêm') : (today != null ? 'Edit' : 'Add')),
          )
        ]),
      );

  Widget _item(MoodEntry e) => Dismissible(
        key: ValueKey(e.date),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          await _confirmDelete(e.date);
          return false;
        },
        background: Container(
          decoration: const BoxDecoration(gradient: gradient),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: ListTile(
            onTap: () => _openAdd(existing: e),
            leading: const CircleAvatar(backgroundColor: Color(0xFFFFF1E0), child: Icon(Icons.mood, color: primary)),
            title: Text(e.date, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(e.note ?? (isVi ? 'Không có ghi chú' : 'No note')),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(12)),
              child: Text(e.mood, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      );

  static String _fmt(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
}
