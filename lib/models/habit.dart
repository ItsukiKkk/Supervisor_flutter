import '../models/list_item.dart';
class Habit implements ListItem{
  @override
  final String id;
  @override
  final String title;
  final DateTime createdDate;
  @override
  bool isCompleted;

  Habit({
    required this.id,
    required this.title,
    required this.createdDate,
    this.isCompleted = false,
  });

  Habit copyWith({
    String? id,
    String? title,
    DateTime? createdDate,
    bool? isCompleted,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      createdDate: createdDate ?? this.createdDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // For future local storage implementation
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdDate': createdDate.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'],
        title: json['title'],
        createdDate: DateTime.parse(json['createdDate']),
        isCompleted: json['isCompleted'],
      );
}