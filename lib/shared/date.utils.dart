toSqlDate(DateTime date) {
  int year = date.year;
  String month = (date.month).toString();
  String day = (date.day).toString();
  if (month.length == 1) {
    month = '0' + month;
  }
  if (day.length == 1) {
    day = '0' + day;
  }
  return year.toString() + '-' + month + '-' + day;
}
