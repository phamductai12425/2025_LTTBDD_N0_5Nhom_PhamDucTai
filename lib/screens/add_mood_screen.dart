import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class AddMoodScreen extends StatefulWidget {
  final String localeCode;
  final MoodEntry? existing;

  const AddMoodScreen({super.key, required this.localeCode, this.existing});

  @override
  State<AddMoodScreen> createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends State<AddMoodScreen> {
  String? _mood;
  late final TextEditingController _note;

  static const gradient = LinearGradient(
    colors: [Color(0xFFFFF7E8), Color(0xFFFFE5D9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const primary = Color(0xFFBF360C);
  static const btnColor = Color(0xFFFF8B8B);

  final _options = const [
    {'emoji': '😊', 'label': 'Happy', 'color': Color(0xFFFFD89B)},
    {'emoji': '😐', 'label': 'Neutral', 'color': Color(0xFFFFB5A7)},
    {'emoji': '😢', 'label': 'Sad', 'color': Color(0xFFB5EAD7)},
    {'emoji': '🤩', 'label': 'Excited', 'color': Color(0xFFFF9A8B)},
    {'emoji': '😡', 'label': 'Angry', 'color': Color(0xFFFF6A88)},
  ];

  bool get isVi => widget.localeCode == 'vi';
  String tr(String vi, String en) => isVi ? vi : en;

  @override
  void initState() {
    super.initState();
    _note = TextEditingController(text: widget.existing?.note ?? '');
    _mood = widget.existing?.mood;
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _save() {
    if (_mood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('Vui lòng chọn cảm xúc', 'Please choose a mood'))),
      );
      return;
    }
    final today = DateTime.now();
    final date = widget.existing?.date ??
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final entry = MoodEntry(date: date, mood: _mood!, note: _note.text.trim().isEmpty ? null : _note.text.trim());
    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.existing == null ? tr('Thêm cảm xúc', 'Add Mood') : tr('Sửa cảm xúc', 'Edit Mood');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primary))),
              const SizedBox(height: 20),
              Text(tr('Chọn cảm xúc của bạn:', 'Choose your mood:'), style: const TextStyle(color: primary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: _options.map((m) {
                  final moodLabel = "${m['emoji']} ${m['label']}";
                  final selected = _mood == moodLabel;
                  return ChoiceChip(
                    label: Text(
                      moodLabel,
                      style: TextStyle(fontWeight: FontWeight.w600, color: selected ? Colors.white : Colors.black87),
                    ),
                    selected: selected,
                    onSelected: (_) => setState(() => _mood = moodLabel),
                    selectedColor: m['color'] as Color,
                    backgroundColor: Colors.white.withOpacity(0.4),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    elevation: selected ? 4 : 0,
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _note,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: tr('Ghi chú (tùy chọn)', 'Note (optional)'),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: Text(tr('Lưu', 'Save'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: btnColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    shadowColor: Colors.pinkAccent.withOpacity(0.4),
                    elevation: 4,
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
