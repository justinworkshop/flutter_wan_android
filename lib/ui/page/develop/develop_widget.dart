import 'package:flutter/material.dart';

class DevelopWidget extends StatefulWidget {
  final name;

  DevelopWidget(this.name);

  @override
  _DevelopWidgetState createState() => _DevelopWidgetState();
}

class _DevelopWidgetState extends State<DevelopWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Offstage(
        offstage: false,
        child: _buildWidget(widget.name),
      ),
    );
  }

  Widget _buildWidget(String name) {
    DateTime _selectedDate = DateTime.now();

    switch (name) {
      case "TimePicker":
        return _buildTimePicker();
      case "DayPicker":
        return _buildDayPicker();
      case "MonthPicker":
        return _buildMonthPicker();
      case "YearPicker":
        return _buildYearPicker();
    }

    return Text(widget.name);
  }

  Widget _buildTimePicker() {
    return RaisedButton(
      onPressed: () async {
        var result = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());
        print('Pick time: $result');
      },
    );
  }

  Widget _buildDayPicker() {
    DateTime _selectedDate = DateTime.now();

    return DayPicker(
      selectedDate: _selectedDate,
      currentDate: DateTime.now(),
      onChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
      firstDate: DateTime(2020, 7, 1),
      lastDate: DateTime(2020, 7, 31),
      displayedMonth: DateTime(2020, 7),
    );
  }

  Widget _buildMonthPicker() {
    DateTime _selectedDate = DateTime.now();

    return MonthPicker(
      selectedDate: _selectedDate,
      onChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2020, 12),
    );
  }

  Widget _buildYearPicker() {
    DateTime _selectedDate = DateTime.now();

//    return YearPicker(
//      selectedDate: _selectedDate,
//      onChanged: (date) {
//        setState(() {
//          _selectedDate = date;
//        });
//      },
//      firstDate: DateTime(2000, 1),
//      lastDate: DateTime(2020, 12),
//    );

    return RaisedButton(
      onPressed: () async {
        var result = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        print('Pick date: $result');
      },
    );
  }
}
