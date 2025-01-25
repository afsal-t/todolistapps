// Edit Task Dialog
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'controller.dart';

class EditTaskDialog extends StatelessWidget {
  final int categoryIndex;
  final int taskIndex;
  final String initialTitle;
  final TextEditingController taskController;

  EditTaskDialog({
    required this.categoryIndex,
    required this.taskIndex,
    required this.initialTitle,
  }) : taskController = TextEditingController(text: initialTitle);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: TextField(
        controller: taskController,
        decoration: const InputDecoration(hintText: 'Task Title'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (taskController.text.isNotEmpty) {
              Get.find<TodoController>().updateTask(categoryIndex, taskIndex, taskController.text);
              Get.back();
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}