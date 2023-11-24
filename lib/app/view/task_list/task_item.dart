import 'package:flutter/material.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:intl/intl.dart';
import 'package:zen_tasker/app/view/task_list/task_details_modal.dart';

class TaskItem extends StatelessWidget {
  const TaskItem(this.task,
      {Key? key,
      required this.onTap,
      required this.onDelete,
      required this.onTaskUpdated})
      : super(key: key);

  final Task task;
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
        child: const Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
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
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => TaskDetailsModal(task: task),
                  );
                },
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
                            style: const TextStyle(fontSize: 10),
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
