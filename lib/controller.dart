import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'category model.dart';
import 'mode.dart';

class TodoController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Category> categories = <Category>[].obs;

  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    final snapshot = await firestore.collection('categories').get();
    for (var doc in snapshot.docs) {
      final category = Category.fromMap(doc.data());
      category.tasks.addAll(await fetchTasks(category.id));  // Fetch tasks for each category
      categories.add(category);  // Add category to the RxList
    }
  }

  // Fetch tasks for a given category from Firestore
  Future<List<Task>> fetchTasks(String categoryId) async {
    final snapshot = await firestore
        .collection('categories')
        .doc(categoryId)
        .collection('tasks')
        .get();
    return snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
  }

  // Add a new category
  Future<void> addCategory(String name) async {
    final doc = firestore.collection('categories').doc();
    final category = Category(id: doc.id, name: name, tasks: <Task>[].obs);  // Initialize tasks as RxList
    await doc.set(category.toMap());  // Save the new category to Firestore
    categories.add(category);  // Add category to the RxList
  }

  // Delete a category
  Future<void> deleteCategory(int index) async {
    final categoryId = categories[index].id;
    await firestore.collection('categories').doc(categoryId).delete();  // Delete category from Firestore
    categories.removeAt(index);  // Remove category from RxList
  }

  // Add a new task to a specific category
  Future<void> addTask(int categoryIndex, String taskTitle) async {
    final category = categories[categoryIndex];
    final doc = firestore
        .collection('categories')
        .doc(category.id)
        .collection('tasks')
        .doc();
    final task = Task(id: doc.id, title: taskTitle);
    await doc.set(task.toMap());  // Save the task to Firestore
    category.tasks.add(task);  // Add task to the category's RxList
  }

  // Delete a task from a specific category
  Future<void> deleteTask(int categoryIndex, int taskIndex) async {
    final category = categories[categoryIndex];
    final task = category.tasks[taskIndex];
    await firestore
        .collection('categories')
        .doc(category.id)
        .collection('tasks')
        .doc(task.id)
        .delete();  // Delete the task from Firestore
    category.tasks.removeAt(taskIndex);  // Remove task from the category's RxList
  }

  // Update the title of an existing task
  Future<void> updateTask(int categoryIndex, int taskIndex, String newTitle) async {
    final category = categories[categoryIndex];
    final task = category.tasks[taskIndex];
    task.title = newTitle;
    await firestore
        .collection('categories')
        .doc(category.id)
        .collection('tasks')
        .doc(task.id)
        .update({'title': newTitle});  // Update the task's title in Firestore
  }

  // Toggle the completion status of a task
  Future<void> toggleTaskCompletion(int categoryIndex, int taskIndex) async {
    final category = categories[categoryIndex];
    final task = category.tasks[taskIndex];
    task.isCompleted = !task.isCompleted;
    await firestore
        .collection('categories')
        .doc(category.id)
        .collection('tasks')
        .doc(task.id)
        .update({'isCompleted': task.isCompleted});  // Update the task's completion status in Firestore
  }
}
