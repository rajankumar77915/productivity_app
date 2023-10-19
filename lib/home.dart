import 'package:flutter/material.dart';
import 'package:productivity_app/homeComponant/FetchHabit.dart';
import 'package:productivity_app/homeComponant/createTask.dart';
import 'package:productivity_app/homeComponant/myDateList.dart';
import './const/Alldate.dart';
import 'package:intl/intl.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int appBarDay = DateTime.now().day;
  DateTime date1=DateTime.now();
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('$appBarDay'),
                
                Text('$formattedMonth')
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTaskPage()));
                  },
                  child: Text('Create Task'),
                ),
                // Text("om"),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [


            // Add  DateList widget below the x-axis labels.
            myDateList(
              myDate: myDate,
              appBarDay: appBarDay,
              onAppBarDayChanged: (newAppBarDate) {
                setState(() {
                  print("date changed");
                  date1=newAppBarDate;
                  appBarDay = date1.day;
                  formattedMonth = DateFormat.MMM().format(date1).toLowerCase();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Add a Text widget for the "ALL" label.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Add an Icon widget for the "ALL" label.
                    Icon(Icons.list),
                    Text("ALL"),

                    // Add an Icon widget for the "Morning" label.
                    Icon(Icons.sunny),
                    Text("Morning"),

                    // Add an Icon widget for the "Afternoon" label.
                    Icon(Icons.cloud),
                    Text("Afternoon"),

                    // Add an Icon widget for the "Evening" label.
                    Icon(Icons.nightlight),
                    Text("Evening"),
                  ],
                ),

              ],
            ),
            SizedBox(height: 10,),
            FetchHabit(date1: date1),

          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          // Add a BottomNavigationBarItem for Today.
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Today',
            // Add an onTap handler to the BottomNavigationBarItem.
            // onTap: () {
            //   // Navigate to the Today page.
            // },
          ),

          // Add a BottomNavigationBarItem for History.
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),

          // Add a BottomNavigationBarItem for Account.
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
