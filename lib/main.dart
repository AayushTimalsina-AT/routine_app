import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:routine_app/Collections/category.dart';
import 'package:routine_app/Collections/routine.dart';
import 'package:path_provider/path_provider.dart';
import 'package:routine_app/home.dart';

import 'Theme/DarkTheme.dart';
import 'Theme/LightTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  final isar = await Isar.open([
    CategorySchema,
    RoutineSchema,
  ], directory: dir.path);
  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: DarkAppTheme().darkTheme,
      theme: AppTheme().lightTheme,
      themeMode: ThemeMode.system,
      //Default
      home:  Home(isar: isar),
    );
  }
}
// ElevatedButton(
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => UpdateRoutineScreen(isar: isar),
// ),
// );
// },
// child: Text('Go to Update Routine'),
// ),