import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal/database.dart';
import 'dart:math';

class EditEntry extends StatefulWidget {
  final bool add;
  final int index;
  final JournalEdit journalEdit;

  const EditEntry(
      {Key? key,
      required this.add,
      required this.index,
      required this.journalEdit})
      : super(key: key);
  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  late JournalEdit _journalEdit;
  late String _title;
  late DateTime _selectedDate;
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _moodFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();

  @override
  void initState() {
    _journalEdit =
        JournalEdit(action: 'Cancel', journal: widget.journalEdit.journal);
    _title = widget.add ? 'Add' : 'Edit';
    _journalEdit.journal = widget.journalEdit.journal;
    if (widget.add) {
      _moodController.text = '';
      _noteController.text = '';
      _selectedDate = DateTime.now();
    } else {
      _moodController.text = _journalEdit.journal.mood;
      _noteController.text = _journalEdit.journal.note;
      _selectedDate = _journalEdit.journal.date as DateTime;
    }
  }

  @override
  dispose() {
    _moodFocus.dispose();
    _noteFocus.dispose();
    _noteController.dispose();
    _moodController.dispose();
    super.dispose();
  }

  Future<DateTime> selectDate(DateTime selectDate) async {
    DateTime _initialDate = _selectedDate;
    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (_pickedDate != null) {
      _selectedDate = DateTime(
          _pickedDate.year,
          _pickedDate.month,
          _pickedDate.day,
          _initialDate.hour,
          _initialDate.minute,
          _initialDate.second,
          _initialDate.millisecond,
          _initialDate.microsecond);
    }
    return _selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_title Entry'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.calendar_today,
                          size: 22.0,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          DateFormat.yMMMEd().format(_selectedDate),
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime _pickerDate = await selectDate(_selectedDate);
                    setState(() {
                      _selectedDate = _pickerDate;
                    });
                  }),
              TextField(
                  controller: _moodController,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  focusNode: _moodFocus,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Mood',
                    icon: Icon(Icons.mood),
                  ),
                  onSubmitted: (submitted) {
                    FocusScope.of(context).requestFocus(_noteFocus);
                  }),
              TextField(
                controller: _noteController,
                textInputAction: TextInputAction.next,
                focusNode: _noteFocus,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  icon: Icon(Icons.note),
                ),
                maxLines: null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () {
                      _journalEdit.action = 'Cancel';
                      Navigator.pop(context, _journalEdit);
                    },
                  ),
                  const SizedBox(width: 16.0),
                  TextButton(
                    child: const Text('Save'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    onPressed: () {
                      _journalEdit.action = 'Save';
                      String _id = widget.add
                          ? Random().nextInt(9999999).toString()
                          : _journalEdit.journal.id;
                      _journalEdit.journal = Journal(
                        id: _id,
                        date: _selectedDate.toString(),
                        mood: _moodController.text,
                        note: _noteController.text,
                      );
                      Navigator.pop(context, _journalEdit);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
