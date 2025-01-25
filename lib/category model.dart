import 'package:get/get.dart';

import 'mode.dart';

class Category {
  String id;
  String name;
  RxList<Task> tasks;

  Category({required this.id, required this.name, required this.tasks});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      tasks: <Task>[].obs, // Ensure tasks is initialized as an RxList
    );
  }
}
