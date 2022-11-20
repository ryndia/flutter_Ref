import 'package:flutter/material.dart';
import 'package:journal/database.dart';
import 'package:journal/entry.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Database _database;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Journal',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder(
          initialData: [],
          future: _loadJournal(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return !snapshot.hasData
                ? const Center(child: CircularProgressIndicator())
                : _buildListVIewSeperated(snapshot);
          }),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.all(24.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          tooltip: 'add Note',
          child: const Icon(Icons.add),
          onPressed: () {
            _addOrEditJournal(
                add: true,
                index: -1,
                journal: Journal(id: '', note: '', mood: '', date: ''));
          }),
    );
  }

  Future<List<Journal>> _loadJournal() async {
    await DatabaseFileRoutines().readJournals().then((journalsJson) {
      _database = databaseFromJson(journalsJson);
      _database.journal
          .sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
    });
    return _database.journal;
  }

  void _addOrEditJournal(
      {required bool add, required int index, required Journal journal}) async {
    JournalEdit _journalEdit = JournalEdit(action: '', journal: journal);
    _journalEdit = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEntry(
          add: add,
          index: index,
          journalEdit: _journalEdit,
        ),
        fullscreenDialog: true,
      ),
    );
    switch (_journalEdit.action) {
      case 'Save':
        if (add) {
          setState(() {
            _database.journal.add(_journalEdit.journal);
          });
        } else {
          setState(() {
            _database.journal[index] = _journalEdit.journal;
          });
        }
        DatabaseFileRoutines().writeJournals(dataBaseToJson(_database));
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  Widget _buildListVIewSeperated(AsyncSnapshot snapshot) {
    return ListView.separated(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          String _titleDate = DateFormat.yMMMd()
              .format(DateTime.parse(snapshot.data[index].date));
          String _subtitle =
              snapshot.data[index].mood + "\n" + snapshot.data[index].note;
          return Dismissible(
              key: Key(snapshot.data[index].id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  )),
              child: ListTile(
                leading: Column(
                  children: <Widget>[
                    Text(
                      DateFormat.d()
                          .format(DateTime.parse(snapshot.data[index].date)),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                        color: Colors.red,
                      ),
                    ),
                    Text(DateFormat.E()
                        .format(DateTime.parse(snapshot.data[index].date))),
                  ],
                ),
                title: Text(
                  _titleDate,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _subtitle,
                ),
                onTap: () {
                  _addOrEditJournal(
                    add: false,
                    index: index,
                    journal: snapshot.data[index],
                  );
                },
              ),
              onDismissed: (direction) {
                setState(() {
                  _database.journal.removeAt(index);
                  DatabaseFileRoutines()
                      .writeJournals(dataBaseToJson(_database));
                });
              });
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.grey,
          );
        });
  }
}
