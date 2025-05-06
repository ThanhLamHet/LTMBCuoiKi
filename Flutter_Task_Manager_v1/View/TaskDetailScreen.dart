import 'package:flutter/material.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/Task.dart';
import 'package:app_02/Flutter_Task_Manager_v1/db/UserDatabaseHelper.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  String? assignedUserName;

  @override
  void initState() {
    super.initState();
    _loadAssignedUser();
  }

  Future<void> _loadAssignedUser() async {
    if (widget.task.assignedTo != null && widget.task.assignedTo!.isNotEmpty) {
      final user = await UserDatabaseHelper.instance.getUserById(widget.task.assignedTo!);
      setState(() {
        assignedUserName = user?.username ?? 'Không xác định';
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin công việc'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildItem('Tiêu đề', task.title, fontSize: 24),
            _buildItem('Mô tả', task.description),
            _buildItem('Trạng thái', task.status),
            _buildItem('Độ ưu tiên', _priorityText(task.priority)),
            _buildItem('Người được giao', assignedUserName ?? 'Đang tải...'),
            _buildItem('Người tạo', task.createdBy),
            _buildItem('Ngày tạo', formatDate(task.createdAt)),
            _buildItem('Cập nhật lần cuối', formatDate(task.updatedAt)),
            _buildItem('Hạn chót', task.dueDate != null ? formatDate(task.dueDate!) : 'Chưa đặt'),
            _buildItem('Danh mục', task.category ?? 'Chưa đặt'),
            _buildItem('Tệp đính kèm', task.attachments?.join(', ') ?? 'Không có'),
            _buildItem('Trạng thái hoàn thành', task.completed ? '✔ Đã hoàn thành' : '✘ Chưa hoàn thành'),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value, {double fontSize = 18}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        '$label: $value',
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }

  String _priorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Thấp';
      case 2:
        return 'Trung bình';
      case 3:
        return 'Cao';
      default:
        return 'Không rõ';
    }
  }
}