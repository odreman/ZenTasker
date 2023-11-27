import 'package:flutter/material.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:intl/intl.dart';
import 'package:zen_tasker/app/view/components/title.dart';
import 'package:zen_tasker/app/view/task_list/task_details_modal.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:zen_tasker/utils/colors.dart';

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
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => TaskDetailsModal(task: task),
            );
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
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
                  Expanded(
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
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<int?>(
                        icon: task.flagSel == null
                            ? const Icon(Icons.flag_outlined,
                                color: Colors.grey)
                            : task.flagSel! <= 5
                                ? Icon(Icons.flag,
                                    color: [
                                      Colors.red,
                                      Colors.yellow,
                                      Colors.purple,
                                      Colors.blue,
                                      Colors.green
                                    ][task.flagSel! - 1],
                                    size: 20)
                                : task.flagSel! <= 10
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: [
                                                Colors.red,
                                                Colors.yellow,
                                                Colors.purple,
                                                Colors.blue,
                                                Colors.green
                                              ][task.flagSel! - 6],
                                            ),
                                          ),
                                          Text('${task.flagSel! - 5}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10)),
                                        ],
                                      )
                                    : CircularPercentIndicator(
                                        radius: 10.0,
                                        lineWidth: 4.0,
                                        percent: (task.flagSel! - 10) * 0.2,
                                        progressColor: customTertiaryColor,
                                      ),
                        // ... el resto de tu código ...
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextH2("Marcar con Símbolo"),
                                const SizedBox(height: 10),
                                const TextH3("Bandera"),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.flag,
                                          color: Colors.red, size: 20),
                                      onPressed: () {
                                        Navigator.pop(
                                            context, 1); // Bandera roja
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.flag,
                                          color: Colors.yellow, size: 20),
                                      onPressed: () {
                                        Navigator.pop(
                                            context, 2); // Bandera amarilla
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.flag,
                                          color: Colors.purple, size: 20),
                                      onPressed: () {
                                        Navigator.pop(
                                            context, 3); // Bandera morada
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.flag,
                                          color: Colors.blue, size: 20),
                                      onPressed: () {
                                        Navigator.pop(
                                            context, 4); // Bandera azul
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.flag,
                                          color: Colors.green, size: 20),
                                      onPressed: () {
                                        Navigator.pop(
                                            context, 5); // Bandera verde
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const TextH3("Número"),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: List.generate(
                                    5,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context,
                                            6 + index); // Número seleccionado
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: [
                                                Colors.red,
                                                Colors.yellow,
                                                Colors.purple,
                                                Colors.blue,
                                                Colors.green
                                              ][index],
                                            ),
                                          ),
                                          Text('${index + 1}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const TextH3("Progreso"),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: List.generate(
                                    5,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        Navigator.pop(
                                            context,
                                            11 +
                                                index); // Progreso seleccionado
                                      },
                                      child: CircularPercentIndicator(
                                        radius: 10.0, // Ajusta el radio aquí
                                        lineWidth:
                                            4.0, // Ajusta el ancho de la línea aquí
                                        percent: (index + 1) * 0.15,
                                        // Ajusta el tamaño del texto aquí
                                        progressColor: customTertiaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (flagSel) {
                          final updatedTask = task.copyWith(flagSel: flagSel);
                          onTaskUpdated(updatedTask);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
