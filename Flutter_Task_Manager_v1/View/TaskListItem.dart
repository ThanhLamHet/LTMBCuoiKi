import 'package:flutter/material.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/Task.dart'; // Import model Task
import 'TaskDetailScreen.dart'; // Import screen detail của task

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  TaskListItem({
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  Widget _buildPriorityIndicator(int priority) {
    Color color;
    String text;
    switch (priority) {
      case 1:
        color = Colors.green;
        text = 'Low';
        break;
      case 2:
        color = Colors.orange;
        text = 'Medium';
        break;
      case 3:
        color = Colors.redAccent;
        text = 'High';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(Icons.person, size: 16, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: _buildPriorityIndicator(task.priority),  // Gọi hàm hiển thị chỉ báo ưu tiên
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: task.completed ? TextDecoration.lineThrough : null,
            color: task.completed ? Colors.grey.shade600 : Colors.black,
          ),
        ),
        subtitle: Text(
          '${task.status} - ${task.assignedTo ?? "Unassigned"}',
          style: TextStyle(
            color: task.completed ? Colors.grey.shade600 : Colors.grey.shade800,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                task.completed ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                color: task.completed ? Colors.green : Colors.grey,
              ),
              onPressed: () {
                // Logic for marking task as complete
                print('Mark as completed: ${task.id}');
              },
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Confirm deletion
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text('Delete'),
                        onPressed: () {
                          onDelete();  // Call the delete function
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () {
          // Navigate to TaskDetailScreen when tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: task),
            ),
          );
        },
      ),
    );
  }
}
