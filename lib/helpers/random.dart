import 'dart:io';

import 'package:intl/intl.dart';

Future<bool> checkForInternet() async {
  var boolean = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      boolean = true;
    }
    return boolean;
  } on SocketException catch (_) {
    return boolean;
  } catch (e) {
    return boolean;
  }
}

formatNumber(numberToFormat) {
  var formatter = NumberFormat("#,###,000");
  try {
    final finalFormatedStock = formatter.format(double.parse(numberToFormat));
    return finalFormatedStock;
  } catch (e) {
    return "Error Formatting";
  }
}
