import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productivity_app/UpdateTask.dart';
import 'package:productivity_app/env.dart';
import 'package:productivity_app/model/task.dart';


class FetchHabit extends StatefulWidget {
  const FetchHabit({Key? key, required this.date1, required this.user_id});

  // according to date fetch that day schedule
  final DateTime date1;
  final user_id;
  @override
  State<FetchHabit> createState() => _FetchHabitState(date1: date1,user_id: user_id);
}

class _FetchHabitState extends State<FetchHabit> {
  DateTime date1;
  bool data11=false;
  final user_id;

  _FetchHabitState({required this.date1,required this.user_id});

  Future<List<TaskData>> fetchTaskData() async {
    final obj = {
      "userId": user_id,
      "date1": widget.date1.toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('$api/api/v1/task/getTask'),
      body: jsonEncode(obj),
      headers: {'Content-Type': 'application/json'},
    );
    // print("status data is ..00000000000000000000000000000000000000000000000000........${response.body}");
    if (response.statusCode == 200) {
      List<TaskData> taskDataList=[];
      var  data = jsonDecode(response.body)['tasks'];
       data11 = jsonDecode(response.body)['again'];


      print("pppppppppppppppppppppppppppp $data11");
      if (data11) {
        fetchTaskData().then((taskDataList) {
          setState(() {
            this.taskList = taskDataList;
          });


        });
      }
      // if(data1?.isEmpty()){
      //   print("----------------------null---------------------");
      // }
      try {
      data.forEach((ele){
        List<TaskStatus> ts=[];
        try {

          try {
            for(int i=0;i<ele["status"].length;i++) {
              ts.add(TaskStatus(
                date: ele["status"][i]["date"],
                done: ele["status"][i]["done"],
                id: ele["status"][i]["_id"],
              ));
            }
            print("status is: ${ele["status"]}");
          } catch (e) {
            print("e r r $e");
          }
        } catch (e) {
          print("Outer error: $e");
        }

        TaskData t=TaskData(id: ele["_id"],
              title: ele["title"],
              subTitle: ele["subTitle"],
              dateTime: ele["dateTime"],
              status: ts,
              scheduleType: ele["scheduleType"],
              selectedDateText: ele["selectedDateText"],
              user: ele["user"]);
          taskDataList.add(t);
      });


      print("Success status 200: $data");

        return  taskDataList;
      }catch(error){
        print("eeeeeeeeeeerrrrrrrrrrrrrrrooooooooooorrrrrrrrrrrrrrrrrrrrrrrrrr $error");
      }
      return [];
    } else {
      throw Exception('Failed to fetch task data');
    }
  }


  Future<void> deleteTask(String taskId) async {
    final response = await http.delete(
      Uri.parse('$api/api/v1/task/deleteTask/$taskId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }

    // Remove the task from the local list of tasks
    setState(() {
      taskList.removeWhere((task) => task.id == taskId);
    });
  }

  Future<void> updateTaskStatus(String taskId, bool status, DateTime date) async {
    final obj = {
      "id": taskId,
      "status": status,
      "date": widget.date1.toIso8601String(),
    };

    final response = await http.put(
      Uri.parse('$api/api/v1/task/updateStatus'),
      body: jsonEncode(obj),
      headers: {'Content-Type': 'application/json'},
    );


    if (response.statusCode != 200) {
      throw Exception('Failed to update task status');
    }
    fetchTaskData();
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();


    fetchTaskData().then((taskDataList) {
      setState(() {
        this.taskList = taskDataList;
      });


    });


  }

  bool isChecked = false;
  List<TaskData> taskList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TaskData>>(
      future: fetchTaskData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: snapshot.data?.map((taskData) {
                return Container(
                  // Change background color based on status
                  height: 50,
                  color: taskData.status.isNotEmpty
                      ? (taskData.status.last.done
                      ? Colors.black12
                      : Colors.black26)
                      : Colors.black26,
                  child: Row(
                    children: [
                      // Checkbox on the left
                      ColoredBox(color: Colors.white54,
                      child:Checkbox(

                        activeColor: Colors.redAccent,
                        checkColor: Colors.white,
                        hoverColor: Colors.blue,

                        value: taskData.status.isNotEmpty
                            ? taskData.status.last.done
                            : false,
                        onChanged: (bool? value) {

                          setState(() {
                            updateTaskStatus(
                                taskData.id,
                                value ?? false,
                                DateTime.now()); // You can pass the current date here
                          });


                        },
                      ),
                ),
                      // Bell icon
                      Expanded(
                        child: Container(
                          // Text for habit description
                          child: Row(
                            children: [
                              Icon(Icons.notifications,color:Colors.cyan),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(taskData.title,
                                        style: TextStyle(color: Colors.cyan)),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      taskData.subTitle,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              PopupMenuButton(
                                color: Colors.white54,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text("Edit"),
                                      value: "edit",
                                    ),
                                    PopupMenuItem(
                                      child: Text("Delete"),
                                      value: "delete",
                                    ),
                                  ];
                                },
                                onSelected: (String choice) {
                                  if (choice == "edit") {
                                    // Handle edit action
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateTaskPage(taskId: taskData.id,title: taskData.title,subtitle: taskData.subTitle,selectedDayOfWeeks: [],selectedScheduleType:taskData.scheduleType   ,user_id: user_id),
                                      ),
                                    );
                                  } else if (choice == "delete") {
                                    // Handle delete action
                                    deleteTask(taskData.id);
                                  }
                                },

                        ),
                            ],
                          ),
                        ),
                      ),
                      // Three-dot icon on the right for CRUD operations
                    ],
                  ),
                );
              }).toList() ?? [], // Use an empty list as the default value if snapshot.data is null
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Failed to fetch task data'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
