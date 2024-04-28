import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:routine_app/Collections/routine.dart';
import 'package:routine_app/widgets/Create_Routine.dart';
import 'package:routine_app/widgets/update_routine.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.isar});

  final Isar isar;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Routine>? routines;

  @override
  void initState() {
    // TODO: implement initState
    // _readRoutine();
    super.initState();
  }

   _readRoutine() async {
    final routineCollections = widget.isar.routines;
    final getRoutines = await routineCollections.where().findAll();
    setState(() {
      routines = getRoutines;
    });
  }

  Future<List<Widget>>_buildWidgets() async{
    await _readRoutine();
    List<Widget> x = [];
    if (routines != null) {
      for (int i = 0; i < routines!.length; i++) {
        x.add(
          Card(
            elevation: 4.0,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UpdateRoutine(
                                isar: widget.isar, routine: routines![i])));
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                    child: Text(
                      routines![i].title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                    child: RichText(
                      text: TextSpan(children: [
                        const WidgetSpan(
                          child: Icon(
                            Icons.schedule_sharp,
                            size: 16,
                          ),
                        ),
                        TextSpan(
                          text: routines![i].startTime,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                    child: RichText(
                      text: TextSpan(children: [
                        const WidgetSpan(
                          child: Icon(
                            Icons.calendar_month,
                            size: 16,
                          ),
                        ),
                        TextSpan(
                            text: routines![i].day,
                            style: const TextStyle(color: Colors.black)),
                      ]),
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.keyboard_arrow_right_sharp),
            ),
          ),
        );
      }
    }
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateRoutine(isar: widget.isar),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:FutureBuilder<List<Widget>>(
            future: _buildWidgets(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data!);
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }
}
