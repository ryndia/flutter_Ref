import 'package:path_provider/path_provider.dart'; // Filesystem locations
import 'dart:io'; // Used by File
import 'dart:convert'; // Used by json

class DatabaseFileRoutines {
  Future<String> get _localPath async {
    var temp = (await getApplicationDocumentsDirectory());
    String directory = temp.path;
    return directory;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/local_persistence.json');
  }

  Future<String> readJournals() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        print("file not exist: ${file.absolute}");
        await writeJournals('{"journals": []}');
      }

      String content = await file.readAsString();
      return content;
    } catch (e) {
      print('error read journals : $e');
      return "";
    }
  }

  Future<File> writeJournals(String json) async {
    final file = await _localFile;

    return file.writeAsString(json);
  }
}

Database databaseFromJson(String str) {
  final dataFromJson = json.decode(str);
  return Database.fromJson(dataFromJson);
}

String dataBaseToJson(Database data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

class Database {
  List<Journal> journal;

  Database({required this.journal});

  factory Database.fromJson(Map<String, dynamic> json) => Database(
        journal: List<Journal>.from(
            json["journals"].map((x) => Journal.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "journals": List<dynamic>.from(journal.map((x) => x.toJson())),
      };
}

class Journal {
  String id;
  String date;
  String mood;
  String note;

  Journal(
      {required this.id,
      required this.date,
      required this.mood,
      required this.note});

  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
        id: json["id"],
        date: json["date"],
        mood: json["mood"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "mood": mood,
        "note": note,
      };
}

class JournalEdit {
  String action;
  Journal journal;

  JournalEdit({required this.action, required this.journal});
}
