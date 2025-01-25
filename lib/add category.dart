// Add Category Dialog
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'controller.dart';

class AddCategoryDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(hintText: 'Category Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              Get.find<TodoController>().addCategory(nameController.text);
              Get.back();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}