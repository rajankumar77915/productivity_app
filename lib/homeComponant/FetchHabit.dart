import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FetchHabit extends StatefulWidget {
  const FetchHabit({super.key, required this.date1});

  //according to date fetch that day schedule
  final int date1;

  @override
  State<FetchHabit> createState() => _FetchHabitState(date1: date1);
}

class _FetchHabitState extends State<FetchHabit> {
  final int date1;
  bool isChecked = false;

  _FetchHabitState({required this.date1});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // Change background color based on isChecked
          height: 50,
          child: Row(
            children: [
              // Checkbox on the left
              Checkbox(
                hoverColor: Colors.blue,
                value: isChecked,
                onChanged: (bool? value) {
                  // This is where we update the state when the checkbox is tapped
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),

              // Bell icon
              Expanded(
                child: Container(
                  color: isChecked ? Colors.black12 : Colors.black26,

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
                            child: Text("My first habit", style: TextStyle(color: Colors.cyan,)),
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Finished",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
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
        ),
      ],
    );
  }
}
