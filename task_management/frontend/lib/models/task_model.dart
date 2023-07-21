List<TaskModel> tasksFromJson(dynamic str) =>
    List<TaskModel>.from((str).map((x) => TaskModel.fromJson(x)));

class TaskModel {
  late String? id;
  late String? taskQC;
  late String? taskCriteria;
  late String? taskStatus;
  late String? taskActivity;
  late String? taskRemark;

  TaskModel(
      {this.id,
      this.taskQC,
      this.taskCriteria,
      this.taskStatus,
      this.taskActivity,
      this.taskRemark});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    taskQC = json['taskQC'];
    taskCriteria = json['taskCriteria'];
    taskActivity = json['taskActivity'];
    taskStatus = json['taskStatus'] ?? '';
    taskRemark = json['taskRemark'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['taskQC'] = taskQC;
    data['taskCriteria'] = taskCriteria;
    data['taskActivity'] = taskActivity;
    data['taskStatus'] = taskStatus;
    data['taskRemark'] = taskRemark;
    return data;
  }
}
