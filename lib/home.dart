import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/homeComponant/myDateList.dart';
import './const/Alldate.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int appBarDay = DateTime.now().day;
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
                Text("${DateFormat")
              ],
            ),
            Row(
              children: [
                Text("om"),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [

            /*call another page*/
            myDateList(
              myDate: myDate,
              appBarDay: appBarDay,
              onAppBarDayChanged: (newAppBarDay) {
                // setState(() {
                //   appBarDay = newAppBarDay; // Update appBarDay in the Home widget.
                // });
              },
            ),
            /*end call another page*/

            Text("data")
          ],
        ),
        )
    );
  }
}