

  import 'package:intl/intl.dart';

String formatDate(String date){
    String formattedDate = DateFormat('EEE, dd MMM yyyy  HH:mm').format(DateTime.parse(date));
    return formattedDate;
  }