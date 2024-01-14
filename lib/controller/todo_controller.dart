import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app_getx_hive/model/todo.dart';

class ToDoController extends GetxController {
  late Box<ToDo> toDoBox; // Hive box for ToDo objects

  @override
  void onInit() async {
    await _initializeHive();
    super.onInit();
  }

  Future<void> _initializeHive() async {
    // Get the application documents directory
    final appDocumentDirectory = await getApplicationDocumentsDirectory();

    // Initialize Hive with the path to the documents directory
    Hive.init(appDocumentDirectory.path);

    // Register the Hive adapter for the ToDo class
    Hive.registerAdapter(ToDoAdapter());

    // Open the Hive box named 'todos'
    toDoBox = await Hive.openBox<ToDo>('todos');

    // Load existing ToDo items from Hive into the controller's state
    toDos = toDoBox.values.toList();
    update();
  }

  List<ToDo> toDos = <ToDo>[];

  void addTodo(String title) {
    final newTodo = ToDo(title: title);
    toDoBox.add(newTodo); // Add the new ToDo to Hive
    toDos = toDoBox.values.toList(); // Update the local list
    update();
  }

  void toggleTodoStatus(int index) {
    final todo = toDoBox.getAt(index)!;
    todo.isCompleted = !todo.isCompleted;
    todo.save(); // Save the changes to Hive
    toDos = toDoBox.values.toList(); // Update the local list
    update();
  }

  void removeTodo(int index) {
    toDoBox.deleteAt(index); // Remove the ToDo from Hive
    toDos = toDoBox.values.toList(); // Update the local list
    update();
  }

  void editTodo(int index, String newTitle) {
    final todo = toDoBox.getAt(index)!;
    todo.title = newTitle;
    todo.save(); // Save the changes to Hive
    toDos = toDoBox.values.toList(); // Update the local list
    update();
  }
}
