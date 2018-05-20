
import 'package:intl/intl.dart';

String converterData(String dataTotal) {
  var formatter = new DateFormat('dd-MM-yyyy');
  return formatter.format(DateTime.parse(dataTotal)).toString();
}
