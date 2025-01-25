import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolistapp/settings%20page.dart';
import 'package:todolistapp/task%20page.dart';
import 'add category.dart';

import 'controller.dart';

class HomePage extends StatelessWidget {
  final TodoController todoController = Get.put(TodoController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch categories when the HomePage is built
    todoController.fetchCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
           Get.to(( const
                SettingsPage()));}, icon: Icon(Icons.settings))
        ],
      ),
      body: Obx(() {
        if (todoController.categories.isEmpty) {
          return const Center(
            child: Text('No categories yet! Add a new category to get started.'),
          );
        }

        return ListView.builder(
          itemCount: todoController.categories.length,
          itemBuilder: (context, index) {
            final category = todoController.categories[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(category.name),
                subtitle: Text('${category.tasks?.length ?? 0} tasks'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => todoController.deleteCategory(index),
                ),
                onTap: () {
                  Get.to(() => TaskPage(categoryIndex: index));
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.dialog(AddCategoryDialog()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
