import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productivity_app/env.dart';
import 'package:productivity_app/model/task.dart';

class FetchHabit extends StatefulWidget {
  const FetchHabit({Key? key, required this.date1});

  // according to date fetch that day schedule
  final DateTime date1;

  @override
  State<FetchHabit> createState() => _FetchHabitState(date1: date1);
}

class _FetchHabitState extends State<FetchHabit> {
  DateTime date1;


  _FetchHabitState({required this.date1});

  Future<List<TaskData>> fetchTaskData() async {
    final obj = {
      "userId": "652c466d743c4b3b92204504",
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
      bool data11 = jsonDecode(response.body)['again'];

      if(data11){
        await fetchTaskData();
        setState(() {

        });
      }

      print("pppppppppppppppppppppppppppp $data11");
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
        print("----------------------------------- ${t.status.length}  ${t.title}");
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
  }

  @override
  void initState() {
    super.initState();

    fetchTaskData().then((taskDataList) {
      setState(() {
        print(" at in :---=============$taskDataList");
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
                      Checkbox(
                        hoverColor: Colors.blue,
                        value: taskData.status.isNotEmpty
                            ? taskData.status.last.done
                            : false,
                        onChanged: (bool? value) {
                          print("oooooooooooooooooooooooooooooooooooooooooo ${taskData.status}");
                          setState(() {
                            updateTaskStatus(
                                taskData.id,
                                value ?? false,
                                DateTime.now()); // You can pass the current date here
                          });
                        },
                      ),
                      // Bell icon
                      Expanded(
                        child: Container(
                          // Text for habit description
                          child: Row(
                            children: [
                              Icon(Icons.notifications),
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
                                  } else if (choice == "delete") {
                                    // Handle delete action
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
