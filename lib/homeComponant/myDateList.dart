import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class myDateList extends StatefulWidget {
  const myDateList({Key? key, required this.myDate, required this.appBarDay, required this.onAppBarDayChanged})
      : super(key: key);

  final List<DateTime> myDate;
  final int appBarDay;
  final ValueChanged<int> onAppBarDayChanged;

  @override
  State<myDateList> createState() => _myDateListState();
}

class _myDateListState extends State<myDateList> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.myDate.indexWhere((date) => date.day == widget.appBarDay);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: ListView.builder(
          itemCount: widget.myDate.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final date = widget.myDate[index];
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onAppBarDayChanged(date.day); // Call the callback function to update appBarDay value in the parent widget.
                print("Date item clicked: ${date.day}");
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(
                      "\n${DateFormat.E().format(date)}",
                      style: TextStyle(
                        fontSize: 20,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    Text(
                      "${date.day < 10 ? "0${date.day}" : "${date.day}"}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
