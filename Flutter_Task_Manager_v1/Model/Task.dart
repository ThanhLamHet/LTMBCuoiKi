class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final int priority;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final bool completed;
  final DateTime? dueDate; // Hạn hoàn thành
  final String? category; // Phân loại công việc
  final List<String>? attachments; // Danh sách link tài liệu đính kèm

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.assignedTo, // Cập nhật ở đây
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.completed,
    this.dueDate,
    this.category,
    this.attachments,
  });

  // Convert Task to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'assignedTo': assignedTo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'completed': completed ? 1 : 0,
      'dueDate': dueDate?.toIso8601String(),
      'category': category,
      'attachments': attachments?.join(','),
    };
  }

  // Convert Map to Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'].toString(),
      title: map['title'],
      description: map['description'],
      status: map['status'],
      priority: map['priority'],
      assignedTo: map['assignedTo'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      createdBy: map['createdBy'],
      completed: map['completed'] == 1,
      dueDate: map['dueDate'] != null ? DateTime.tryParse(map['dueDate']) : null,
      category: map['category'],
      attachments: map['attachments'] != null
          ? map['attachments'].split(',')
          : null,
    );
  }
}
