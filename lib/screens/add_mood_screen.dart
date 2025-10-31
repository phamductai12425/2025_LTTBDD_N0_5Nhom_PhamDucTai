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

  final List<Map<String, dynamic>> _options = [
    {'emoji': '😊', 'label': 'Happy', 'color': const Color(0xFFFFD89B)},
    {'emoji': '😐', 'label': 'Neutral', 'color': const Color(0xFFFFB5A7)},
    {'emoji': '😢', 'label': 'Sad', 'color': const Color(0xFFB5EAD7)},
    {'emoji': '🤩', 'label': 'Excited', 'color': const Color(0xFFFF9A8B)},
    {'emoji': '😡', 'label': 'Angry', 'color': const Color(0xFFFF6A88)},
  ];

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
        SnackBar(content: Text(widget.localeCode == 'vi' ? 'Vui lòng chọn cảm xúc' : 'Please choose a mood')),
      );
      return;
    }

    final today = DateTime.now();
    final date = widget.existing?.date ??
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final entry = MoodEntry(
      date: date,
      mood: _mood!,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final isVi = widget.localeCode == 'vi';
    final title = widget.existing == null
        ? (isVi ? 'Thêm cảm xúc' : 'Add Mood')
        : (isVi ? 'Sửa cảm xúc' : 'Edit Mood');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF7E8), Color(0xFFFFE5D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFBF360C),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isVi ? 'Chọn cảm xúc của bạn:' : 'Choose your mood:',
                  style: const TextStyle(
                    color: Color(0xFFBF360C),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
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
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: selected,
                      onSelected: (_) => setState(() => _mood = moodLabel),
                      selectedColor: m['color'],
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
                  style: const TextStyle(color: Color(0xFF4A2C2A)),
                  decoration: InputDecoration(
                    labelText: isVi ? 'Ghi chú (tùy chọn)' : 'Note (optional)',
                    labelStyle: const TextStyle(color: Color(0xFF8D6E63)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: Text(
                      isVi ? 'Lưu' : 'Save',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFFFF8B8B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: Colors.pinkAccent.withOpacity(0.4),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
