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

  static const primaryColor = Color(0xFFFF5F6D); // Hồng đỏ rực
  static const secondaryColor = Color(0xFFFFC371); // Vàng cam
  static const backgroundColor = Color(0xFFFFF8E7); // Kem sáng

  @override
  void initState() {
    super.initState();
    _map = Map<String, MoodEntry>.from(widget.entries);
  }

  void _openAdd({MoodEntry? existing}) async {
    final result = await Navigator.push<MoodEntry>(
      context,
      MaterialPageRoute(
        builder: (_) => AddMoodScreen(localeCode: widget.localeCode, existing: existing),
      ),
    );
    if (result != null) {
      _map[result.date] = result;
      widget.onSave(_map);
      setState(() {});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.localeCode == 'vi' ? 'Đã lưu cảm xúc 💖' : 'Mood saved 💖'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _confirmDelete(String date) async {
    final isVi = widget.localeCode == 'vi';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_forever, color: primaryColor, size: 48),
              const SizedBox(height: 16),
              Text(
                isVi ? 'Bạn có chắc muốn xóa cảm xúc này?' : 'Are you sure you want to delete this entry?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(isVi ? 'Huỷ' : 'Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(isVi ? 'Xoá' : 'Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted) return;

    if (confirmed == true) {
      _map.remove(date);
      widget.onSave(_map);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isVi ? 'Đã xoá 💔' : 'Deleted 💔')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = TranslationProvider.of(context)!.t;
    final todayStr = _fmt(DateTime.now());
    final today = _map[todayStr];
    final list = _map.values.toList()..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8E7), Color(0xFFFFEFD5), Color(0xFFFFD9C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _buildAppBar(tr),
                const SizedBox(height: 12),
                _buildTodayCard(today, todayStr),
                const SizedBox(height: 18),
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: Text(
                            widget.localeCode == 'vi'
                                ? "Chưa có cảm xúc nào được lưu 🌤️"
                                : "No mood entries yet 🌤️",
                            style: const TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final e = list[index];
                            return Dismissible(
                              key: ValueKey(e.date),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (_) async {
                                await _confirmDelete(e.date);
                                return false;
                              },
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 3,
                                color: Colors.white.withOpacity(0.95),
                                child: ListTile(
                                  onTap: () => _openAdd(existing: e),
                                  leading: CircleAvatar(
                                    backgroundColor: secondaryColor.withOpacity(0.25),
                                    child: const Icon(Icons.mood, color: primaryColor),
                                  ),
                                  title: Text(
                                    e.date,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    e.note ?? (widget.localeCode == 'vi' ? 'Không có ghi chú' : 'No note'),
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      e.mood,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildAppBar(String Function(String) tr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tr('app_title'),
          style: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart_rounded),
          color: primaryColor,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTodayCard(MoodEntry? today, String todayStr) {
    final isVi = widget.localeCode == 'vi';
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC371), Color(0xFFFF5F6D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              today != null ? Icons.mood : Icons.add_circle_outline,
              key: ValueKey(today != null),
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  today != null
                      ? (today.note ?? (isVi ? 'Không có ghi chú' : 'No note'))
                      : (isVi ? 'Hôm nay chưa ghi lại cảm xúc' : 'No entry for today'),
                  style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 6),
                Text(
                  today != null ? today.mood : todayStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _openAdd(existing: today),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(isVi ? (today != null ? 'Sửa' : 'Thêm') : (today != null ? 'Edit' : 'Add')),
          )
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton.extended(
      heroTag: 'add_mood',
      backgroundColor: primaryColor,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        widget.localeCode == 'vi' ? 'Thêm cảm xúc' : 'Add Mood',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      onPressed: () => _openAdd(),
    );
  }

  static String _fmt(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
}
