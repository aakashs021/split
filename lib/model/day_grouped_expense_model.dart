// ignore_for_file: public_member_api_docs, sort_constructors_first
class DayGroupedExpenseModel {
  DateTime dateTime;
  List<DateTime> datetimeList;
  List<String> description;
  List<int> paid;
  List<num> amount;
  DayGroupedExpenseModel({
    required this.dateTime,
    required this.datetimeList,
    required this.description,
    required this.paid,
    required this.amount,
  });
  
}
