import 'package:flutter/material.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:intl/intl.dart';
import 'package:zen_tasker/app/view/task_list/task_details_modal.dart';

class TaskItem extends StatelessWidget {
  TaskItem(this.task,
      {super.key,
      required this.onTap,
      required this.onDelete,
      required this.onTaskUpdated});

  Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final ValueChanged<Task> onTaskUpdated;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.title),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete!();
      },
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
          child: Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: task.isDone
                    ? const Icon(Icons.check_circle)
                    : const Icon(Icons.check_box_outline_blank),
              ),
              GestureDetector(
                onTap: () => TaskDetailsModal(
                  task: task,
                ).showTaskDetailsModal(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: RichText(
                    text: TextSpan(
                      text: task.title,
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        if (task.dueDate != null)
                          TextSpan(
                            text:
                                '\n\nVence: ${DateFormat('dd/MM/yyyy HH:mm').format(task.dueDate!)}',
                            style: TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
