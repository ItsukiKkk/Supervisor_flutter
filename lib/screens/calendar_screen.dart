import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/habits_provider.dart';
import '../models/todo_item.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todosProvider);
    final selectedDayTodos = _selectedDay != null
        ? ref.read(todosProvider.notifier).getTodosForDate(_selectedDay!)
        : <TodoItem>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: (day) {
              return todos
                  .where((todo) =>
                      todo.date.year == day.year &&
                      todo.date.month == day.month &&
                      todo.date.day == day.day)
                  .toList();
            },
          ),
          const Divider(),
          if (_selectedDay != null) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'To-dos for ${_selectedDay!.month}/${_selectedDay!.day}/${_selectedDay!.year}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddTodoDialog(context, ref),
                  ),
                ],
              ),
            ),
            Expanded(
              child: selectedDayTodos.isEmpty
                  ? const Center(
                      child: Text(
                        'No to-dos for this date',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: selectedDayTodos.length,
                      itemBuilder: (context, index) {
                        final todo = selectedDayTodos[index];
                        return Dismissible(
                          key: Key(todo.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            ref.read(todosProvider.notifier).deleteTodo(todo.id);
                          },
                          child: CheckboxListTile(
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            value: todo.isCompleted,
                            onChanged: (value) {
                              ref.read(todosProvider.notifier).toggleTodo(todo.id);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ] else
            const Expanded(
              child: Center(
                child: Text(
                  'Select a date to view/add to-dos',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add To-do'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter to-do item',
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
              if (controller.text.isNotEmpty && _selectedDay != null) {
                ref.read(todosProvider.notifier).addTodo(
                      controller.text,
                      _selectedDay!,
                    );
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