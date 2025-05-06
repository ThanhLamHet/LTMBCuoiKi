import 'package:flutter/material.dart';
import 'package:app_02/Flutter_Task_Manager_v1/Model/Task.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskForm({Key? key, this.task, required this.onSave}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _attachmentsController;

  int _priority = 1;
  DateTime? _dueDate;
  bool _completed = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _categoryController = TextEditingController(text: widget.task?.category ?? '');
    _attachmentsController = TextEditingController(
      text: widget.task?.attachments?.join(', ') ?? '',
    );

    _priority = widget.task?.priority ?? 1;
    _dueDate = widget.task?.dueDate;
    _completed = widget.task?.completed ?? false;
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa công việc' : 'Thêm công việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
                maxLines: 3,
              ),

              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Độ ưu tiên'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('Thấp')),
                  DropdownMenuItem(value: 2, child: Text('Trung bình')),
                  DropdownMenuItem(value: 3, child: Text('Cao')),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _selectDueDate,
                child: Text(
                  _dueDate == null
                      ? 'Chọn hạn chót'
                      : 'Hạn chót: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                ),
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Danh mục'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _attachmentsController,
                decoration: InputDecoration(
                  labelText: 'Tệp đính kèm (phân tách bằng dấu phẩy)',
                ),
              ),
              CheckboxListTile(
                title: Text('Đã hoàn thành'),
                value: _completed,
                onChanged: (bool? value) {
                  setState(() {
                    _completed = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final task = Task(
                    id: isEditing
                        ? widget.task!.id
                        : DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    status: widget.task?.status ?? 'Pending',
                    priority: _priority,
                    assignedTo: widget.task?.assignedTo ?? '',
                    createdAt: widget.task?.createdAt ?? DateTime.now(),
                    updatedAt: DateTime.now(),
                    createdBy: widget.task?.createdBy ?? '',
                    completed: _completed,
                    dueDate: _dueDate,
                    category: _categoryController.text.trim().isNotEmpty
                        ? _categoryController.text.trim()
                        : null,
                    attachments: _attachmentsController.text.trim().isNotEmpty
                        ? _attachmentsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList()
                        : null,
                  );

                  widget.onSave(task);
                },
                child: Text(isEditing ? 'Lưu thay đổi' : 'Thêm công việc'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _attachmentsController.dispose();
    super.dispose();
  }
}