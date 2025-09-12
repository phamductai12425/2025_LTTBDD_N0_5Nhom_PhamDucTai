import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const HabitTile({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // Key bắt buộc cho Dismissible
      key: ValueKey(habit.title),
      direction: DismissDirection.endToStart, // chỉ vuốt từ phải qua trái
      background: Container(
        color: Theme.of(context).colorScheme.error.withOpacity(0.2),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      onDismissed: (_) => onDelete(), // gọi callback xóa khi vuốt

      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          // Checkbox toggle trạng thái habit
          leading: Checkbox(
            value: habit.done,
            onChanged: (_) => onToggle(),
          ),

          // AnimatedSwitcher cho title → đổi style có hiệu ứng mượt
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              habit.title,
              key: ValueKey(habit.done), // bắt buộc để AnimatedSwitcher biết thay đổi
              style: TextStyle(
                decoration: habit.done ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.w500,
                color: habit.done
                    ? Colors.grey
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),

          // Nút delete dự phòng (nếu không muốn vuốt)
          trailing: IconButton(
            icon: Icon(Icons.delete,
                color: Theme.of(context).colorScheme.error),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
