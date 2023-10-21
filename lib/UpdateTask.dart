import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productivity_app/env.dart';
import 'package:productivity_app/home.dart';

class UpdateTaskPage extends StatefulWidget {
  final user_id;
  final String taskId; // Pass the task ID of the task to be updated
  final String title;
  final String subtitle;
  final String selectedScheduleType;
  final List<String> selectedDayOfWeeks;
  UpdateTaskPage({required this.taskId,required this.title,required this.selectedScheduleType,required this.subtitle,required this.selectedDayOfWeeks, required this.user_id});

  @override
  _UpdateTaskPageState createState() => _UpdateTaskPageState(taskId: taskId,title: title,subtitle: subtitle,selectedScheduleType: selectedScheduleType,selectedDayOfWeeks: selectedDayOfWeeks);
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  //
  List<String> selectedDayOfWeeks;
  final String taskId; // Pass the task ID of the task to be updated
  final String title;
  final String subtitle;
  //
  String selectedScheduleType ;
  String selectedDayOfWeek = "Sunday"; // Default value for weekly
  String selectedDayOfMonth = "1"; // Default value for monthly
  DateTime selectDate = DateTime.now();
  String selectedDateText = ""; // To display selected date
  DateTime selectedDate = DateTime.now(); // To store the selected date
  _UpdateTaskPageState({required this.taskId,required this.title, required this.subtitle,required this.selectedScheduleType,required this.selectedDayOfWeeks});
  List<String> taskSuggestions = [
    "Complete Project",
    "Finish coding for the project",
    "Read a book",
    "Go for a run",
    "Finish coding for the project",
    "Read a book",
    "Go for a run1",
  ];

  void _openCalendar() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime(2024, 12, 31),
    );

    if (pickedDate != null) {
      // Store the selected date
      selectedDate = pickedDate;
      // Update the selected date text
      setState(() {
        selectedDateText = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> updateTask(String title, String subTitle) async {
    final obj = {
      "title": title,
      "subTitle": subTitle,
      "status": false,
      "scheduleType": selectedScheduleType,
      "dayOfWeek": selectedDayOfWeeks, // Add selected day for weekly
      "dayOfMonth": selectedDayOfMonth, // Add selected day for monthly
      "selectedDateText": selectedDateText,
    };
    final response = await http.put(
      Uri.parse('$api/api/v1/task/updateTaskall/${taskId}'), // Use the task ID for updating
      body: jsonEncode(obj),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);

    if (response.statusCode == 200) {
      // Task updated successfully
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(user_id: widget.user_id),
        ),
      );

    } else {
      throw Exception('Failed to update the task');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController..text= title,
              decoration: InputDecoration(labelText: 'Title'),

            ),
            TextField(
              controller: subTitleController..text=subtitle,
              decoration: InputDecoration(labelText: 'SubTitle'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedScheduleType,
              onChanged: (String? newValue) {
                setState(() {
                  selectedScheduleType = newValue!;
                });
              },
              items: <String>['none', 'daily', 'weekly', 'monthly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Weekly scheduling
            if (selectedScheduleType == "weekly")
              Stack(
                children: [
                  Wrap(
                    children: <Widget>[
                      for (String day in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'])
                        Column(
                          children: [
                            Text(day),
                            Checkbox(
                              value: selectedDayOfWeeks.contains(day),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedDayOfWeeks.add(day);
                                  } else {
                                    selectedDayOfWeeks.remove(day);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            if (selectedScheduleType == "monthly") // Show the dropdown for monthly
            // Show the dropdown for monthly
              DropdownButton<String>(
                value: selectedDayOfMonth,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDayOfMonth = newValue!;
                  });
                },
                items: List<String>.generate(12, (index) => (index + 1).toString())
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ElevatedButton(
              onPressed: _openCalendar,
              child: Text('Choose Starting Date'),
            ),
            // Display selected date
            Text(selectedDateText),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final subTitle = subTitleController.text;

                if (title.isNotEmpty && subTitle.isNotEmpty) {
                  updateTask(title, subTitle);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill out all fields.'),
                  ));
                }
              },
              child: Text('Update Task'),
            ),
            Text("Select a Task"),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: taskSuggestions.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        titleController.text = taskSuggestions[index];
                      },
                      title: Text(taskSuggestions[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
