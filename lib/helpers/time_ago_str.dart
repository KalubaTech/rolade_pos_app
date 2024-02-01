  import 'package:timeago/timeago.dart' as timeago;

  String timeagostr(String date, {required bool isSubstr}){

    String time = timeago.format(DateTime.parse(date));


    List<String> sTime = time.split(' ');
    String rTime = sTime.reduce((value, element) => (value+element[0]));

    return isSubstr?'${rTime.substring(0,rTime.length-1)}':time;
  }