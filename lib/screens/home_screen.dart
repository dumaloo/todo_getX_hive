import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx_hive/controller/todo_controller.dart';

class HomeScreen extends StatelessWidget {
  final ToDoController toDoController = Get.put(ToDoController());
  final TextEditingController editingController = TextEditingController();
  int editingIndex = -1;

  HomeScreen({super.key});

  void _showAddDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(editingIndex == -1 ? 'Add To-Do' : 'Edit To-Do'),
          content: TextField(
            controller: editingController,
            decoration: const InputDecoration(
              hintText: 'To-Do',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                if (editingIndex == -1) {
                  toDoController.addTodo(editingController.text);
                } else {
                  toDoController.editTodo(editingIndex, editingController.text);
                  editingIndex = -1; // Reset editing index
                }
                toDoController.update();
                editingController.text = ''; // Clear the text field
                Get.back(); // Close the dialog
              },
              color: Colors.deepPurple[400],
              child: const Text('Add'),
            ),
            MaterialButton(
              onPressed: () {
                editingController.text = '';
                Get.back(); // Close the dialog without adding ToDo
              },
              color: Colors.deepPurple[400],
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToDoController>(builder: (toDoController) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('To-Do'),
          backgroundColor: Colors.deepPurple[600],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: toDoController.toDos.length,
                itemBuilder: (context, index) {
                  var todo = toDoController.toDos[index];
                  return Dismissible(
                    key: UniqueKey(), // Provide a unique key
                    onDismissed: (direction) {
                      toDoController.removeTodo(index);
                      toDoController.update();
                      Get.snackbar(
                        'Task Removed',
                        'Task Removed',
                        duration: const Duration(seconds: 2),
                      );
                    },
                    background: Container(
                      color: Colors.red[400],
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: todo.isCompleted ? Colors.grey : Colors.white,
                        ),
                      ),
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          toDoController.toggleTodoStatus(index);
                          toDoController.update();
                        },
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        editingIndex = index;
                        editingController.text = todo.title;
                        _showAddDialog(); // Open the dialog for editing
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddDialog(); // Open the dialog for adding new ToDo
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
