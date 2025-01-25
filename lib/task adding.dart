// Add Task Dialog
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'controller.dart';

class AddTaskDialog extends StatelessWidget {
  final int categoryIndex;
  final TextEditingController taskController = TextEditingController();

  AddTaskDialog({required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: TextField(
        controller: taskController,
        decoration: const InputDecoration(hintText: 'Task Title'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (taskController.text.isNotEmpty) {
              Get.find<TodoController>().addTask(categoryIndex, taskController.text);
              Get.back();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}