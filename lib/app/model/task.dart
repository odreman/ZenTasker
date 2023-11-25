import 'package:flutter/material.dart';

class Task {
  Task(this.id, this.title,
      {this.isDone = false, this.detail, this.dueDate, this.flagSel});

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        isDone = json['isDone'],
        detail = json['detail'],
        dueDate =
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        flagSel = json['flagSel'];

  late final String id;
  late final String title;
  late bool isDone;
  String? detail;
  DateTime? dueDate;
  int? flagSel; // Nuevo campo para la bandera

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isDone': isDone,
        'detail': detail,
        'dueDate': dueDate?.toIso8601String(),
        'flagSel': flagSel, // Guarda el valor de la bandera como un entero
      };

  Task copyWith({
    bool? isDone,
    String? detail,
    DateTime? dueDate,
    int? flagSel,
  }) {
    return Task(
      this.id,
      this.title,
      isDone: isDone ?? this.isDone,
      detail: detail ?? this.detail,
      dueDate: dueDate ?? this.dueDate,
      flagSel: flagSel ?? this.flagSel,
    );
  }
}
