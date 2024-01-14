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
          title: Text(editingIndex == -1 ? 'Add ToDo' : 'Edit ToDo'),
          content: TextField(
            controller: editingController,
            decoration: InputDecoration(hintText: 'ToDo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog without adding ToDo
              },
              child: Text('Cancel'),
            ),
            TextButton(
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
              child: Text('Add'),
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
          title: Text('ToDo App'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: toDoController.toDos.length,
                itemBuilder: (context, index) {
                  var todo = toDoController.toDos[index];
                  return ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: todo.isCompleted ? Colors.red : Colors.black,
                      ),
                    ),
                    trailing: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (value) {
                        toDoController.toggleTodoStatus(index);
                        toDoController.update();
                      },
                    ),
                    onLongPress: () {
                      toDoController.removeTodo(index);
                      toDoController.update();
                    },
                    onTap: () {
                      editingIndex = index;
                      editingController.text = todo.title;
                      _showAddDialog(); // Open the dialog for editing
                    },
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
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
