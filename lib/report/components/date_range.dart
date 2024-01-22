import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/MenuContextAction.dart';

class ReportDateRange extends StatefulWidget {
  final Function(DateTimeRange?, String? period) onRange;
  final Function(DateTimeRange?) onExport;
  final DateTimeRange dateRange;

  const ReportDateRange({
    super.key,
    required this.onRange,
    required this.onExport,
    required this.dateRange,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReportDateRange> {
  var error = '';
  var loading = false;
  DateTimeRange? date;
  String period = 'day';

  @override
  void initState() {
    date = widget.dateRange;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _getToday(date),
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MenuContextAction(onPressed: _chooseDateRange, title: 'Change'),
              MenuContextAction(onPressed: _exportData, title: 'Export'),
              Container(
                width: 120,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonFormField<String>(
                  isDense: true,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      label: Text('Period'),
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent),
                  value: period,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'day',
                      child: Text('Day'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'month',
                      child: Text('Month'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'year',
                      child: Text('Year'),
                    ),
                  ],
                  onChanged: (value) {
                    period = value ?? 'day';
                    widget.onRange(date, period);
                  },
                ),
              )
            ],
          )
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
        date = value;
        widget.onRange(date, period);
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
