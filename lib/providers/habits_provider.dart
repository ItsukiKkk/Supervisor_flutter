import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../models/todo_item.dart';

class HabitsNotifier extends StateNotifier<List<Habit>> {
  HabitsNotifier() : super([]);

  void addHabit(String title) {
    final newHabit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdDate: DateTime.now(),
    );
    state = [...state, newHabit];
  }

  void toggleHabit(String id) {
    state = [
      for (final habit in state)
        if (habit.id == id)
          habit.copyWith(isCompleted: !habit.isCompleted)
        else
          habit,
    ];
  }

  void deleteHabit(String id) {
    state = state.where((habit) => habit.id != id).toList();
  }

  void resetDailyCompletions() {
    state = [
      for (final habit in state) habit.copyWith(isCompleted: false),
    ];
  }
}

class TodosNotifier extends StateNotifier<List<TodoItem>> {
  TodosNotifier() : super([]);

  void addTodo(String title, DateTime date) {
    final newTodo = TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: date,
    );
    state = [...state, newTodo];
  }

  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(isCompleted: !todo.isCompleted) else todo,
    ];
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  List<TodoItem> getTodosForDate(DateTime date) {
    return state
        .where((todo) =>
            todo.date.year == date.year &&
            todo.date.month == date.month &&
            todo.date.day == date.day)
        .toList();
  }
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>((ref) {
  return HabitsNotifier();
});

final todosProvider = StateNotifierProvider<TodosNotifier, List<TodoItem>>((ref) {
  return TodosNotifier();
});

// Provider for today's todos (combines habits and date-specific todos)
final todayTodosProvider = Provider<List<TodoItem>>((ref) {
  final todos = ref.watch(todosProvider);
  final today = DateTime.now();
  return todos
      .where((todo) =>
          todo.date.year == today.year &&
          todo.date.month == today.month &&
          todo.date.day == today.day)
      .toList();
});
