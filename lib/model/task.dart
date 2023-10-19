class TaskData {
  final String id;
  final String title;
  final String subTitle;
  final String dateTime;
  final List<TaskStatus> status;
  final String ? scheduleType;
  // final List<String> ?dayOfWeek;
  // final String dayOfMonth;
  final String ?selectedDateText;
  final String user;

  TaskData({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.dateTime,
    required this.status,
     this.scheduleType,
    //  this.dayOfWeek,
    // required this.dayOfMonth,
     this.selectedDateText,
    required this.user,
  });


  }


class TaskStatus {
  final String ? date;
  final bool done;
  final String ?id;

  TaskStatus({ this.date, required this.done, this.id});


}