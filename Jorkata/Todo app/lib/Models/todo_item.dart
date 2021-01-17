class TodoItem{
  final String title;
  final String details;
  final bool isCompleted;

  const TodoItem({this.title, this.details, this.isCompleted});

  TodoItem copy({String title, String details, bool isCompleted})
  {
    return TodoItem(
      title: title?? this.title,
      details:  details?? this.details,
      isCompleted: isCompleted?? this.isCompleted,
      );
  }
}