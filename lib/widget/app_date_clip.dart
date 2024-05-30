import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///[date] parameter is required
///[color] parameter is optional default color code `8AD3D5`

class AppDateChip extends StatelessWidget {
  final DateTime date;
  final Color color;
  const AppDateChip({
    Key? key,
    required this.date,
    this.color = const Color(0x558AD3D5),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 7,
        bottom: 7,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.4),
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            style: TextStyle(
                color: Colors.black),
            Algo.dateChipText(date),
          ),
        ),
      ),
    );
  }
}

abstract class Algo {
  Algo._();

  static String dateChipText(final DateTime date) {
    final dateChipText = new DateChipText(date);
    return dateChipText.getText();
  }
}

///initial formatter to find the date txt
final DateFormat _formatter = DateFormat('yyyy-MM-dd');

///[DateChipText] class included with algorithms which are need to implement [DateChip]
///[date] parameter is required
///
class DateChipText {
  final DateTime date;

  DateChipText(this.date);

  ///generate and return [DateChip] string
  ///
  ///
  String getText() {
    final now = new DateTime.now();
    if (_formatter.format(now) == _formatter.format(date)) {
      return 'Today';
    } else if (_formatter
            .format(new DateTime(now.year, now.month, now.day - 1)) ==
        _formatter.format(date)) {
      return 'Yesterday';
    } else {
      return '${DateFormat('d').format(date)} ${DateFormat('MMMM').format(date)} ${DateFormat('y').format(date)}';
    }
  }
}
