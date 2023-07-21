import 'package:flutter/material.dart';
import 'package:seikowall_frontend/config.dart';
import 'package:seikowall_frontend/models/task_model.dart';
import 'package:seikowall_frontend/services/api_services.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class TaskAddEdit extends StatefulWidget {
  const TaskAddEdit({Key? key}) : super(key: key);

  @override
  _TaskAddEditState createState() => _TaskAddEditState();
}

class _TaskAddEditState extends State<TaskAddEdit> {
  TaskModel? taskModel;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  bool isEditMode = false;

  String radioButtonItem = '';
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              isEditMode ? const Text('Task Update') : const Text('New Task'),
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: taskForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    taskModel = TaskModel();

    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        taskModel = arguments['model'];
        isEditMode = true;
        radioButtonItem = taskModel!.taskStatus.toString();
        if (radioButtonItem == "PASS") {
          id = 1;
        } else {
          if (radioButtonItem == "FAIL") {
            id = 2;
          } else {
            if (radioButtonItem == "REWORK") {
              id = 4;
            } else {
              if (radioButtonItem == "N/A") {
                id = 3;
              } else {
                id = 0;
              }
            }
          }
        }
        setState(() {});
      }
    });
  }

  Widget taskForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(context, "TaskQC", "Task QC",
                (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Task QC can\'t be empty.';
              }
              return null;
            },
                (onSavedVal) => {
                      taskModel!.taskQC = onSavedVal,
                    },
                initialValue: taskModel?.taskQC ?? "",
                obscureText: false,
                borderFocusColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(0.5),
                borderRadius: 10,
                showPrefixIcon: false,
                // isMultiline: true,
                maxLength: 300),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
                context, "Task Item/Activity", "Task Item/Activity",
                (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Task Item/Activity can\'t be empty.';
              }
              return null;
            },
                (onSavedVal) => {
                      taskModel!.taskActivity = onSavedVal.replaceAll("\n", ""),
                    },
                initialValue: taskModel?.taskActivity ?? "",
                obscureText: false,
                borderFocusColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(0.5),
                borderRadius: 10,
                showPrefixIcon: false,
                isMultiline: true,
                maxLength: 300),
          ),
          const SizedBox(
            height: 20,
          ),

          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
                context, "TaskCriteria", "Task Criteria", (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Task Criteria can\'t be empty.';
              }
              return null;
            },
                (onSavedVal) => {
                      taskModel!.taskCriteria = onSavedVal.replaceAll("\n", ""),
                    },
                initialValue: taskModel?.taskCriteria ?? "",
                obscureText: false,
                borderFocusColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(0.5),
                borderRadius: 10,
                showPrefixIcon: false,
                isMultiline: true,
                maxLength: 300),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
                context, "Task Remark", "Task Remark", (onValidateVal) {
              // if (onValidateVal.isEmpty) {
              //   return 'Task Remark can\'t be empty.';
              // }
              return null;
            },
                (onSavedVal) => {
                      taskModel!.taskRemark = onSavedVal.replaceAll("\n", ""),
                    },
                initialValue: taskModel?.taskRemark ?? "",
                obscureText: false,
                borderFocusColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.black,
                hintColor: Colors.black.withOpacity(0.5),
                borderRadius: 10,
                showPrefixIcon: false,
                isMultiline: true,
                maxLength: 500),
          ),

          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 1,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    radioButtonItem = 'PASS';
                    id = 1;
                    taskModel!.taskStatus = radioButtonItem;
                  });
                },
              ),
              const Text(
                'PASS',
                style: TextStyle(fontSize: 17.0),
              ),
              Radio(
                value: 2,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    radioButtonItem = 'FAIL';
                    id = 2;
                    taskModel!.taskStatus = radioButtonItem;
                  });
                },
              ),
              const Text(
                'FAIL',
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
              Radio(
                value: 3,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    radioButtonItem = 'N/A';
                    id = 3;
                    taskModel!.taskStatus = radioButtonItem;
                  });
                },
              ),
              const Text(
                'N/A',
                style: TextStyle(fontSize: 17.0),
              ),
              Radio(
                value: 4,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    radioButtonItem = 'REWORK';
                    id = 4;
                    taskModel!.taskStatus = radioButtonItem;
                  });
                },
              ),
              const Text(
                'REWORK',
                style: TextStyle(fontSize: 17.0),
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     bottom: 10,
          //     top: 10,
          //   ),
          //   child: FormHelper.inputFieldWidget(
          //     context,
          //     //const Icon(Icons.person),
          //     "TaskStatus",
          //     "Task Status",
          //     (onValidateVal) {
          //       if (onValidateVal.isEmpty) {
          //         return 'Task Status can\'t be empty.';
          //       }
          //       return null;
          //     },
          //     (onSavedVal) => {
          //       taskModel!.taskStatus = onSavedVal,
          //     },
          //     initialValue: taskModel?.taskStatus ?? "",
          //     obscureText: false,
          //     borderFocusColor: Colors.black,
          //     borderColor: Colors.black,
          //     textColor: Colors.black,
          //     hintColor: Colors.black.withOpacity(0.7),
          //     borderRadius: 10,
          //     showPrefixIcon: false,
          //   ),
          // ),

          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Save",
              () {
                if (validateAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
                  });
                  APIService.saveTask(taskModel!, isEditMode).then(
                    (response) {
                      setState(() {
                        isApiCallProcess = false;
                      });
                      if (response) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      } else {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "Error occur",
                          "OK",
                          () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    },
                  );
                }
              },
              btnColor: Colors.red,
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 10,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
