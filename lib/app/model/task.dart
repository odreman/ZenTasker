class Task {
  Task(this.id, this.title,
      {this.isDone = false,
      this.detail,
      this.dueDate,
      this.reminderDate,
      this.flagSel,
      this.category});

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        isDone = json['isDone'],
        detail = json['detail'],
        dueDate =
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        reminderDate = json['reminderDate'] != null
            ? DateTime.parse(json['reminderDate'])
            : null,
        flagSel = json['flagSel'],
        category = json['category'];

  late final int id;
  late final String title;
  late bool isDone;
  String? detail;
  DateTime? dueDate;
  DateTime? reminderDate;
  int? flagSel;
  String? category;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isDone': isDone,
        'detail': detail,
        'dueDate': dueDate?.toIso8601String(),
        'reminderDate': reminderDate?.toIso8601String(),
        'flagSel': flagSel,
        'category': category,
      };

  Task copyWith({
    bool? isDone,
    String? detail,
    DateTime? dueDate,
    DateTime? reminderDate,
    int? flagSel,
    String? category,
  }) {
    return Task(
      id,
      title,
      isDone: isDone ?? this.isDone,
      detail: detail ?? this.detail,
      dueDate: dueDate ?? this.dueDate,
      reminderDate: reminderDate ?? this.reminderDate,
      flagSel: flagSel ?? this.flagSel,
      category: category ?? this.category,
    );
  }
}
