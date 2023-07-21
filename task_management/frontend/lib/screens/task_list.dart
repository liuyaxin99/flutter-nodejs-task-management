import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seikowall_frontend/models/task_model.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../services/api_services.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<TaskModel> tasks = List<TaskModel>.empty(growable: true);
  bool isApiCallProcess = false;
  final PageController pageController = PageController(initialPage: 0);
  late int _selectedIndex = 0;
  List<String> taskActivityList = [];
  List<String> taskQCList = [];
  List<TaskModel> tasksList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Checklist'),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add-task',
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                pageController.jumpToPage(index);
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.square_list),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                label: '',
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[
          // taskPage(),
          ProgressHUD(
            inAsyncCall: isApiCallProcess,
            opacity: 0.3,
            key: UniqueKey(),
            child: taskPage(),
          ),
          const Center(
              child: Text(
            'Profile Page',
            style: TextStyle(fontSize: 30),
          ))
        ],
      ),
    );
  }

  Widget taskPage() {
    return FutureBuilder(
      future: APIService.getTasks(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<TaskModel>?> model,
      ) {
        if (model.hasData) {
          tasksList = model.data!;
          taskActivityList = extractTaskActivities(model.data!);
          taskQCList = extractTaskQCs(model.data!);
          return loadTasks();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget loadTasks() {
    return ListView.builder(
      itemCount: taskQCList.length,
      itemBuilder: (BuildContext context, int taskQCIndex) {
        String qc = taskQCList[taskQCIndex];
        List<String> filteredActivities = taskActivityList
            .where((activity) => tasksList.any(
                (task) => task.taskQC == qc && task.taskActivity == activity))
            .toList();
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFe8e8e8),
                blurRadius: 5.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ExpansionTile(
            title: Text(qc),
            // trailing: Text(filteredActivities.length.toString()),
            children: [
              ListView.builder(
                // separatorBuilder: (context, index) {
                //   return const Divider(
                //     thickness: 3,
                //   );
                // },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: filteredActivities.length,
                itemBuilder: (BuildContext context, int activityIndex) {
                  String activity = filteredActivities[activityIndex];
                  List<TaskModel> filteredTasks = tasksList
                      .where((task) =>
                          task.taskQC == qc && task.taskActivity == activity)
                      .map((task) => task)
                      .toList();

                  List filteredTasksCriteria = tasksList
                      .where((task) =>
                          task.taskQC == qc && task.taskActivity == activity)
                      .map((task) => task.taskCriteria)
                      .toList();

                  return ListTile(
                    title: Text(activity),
                    subtitle: ListView.builder(
                      // separatorBuilder: (context, index) {
                      //   return const Divider();
                      // },
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: filteredTasksCriteria.length,
                      itemBuilder: (BuildContext context, int taskIndex) {
                        String criteria = filteredTasksCriteria[taskIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/edit-task',
                                    arguments: {
                                      'model': filteredTasks[taskIndex],
                                    },
                                  );
                                },
                                child: Card(
                                  child: ListTile(
                                    minLeadingWidth: 0,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    title: Text(criteria),
                                    leading: filteredTasks[taskIndex]
                                                .taskStatus ==
                                            "PASS"
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : filteredTasks[taskIndex].taskStatus ==
                                                "FAIL"
                                            ? const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              )
                                            : filteredTasks[taskIndex]
                                                        .taskStatus ==
                                                    "REWORK"
                                                ? const Icon(
                                                    Icons.warning,
                                                    color: Colors.yellow,
                                                  )
                                                : const Icon(
                                                    Icons.radio_button_checked,
                                                    color: Colors.grey,
                                                  ),
                                    trailing: SizedBox(
                                      width: 75,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          if (filteredTasks[taskIndex]
                                                  .taskRemark !=
                                              '')
                                            GestureDetector(
                                              child: const Icon(Icons.chat),
                                            ),
                                          // GestureDetector(
                                          //   child: const Icon(Icons.edit),
                                          //   onTap: () {
                                          //     Navigator.of(context).pushNamed(
                                          //       '/edit-task',
                                          //       arguments: {
                                          //         'model':
                                          //             filteredTasks[taskIndex],
                                          //       },
                                          //     );
                                          //   },
                                          // ),
                                          GestureDetector(
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onTap: () => showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Delete Task'),
                                                      content: const Text(
                                                          'Are you sure you want to delete this task?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context,
                                                                'Cancel');
                                                            setState(() {
                                                              isApiCallProcess =
                                                                  true;
                                                            });

                                                            APIService.deleteTask(
                                                                    filteredTasks[
                                                                            taskIndex]
                                                                        .id)
                                                                .then(
                                                              (response) {
                                                                setState(() {
                                                                  isApiCallProcess =
                                                                      false;
                                                                });
                                                              },
                                                            );
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> extractTaskActivities(List<TaskModel> jsonData) {
    for (var item in jsonData) {
      if (item.taskActivity != null) {
        String taskActivity = item.taskActivity.toString();
        if (!taskActivityList.contains(taskActivity)) {
          taskActivityList.add(taskActivity);
        }
      }
    }
    return taskActivityList;
  }

  List<String> extractTaskQCs(List<TaskModel> jsonData) {
    for (var item in jsonData) {
      if (item.taskQC != null) {
        String taskQC = item.taskQC.toString();
        if (!taskQCList.contains(taskQC)) {
          taskQCList.add(taskQC);
        }
      }
    }
    return taskQCList;
  }
}
