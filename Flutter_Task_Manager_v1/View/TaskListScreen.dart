import 'package:flutter/material.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/Task.dart';
import 'package:app_02/Flutter_Task_Manager_v1/db/TaskDatabaseHelper.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/User.dart';
import 'package:app_02/Flutter_Task_Manager_v1/View/TaskListItem.dart';
import 'package:app_02/Flutter_Task_Manager_v1/View/AddTaskScreen.dart';
import 'package:app_02/Flutter_Task_Manager_v1/View/EditTaskScreen.dart';
import 'package:app_02/Flutter_Task_Manager_v1/View/LoginScreen.dart';


class TaskListScreen extends StatefulWidget {
  final User user; // Người dùng hiện tại

  const TaskListScreen({Key? key, required this.user}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    setState(() {
      _tasksFuture = widget.user.isAdmin
          ? TaskDatabaseHelper.instance.getAllTasks()
          : TaskDatabaseHelper.instance.getTasksByUser(widget.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách công việc', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.cyan,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshTasks,
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có công việc nào.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final task = snapshot.data![index];
                return TaskListItem(
                  task: task,
                  onDelete: () async {
                    await TaskDatabaseHelper.instance.deleteTask(task.id!);
                    _refreshTasks();
                  },
                  onEdit: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskScreen(task: task),
                      ),
                    );
                    if (updated == true) {
                      _refreshTasks();
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_task),
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(user: widget.user),
            ),
          );
          if (created == true) {
            _refreshTasks();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
        BottomNavigationBarItem(icon: Icon(Icons.filter_list), label: "Cá nhân"),
      ]),
    );
  }
}
