
// Task Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todolistapp/task%20adding.dart';

import 'controller.dart';
import 'edit task.dart';

class TaskPage extends StatelessWidget {
  final int categoryIndex;
  final TodoController todoController = Get.find();

  TaskPage({required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    final category = todoController.categories[categoryIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        centerTitle: true,
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: category.tasks.length,
          itemBuilder: (context, index) {
            final task = category.tasks[index];
            return ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Get.dialog(EditTaskDialog(
                        categoryIndex: categoryIndex,
                        taskIndex: index,
                        initialTitle: task.title,
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => todoController.deleteTask(categoryIndex, index),
                  ),
                ],
              ),
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) => todoController.toggleTaskCompletion(categoryIndex, index),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.dialog(AddTaskDialog(categoryIndex: categoryIndex)),
        child: const Icon(Icons.add),
      ),
    );
  }
}