import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seikowall_frontend/models/task_model.dart';

import '../config.dart';

class APIService {
  static var client = http.Client();

  static Future<List<TaskModel>?> getTasks() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.tasksAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return tasksFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<bool> saveTask(
    TaskModel model,
    bool isEditMode,
  ) async {
    var taskURL = Config.tasksAPI;

    if (isEditMode) {
      taskURL = taskURL + "/" + model.id.toString();
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, taskURL);

    // var requestMethod = isEditMode ? "PUT" : "POST";
    // var request = http.MultipartRequest(requestMethod, url);
    // request.fields["taskQC"] = model.taskQC!;
    // request.fields["taskActivi ty"] = model.taskActivity!;
    // request.fields["taskStatus"] = model.taskStatus!;
    // request.fields["taskCriteria"] = model.taskCriteria!;

    //var response = await request.send();

    TaskModel task = TaskModel(
        taskActivity: model.taskActivity,
        taskCriteria: model.taskCriteria,
        taskQC: model.taskQC,
        taskStatus: model.taskStatus,
        taskRemark: model.taskRemark);

    http.Response response = isEditMode
        ? await client.put(url,
            headers: requestHeaders, body: json.encode(task.toJson()))
        : await client.post(url,
            headers: requestHeaders, body: json.encode(task.toJson()));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteTask(taskId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.tasksAPI + "/" + taskId,
    );

    var response = await client.delete(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
