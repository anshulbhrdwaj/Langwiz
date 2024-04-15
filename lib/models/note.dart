import 'package:isar/isar.dart';

//  this line is to generate the file that is required for database
//  command to build: dart run build_runner build
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String word;
  late String meaning;
  late String sentence;
} 