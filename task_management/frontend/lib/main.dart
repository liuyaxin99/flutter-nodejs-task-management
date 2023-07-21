import 'package:flutter/material.dart';
import 'package:seikowall_frontend/screens/task_add_edit.dart';
import 'package:seikowall_frontend/screens/task_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Production QC Checklist ',
      routes: {
        '/': (context) => const TaskList(),
        '/add-task': (context) => const TaskAddEdit(),
        '/edit-task': (context) => const TaskAddEdit(),
      },
    );
  }
}
