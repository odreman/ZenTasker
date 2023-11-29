import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/category.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/services/notification_services.dart';
import 'package:zen_tasker/utils/constants.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime? _dueDate;
  DateTime? _reminderDate;
  String? selectedCategory;
  final List<String> predefinedCategories = Category.getPredefinedCategories()
      .map((category) => category.name)
      .toList();
  late TextEditingController _titleController;
  late TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    selectedCategory = predefinedCategories.first;
    _titleController = TextEditingController();
    _detailsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir tarea'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Column 1 - Title
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                cursorColor: Colors.black,
                showCursor: true,
                decoration: const InputDecoration(
                  hintText: '¿Qué hay que hacer?',
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 1,
              ),

              //Column 2 - Category
              Align(
                alignment: AlignmentDirectional.topStart,
                child: DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: predefinedCategories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  underline: Container(),
                ),
              ),

//Column 3 - Details input
              const SizedBox(height: 10),
              TextFormField(
                controller: _detailsController,
                cursorColor: Colors.black,
                showCursor: true,
                decoration: const InputDecoration(
                  hintText: '¿Te gustaría añadir más detalles?',
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 5,
              ),

//Column 4 - Due date
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 10), // Icono de calendario
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year - 1),
                          initialDate: _dueDate ?? DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 3));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              _dueDate ?? DateTime.now()),
                        );
                        setState(() {
                          _dueDate = DateTimeField.combine(date, time);
                        });
                      }
                    },
                    child: Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: customPrimaryBackgroundColor,
                      label: Text(_dueDate != null
                          ? DateFormat('dd/MM/yyyy HH:mm').format(_dueDate!)
                          : 'Vencimiento'),
                      deleteIcon: _dueDate != null
                          ? const Icon(Icons.close, size: 18)
                          : null,
                      onDeleted: _dueDate != null
                          ? () {
                              setState(() {
                                _dueDate = null;
                              });
                            }
                          : null,
                    ),
                  ),
                ],
              ),

              //Column 5 - Reminder
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.alarm),
                  const SizedBox(width: 10), // Icono de alarma
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year - 1),
                          initialDate: _reminderDate ?? DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 3));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              _reminderDate ?? DateTime.now()),
                        );
                        setState(() {
                          _reminderDate = DateTimeField.combine(date, time);
                        });
                      }
                    },
                    child: Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: customPrimaryBackgroundColor,
                      label: Text(_reminderDate != null
                          ? DateFormat('dd/MM/yyyy HH:mm')
                              .format(_reminderDate!)
                          : 'Recordatorio'),
                      deleteIcon: _reminderDate != null
                          ? const Icon(Icons.close, size: 18)
                          : null,
                      onDeleted: _reminderDate != null
                          ? () {
                              setState(() {
                                _reminderDate = null;
                              });
                            }
                          : null,
                    ),
                  ),
                ],
              ),

              //Column 6 - Save button
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  final task = Task(
                    generateId(),
                    _titleController.text,
                    detail: _detailsController.text,
                    category: selectedCategory,
                    dueDate: _dueDate,
                    reminderDate: _reminderDate,
                    isDone: false,
                  );
                  Provider.of<TaskModel>(context, listen: false).addTask(task);

                  if (_reminderDate != null) {
                    NotificationService().scheduleNotification(
                        id: task.id,
                        title: task.title,
                        body: task.detail,
                        scheduledNotificationDateTime: _reminderDate!);
                  }

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: customSecundaryTextColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int generateId() {
  return (DateTime.now().millisecondsSinceEpoch / 1000).round();
}
