import 'package:get/get.dart';
import 'package:todo_app_getx_hive/model/todo.dart';

class ToDoController extends GetxController {
  List<ToDo> toDos = <ToDo>[];
  void addTodo(String title) {
    toDos.add(ToDo(title: title));
    update();
  }

  void toggleTodoStatus(int index) {
    toDos[index].isCompleted = !toDos[index].isCompleted;
    update();
  }

  void removeTodo(int index) {
    toDos.removeAt(index);
    update();
  }

  void editTodo(int index, String newTitle) {
    toDos[index].title = newTitle;
    update();
  }
}
