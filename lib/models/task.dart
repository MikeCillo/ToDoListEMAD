class Task {
  final String id;
  final String title;
  bool isCompleted;
  bool isImportant;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isImportant = false,
  });
}
