import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/Task.dart';
import 'package:app_02/Flutter_Task_Manager_v1/db/TaskDatabaseHelper.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/User.dart';

// Màn hình thêm công việc
class AddTaskScreen extends StatefulWidget {
  final User user; // Người dùng hiện tại (được truyền vào khi mở màn hình)

  const AddTaskScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

// Lớp quản lý trạng thái của màn hình thêm công việc
class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>(); // Khóa để quản lý trạng thái của form

  // Các TextEditingController để điều khiển các trường nhập liệu
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _attachmentsController = TextEditingController();

  int _priority = 1; // Độ ưu tiên mặc định là 1 (Thấp)
  DateTime? _dueDate; // Ngày hết hạn (mặc định là null)

  // Hàm chọn ngày hết hạn
  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)), // Mặc định chọn ngày mai
      firstDate: DateTime.now(), // Ngày bắt đầu từ hôm nay
      lastDate: DateTime(2100), // Ngày kết thúc là 2100
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked; // Cập nhật ngày hết hạn khi người dùng chọn
      });
    }
  }

  // Hàm thêm công việc mới
  Future<void> _addTask() async {
    if (!_formKey.currentState!.validate()) return; // Kiểm tra tính hợp lệ của form

    // Tạo một đối tượng Task mới với các giá trị từ form
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      status: 'Pending',
      priority: _priority,
      assignedTo: widget.user.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: widget.user.username,
      completed: false,
      dueDate: _dueDate,
      category: _categoryController.text.trim().isNotEmpty
          ? _categoryController.text.trim()
          : null,
      attachments: _attachmentsController.text.trim().isNotEmpty
          ? _attachmentsController.text.split(',').map((e) => e.trim()).toList()
          : null,
    );

    try {
      await TaskDatabaseHelper.instance.insertTask(newTask);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi thêm công việc: $e'), // Hiển thị lỗi nếu có
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Hàm build giao diện của màn hình
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm công việc'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Gán GlobalKey cho form để quản lý trạng thái
          child: SingleChildScrollView(
            child: Column(
              children: [

                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Nhập tiêu đề' : null,
                ),
                SizedBox(height: 10),

                // Trường nhập Mô tả
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Mô tả',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3, // Cho phép nhập nhiều dòng
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Danh mục',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Trường nhập Tệp đính kèm
                TextFormField(
                  controller: _attachmentsController,
                  decoration: InputDecoration(
                    labelText: 'Tệp đính kèm (ngăn cách bởi dấu phẩy)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Hiển thị và chọn ngày hết hạn
                Row(
                  children: [
                    Text('Hạn chót: '),
                    Text(
                      _dueDate != null
                          ? DateFormat('dd/MM/yyyy').format(_dueDate!)
                          : 'Chưa chọn', // Hiển thị ngày hoặc thông báo chưa chọn
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: _pickDueDate, // Mở lịch để chọn ngày
                      child: Text('Chọn ngày'),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Chọn Độ ưu tiên
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Độ ưu tiên',
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _priority, // Giá trị hiện tại của độ ưu tiên
                      items: [
                        DropdownMenuItem(value: 1, child: Text('Thấp')),
                        DropdownMenuItem(value: 2, child: Text('Trung bình')),
                        DropdownMenuItem(value: 3, child: Text('Cao')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _priority = value!; // Cập nhật độ ưu tiên khi thay đổi
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Nút Lưu để thêm công việc
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Lưu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
