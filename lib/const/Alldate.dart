List<DateTime> getDate(){
  DateTime currentDate = DateTime.now();
  DateTime nextYear = currentDate.add(Duration(days: 365));
   List<DateTime> date=[];
  while (currentDate.isBefore(nextYear)) {
    date.add(currentDate);
    currentDate = currentDate.add(Duration(days: 1));
  }

  return date;
}