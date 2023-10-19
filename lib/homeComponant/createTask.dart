import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:productivity_app/env.dart';
import 'package:http/http.dart' as http;

class CreateTaskPage extends StatefulWidget {
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  List<String> selectedDayOfWeeks = [];
  String selectedScheduleType = "daily"; // Default value
  String selectedDayOfWeek = "Sunday"; // Default value for weekly
  String selectedDayOfMonth = "1"; // Default value for monthly
  DateTime selectDate=DateTime.now();
  String selectedDateText = ""; // To display selected date
  DateTime selectedDate = DateTime.now(); // To store the selected date

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


  Future<void> createTask(String title, String subTitle) async {
    print("creating...");
    final obj = {
      "userId": "652c466d743c4b3b92204504",
      "title": title,
      "subTitle": subTitle,
      "status": false,
      "scheduleType": selectedScheduleType,
      "dayOfWeek": selectedDayOfWeeks, // Add selected day for weekly
      "dayOfMonth": selectedDayOfMonth, // Add selected day for monthly
      "selectedDateText": selectedDateText
    };
      final response = await http.post(Uri.parse('$api/api/v1/task/createTask'),
          body: jsonEncode(obj),
          headers: {'Content-Type': 'application/json'});
      print(response.body);

      if (response.statusCode == 200) {
        // Task created successfully
      } else {
        print("object");
        throw Exception('Failed to create the task');
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: subTitleController,
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
              items: <String>['none','daily', 'weekly', 'monthly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            //weekly scaduling
            if(selectedScheduleType=="weekly")
            Stack(
              children: [
                // Text("Select Days of the Week:"),
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
              child: Text('choose  starting date'),
            ),

            // Display selected date
            Text(selectedDateText),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final subTitle = subTitleController.text;

                if (title.isNotEmpty && subTitle.isNotEmpty) {
                  createTask(title, subTitle);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill out all fields.'),
                  ));
                }
              },
              child: Text('Create Task'),
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
