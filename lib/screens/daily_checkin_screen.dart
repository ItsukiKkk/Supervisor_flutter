import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habits_provider.dart';

class DailyCheckinScreen extends ConsumerWidget {
  const DailyCheckinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider);
    final todayTodos = ref.watch(todayTodosProvider);
    
    // Combine habits and today's todos for display
    final allItems = [...habits, ...todayTodos];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-in'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddHabitDialog(context, ref),
          ),
        ],
      ),
      body: allItems.isEmpty
          ? const Center(
              child: Text(
                'No habits yet.\nTap + to add your first habit!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: allItems.length,
              itemBuilder: (context, index) {
                final item = allItems[index];
                final isHabit = index < habits.length;
                
                return Dismissible(
                  key: Key(item.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    if (isHabit) {
                      ref.read(habitsProvider.notifier).deleteHabit(item.id);
                    } else {
                      ref.read(todosProvider.notifier).deleteTodo(item.id);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.title} deleted')),
                    );
                  },
                  child: CheckboxListTile(
                    title: Text(
                      item.title,
                      style: TextStyle(
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(isHabit ? 'Habit' : 'Today\'s To-do'),
                    value: item.isCompleted,
                    onChanged: (value) {
                      if (isHabit) {
                        ref.read(habitsProvider.notifier).toggleHabit(item.id);
                      } else {
                        ref.read(todosProvider.notifier).toggleTodo(item.id);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showAddHabitDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter habit name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(habitsProvider.notifier).addHabit(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
