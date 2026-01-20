import '../models/list_item.dart';
class TodoItem implements ListItem{
  @override
  final String id;
  @override
  final String title;
  final DateTime date;
  @override
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.title,
    required this.date,
    this.isCompleted = false,
  });

  TodoItem copyWith({
    String? id,
    String? title,
    DateTime? date,
    bool? isCompleted,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // For future local storage implementation
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
        id: json['id'],
        title: json['title'],
        date: DateTime.parse(json['date']),
        isCompleted: json['isCompleted'],
      );
}
