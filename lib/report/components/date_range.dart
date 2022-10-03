import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/button.dart';

class ReportDateRange extends StatefulWidget {
  final Function(DateTimeRange?) onRange;
  final Function(DateTimeRange?) onExport;
  final DateTimeRange dateRange;

  const ReportDateRange({
    Key? key,
    required this.onRange,
    required this.onExport,
    required this.dateRange,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReportDateRange> {
  var error = '';
  var loading = false;
  DateTimeRange? date;

  @override
  void initState() {
    date = widget.dateRange;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              _getToday(date),
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          outlineButton(onPressed: _chooseDateRange, title: 'Change'),
          // outlineButton(onPressed: _exportData, title: 'Export'),
        ],
      ),
    );
  }

  _chooseDateRange() {
    showDateRangePicker(
      context: context,
      // initialDate: date,
      initialDateRange: date,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          date = value;
        });
        widget.onRange(date);
      }
    });
  }

  String _getToday(DateTimeRange? date) {
    if (date == null) return '';
    var startDate = date.start;
    var endDate = date.end;
    var dateFormat = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
    return '${dateFormat.format(startDate)}  -  ${dateFormat.format(endDate)}';
  }

  _exportData() => widget.onExport(date);
}
