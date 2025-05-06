import 'package:flutter/material.dart';
import 'package:app_02/Flutter_Task_Manager_v1/db/TaskDatabaseHelper.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/Task.dart';
import 'TaskForm.dart';

// Màn hình chỉnh sửa công việc
class EditTaskScreen extends StatelessWidget {
  final Task task; // Công việc cần chỉnh sửa, được truyền vào khi mở màn hình

  // Constructor nhận công việc cần chỉnh sửa từ màn hình trước đó
  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Màn hình sẽ sử dụng lại form TaskForm để chỉnh sửa công việc
    return TaskForm(
      task: task, // Truyền công việc hiện tại vào form để chỉnh sửa
      onSave: (Task updatedTask) async {
        // Hàm gọi khi người dùng lưu lại công việc đã chỉnh sửa
        try {
          await TaskDatabaseHelper.instance.updateTask(updatedTask);

          // Quay lại màn hình trước và thông báo cập nhật thành công
          Navigator.pop(context, true);

          // Hiển thị thông báo cập nhật thành công
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật công việc thành công'), // Nội dung thông báo
              backgroundColor: Colors.green, // Màu nền của thông báo
            ),
          );
        } catch (e) {
          // Nếu có lỗi khi cập nhật, quay lại màn hình trước với trạng thái thất bại
          Navigator.pop(context, false);

          // Hiển thị thông báo lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi cập nhật công việc: $e'), // Nội dung lỗi
              backgroundColor: Colors.red, // Màu nền của thông báo lỗi
            ),
          );
        }
      },
    );
  }
}
