class Task {
  Task(this.id, this.title, {this.isDone = false, this.detail, this.dueDate});

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        isDone = json['isDone'],
        detail = json['detail'],
        dueDate =
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null;

  late final String id; // Nuevo campo
  late final String title;
  late bool isDone;
  String? detail;
  DateTime? dueDate;

  Map<String, dynamic> toJson() => {
        'id': id, // Nuevo campo
        'title': title,
        'isDone': isDone,
        'detail': detail,
        'dueDate': dueDate?.toIso8601String(),
      };
}
