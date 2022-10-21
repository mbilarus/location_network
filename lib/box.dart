import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

late Box box;
Future<void> initStorage() async {
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  box = await Hive.openBox('appBox');
}