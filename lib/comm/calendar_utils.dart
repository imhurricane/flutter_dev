import 'dart:collection';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/widget/calendar_view.dart';

typedef _onPressed = void Function(String value);
class CalendarPicker extends StatefulWidget {

  final double size;
  final _onPressed onPressed;

  CalendarPicker({
    this.size=50.0,
    this.onPressed,
  });
  @override
  _CalendarPickerState createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {

  bool _isMonthSelected = false;
  String _selectDate = DateUtil.formatDate(
      DateTime.now(), format: "yyyy-MM-dd");
  CalendarController controller;
  CalendarViewWidget calendar;
  HashSet<DateTime> _selectedDate = new HashSet();
  HashSet<DateModel> _selectedModels = new HashSet();
  GlobalKey<CalendarContainerState> _globalKey = new GlobalKey();


  @override
  void initState() {
    _selectedDate.add(DateTime.now());
    controller = CalendarController(
        minYear: 1977,
        minYearMonth: 1,
        maxYear: 2080,
        maxYearMonth: 12,
        showMode: CalendarConstants.MODE_SHOW_ONLY_MONTH,
        selectedDateTimeList: _selectedDate,
        selectMode: CalendarSelectedMode.singleSelect)
      ..addOnCalendarSelectListener((dateModel) {
        _selectedModels.add(dateModel);
        setState(() {
          _selectDate = _selectedModels.toString();
        });
      })
      ..addOnCalendarUnSelectListener((dateModel) {
        if (_selectedModels.contains(dateModel)) {
          _selectedModels.remove(dateModel);
        }
        setState(() {
          _selectDate = '';
        });
      });
    calendar = new CalendarViewWidget(
      key: _globalKey,
      calendarController: controller,
      dayWidgetBuilder: (DateModel model) {
        double wd = (MediaQuery
            .of(context)
            .size
            .width - 20) / 7;
        bool _isSelected = model.isSelected;
        if (_isSelected && CalendarSelectedMode.singleSelect ==
            controller.calendarConfiguration.selectMode) {
          _selectDate = DateUtil.formatDate(model.getDateTime());
          print('data11:' + DateUtil.formatDate(model.getDateTime()));
        }
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(wd / 2)),
          child: Container(
            color: _isSelected ? Theme
                .of(context)
                .focusColor : Colors.white,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  model.day.toString(),
                  style: TextStyle(
                      color: model.isCurrentMonth
                          ? (_isSelected == false
                          ? (model.isWeekend
                          ? Colors.black38
                          : Colors.black87)
                          : Colors.white)
                          : Colors.black38),
                ),
//              Text(model.lunarDay.toString()),
              ],
            ),
          ),
        );
      },
    );
//    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//      controller.addExpandChangeListener((value) {
//        /// 添加改变 月视图和 周视图的监听
//        _isMonthSelected = value;
//        setState(() {});
//      });
//    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  actionsPadding: const EdgeInsets.all(0.0),
                  contentPadding: const EdgeInsets.all(4.0),
                  title: Text('选择日期'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        calendar,
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('确定'),
                      onPressed: (){
//                        setState(() {
//
//                        });
                        widget.onPressed(_selectDate);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
        child: Container(
          height: 40,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            borderRadius:
            BorderRadius.all(Radius.circular(4.0)),
            //设置四周边框
            border:
            new Border.all(width: 0.5, color: Colors.grey),
          ),
          child: Text(
            DateUtil.formatDateStr(_selectDate,
                format: DateFormats.y_mo_d),
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ));
  }
}