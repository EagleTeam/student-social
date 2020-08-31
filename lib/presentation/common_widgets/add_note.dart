import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:studentsocial/presentation/screens/main/main_notifier.dart';

import '../../helpers/logging.dart';
import '../../models/entities/schedule.dart';

class AddNote extends StatefulWidget {
  const AddNote({this.date, this.context});

  final DateTime date;

  final BuildContext context;

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _date;

  //khai bao bien formkey de quan li,validate from them ghi chu
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //khai bao bien cho phan ghi chu
  String _title = '', _content = '';

  @override
  void initState() {
    super.initState();
    _date = widget.date;
  }

  /*
   * xu ly su kien khi bam them ghi chu
   */
  Future<void> _actionThemGhiChu() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      final Schedule note = Schedule.forNote(
          context.read(mainProvider).getMSV,
          _title == '' ? 'Tiêu đề' : _title,
          _content == '' ? 'Nội dung' : _content,
          dateFormat.format(_date));
      try {
        //TODO: Add note
//        String value = await PlatformChannel.database.invokeMethod(
//            PlatformChannel.addNote, <String, String>{'note': schedule});
//        print('add note :$value');
        context.read(mainProvider).loadCurrentMSV();
      } catch (e) {
        logs('add note: $e');
      }
      pop(context);
    }
  }

  /*
   * show picker time
   */
  Future<void> _pickerTime() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(9999));
    if (picked != null && picked != _date) {
      logs('date selected is ${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
  }

  /*
   * cac widget con
   */

  TextFormField _noteTitle() {
    return TextFormField(
      maxLines: 1,
      style: const TextStyle(fontWeight: FontWeight.bold),
      onSaved: (String value) => _title = value,
      decoration: const InputDecoration(
          hintText: 'Tiêu đề (không bắt buộc)',
          labelText: 'Tiêu đề (không bắt buộc)',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
    );
  }

  TextFormField _noteContent() {
    return TextFormField(
      maxLines: 2,
      onSaved: (String value) => _content = value,
      decoration: const InputDecoration(
          hintText: 'Nội dung (không bắt buộc)',
          labelText: 'Nội dung (không bắt buộc)',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
    );
  }

  Wrap _datePicker() {
    return Wrap(
      children: <Widget>[
        RaisedButton(
          onPressed: null,
          color: Colors.blue,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Text(
            dateFormat.format(_date),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        RaisedButton(
          onPressed: () {
            _pickerTime();
          },
          color: Colors.blue,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: const Text(
            'Chọn ngày',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm lịch cá nhân'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _noteTitle(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  _noteContent(),
                  const Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  _datePicker()
                ]),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            pop(context);
          },
          child: const Text(
            'Hủy bỏ',
            style: TextStyle(color: Colors.red),
          ),
        ),
        FlatButton(
          onPressed: _actionThemGhiChu,
          child: const Text('Thêm mới'),
        )
      ],
    );
  }
}
