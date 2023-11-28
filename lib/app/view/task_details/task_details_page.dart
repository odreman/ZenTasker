import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/category.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/app/view/components/title.dart';
import 'package:zen_tasker/utils/constants.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  DateTime? _dueDate;
  String? selectedCategory;
  final List<String> predefinedCategories = Category.getPredefinedCategories()
      .map((category) => category.name)
      .toList();
  late TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    _dueDate = widget.task.dueDate;
    selectedCategory = widget.task.category ?? predefinedCategories.first;
    _detailsController = TextEditingController(text: widget.task.detail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Column 1 - Title
              Align(
                alignment: AlignmentDirectional.topStart,
                child: DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                      widget.task.category = selectedCategory;
                      Provider.of<TaskModel>(context, listen: false)
                          .updateTask(widget.task);
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

              //Column 2 - Details input
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
                onChanged: (value) {
                  widget.task.detail = value;
                  Provider.of<TaskModel>(context, listen: false)
                      .updateTask(widget.task);
                },
              ),

              //Column 3 - Due date
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
                          widget.task.dueDate = _dueDate;
                          Provider.of<TaskModel>(context, listen: false)
                              .updateTask(widget.task);
                        });
                      }
                    },
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: customPrimaryBackgroundColor,
                        label: Text(_dueDate != null
                            ? DateFormat('dd/MM/yyyy HH:mm').format(_dueDate!)
                            : 'Vencimiento'),
                        deleteIcon:
                            _dueDate != null ? const Icon(Icons.close) : null,
                        onDeleted: _dueDate != null
                            ? () {
                                setState(() {
                                  _dueDate = null;
                                  widget.task.dueDate = _dueDate;
                                  Provider.of<TaskModel>(context, listen: false)
                                      .updateTask(widget.task);
                                });
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),

              //Column 4 - Done
              const SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.task.isDone = !widget.task.isDone;
                      Provider.of<TaskModel>(context, listen: false)
                          .updateTask(widget.task);
                    });
                  },
                  child: Row(
                    children: [
                      widget.task.isDone
                          ? const Icon(Icons.check_circle)
                          : const Icon(Icons.check_box_outline_blank),
                      const SizedBox(width: 10),
                      const TextH3("Estado de la tarea")
                    ],
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
