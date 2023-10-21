import 'package:flutter/material.dart';
import 'package:productivity_app/chart/chart.dart';
import 'package:productivity_app/homeComponant/FetchHabit.dart';
import 'package:productivity_app/homeComponant/createTask.dart';
import 'package:productivity_app/homeComponant/myDateList.dart';
import 'package:productivity_app/model/task.dart';
import 'package:productivity_app/profile.dart';
import './const/Alldate.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key,required this.user_id});
  final user_id;

  @override
  State<Home> createState() => _HomeState(user_id: user_id);
}

class _HomeState extends State<Home> {
  final user_id;
  _HomeState({required this.user_id});
  int appBarDay = DateTime.now().day;
  DateTime date1 = DateTime.now();
  // Format the month as 'jan', 'feb', etc.
  String formattedMonth = DateFormat.MMM().format(DateTime.now()).toLowerCase();
  List<DateTime> myDate = getDate();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(myDate);
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('$appBarDay'),
                Text('$formattedMonth'),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateTaskPage(user_id:user_id)));
                  },
                  child: Text('Create Task'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Add DateList widget below the x-axis labels.
          myDateList(
            myDate: myDate,
            appBarDay: appBarDay,
            onAppBarDayChanged: (newAppBarDate) {
              setState(() {
                print("date changed");
                date1 = newAppBarDate;
                appBarDay = date1.day;
                formattedMonth = DateFormat.MMM().format(date1).toLowerCase();
              });
            },
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Add a Text widget for the "ALL" label.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Add an Icon widget for the "ALL" label.
                  Icon(Icons.list,color: Colors.redAccent),
                  Text(
                    "ALL",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),

                  // Add an Icon widget for the "Morning" label.
                  Icon(Icons.sunny,color: Colors.amber),
                  Text(
                    "Morning",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),

                  // Add an Icon widget for the "Afternoon" label.
                  Icon(Icons.cloud,color: Colors.white),
                  Text(
                    "Afternoon",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),

                  // Add an Icon widget for the "Evening" label.
                  Icon(Icons.nightlight,color: Colors.redAccent),
                  Text(
                    "Evening",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          FetchHabit(date1: date1,user_id: user_id),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          // Add a BottomNavigationBarItem for Today.
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Today',
          ),

          // Add a BottomNavigationBarItem for History.


          // Add a BottomNavigationBarItem for Account.
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current tab index.
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PomodoroTimer()),
            );
          }
        },
      ),
      backgroundColor: Colors.black12,
    );
  }
}
