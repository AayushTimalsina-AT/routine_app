import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:routine_app/Collections/category.dart';
import 'package:routine_app/Collections/routine.dart';

class UpdateRoutine extends StatefulWidget {
  final Isar isar;
  final Routine routine;

  const UpdateRoutine({super.key, required this.isar, required this.routine});

  // final Isar isar;
  // final Routine routine;

  @override
  State<UpdateRoutine> createState() => _UpdateRoutineState();
}

class _UpdateRoutineState extends State<UpdateRoutine> {
  List<Category>? categories;
  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  Category? dropdownValue;
  String dropdownDay = 'Sunday';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _newCatController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    _setRoutineInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Routine'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width *0.9,
                    child: DropdownButton(
                      isExpanded: true,
                      // focusColor: Colors.cyan,
                      // dropdownColor: Colors.cyan,
                      value: dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: categories
                          ?.map<DropdownMenuItem<Category>>((Category? nValue) {
                        print("Nvalue: $nValue");
                        return DropdownMenuItem<Category>(
                          value: nValue!,
                          child: Text(nValue.name),
                        );
                      }).toList(),
                      onChanged: (Category? newValue) {
                        if (newValue != null) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        }
                      },
                    ),
                  ),

                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Title",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              TextFormField(
                controller: _titleController,
                enabled: true,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Start Time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: _timeController,
                      enabled: false,

                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _selectedTime(context);
                    },
                    icon: const Icon(Icons.alarm),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Day",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: DropdownButton(
                    isExpanded: true,
                    value: dropdownDay,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: days.map<DropdownMenuItem<String>>((String day) {
                      return DropdownMenuItem<String>(
                          value: day, child: Text(day));
                    }).toList(),
                    onChanged: (String? newDay) {
                      setState(() {
                        dropdownDay = newDay!;
                      });
                    }),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // _addRoutine();
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _selectedTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null && timeOfDay != selectedTime) {
      selectedTime = timeOfDay;
      setState(() {
        _timeController.text =
        "${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.name}";
      });
    }
  }

  // Read Category
  _readCategory() async {
    final categoryCollections = widget.isar.categorys;
    if (categoryCollections != null) {
      final getCategories = await categoryCollections.where().findAll();
      setState(() {
        dropdownValue = null;
        categories = getCategories;
      });
    }
  }

  void _setRoutineInfo() async {
    await _readCategory();
    _titleController.text = widget.routine.title;
    _timeController.text = widget.routine.startTime;
    dropdownDay = widget.routine.day;

    if (widget.routine.category.value != null) {
      await widget.routine.category.load();
      int? getId = widget.routine.category.value!.categoryId ;
      print("moya error : $getId");
      setState(() {
        dropdownValue = categories?[getId! - 1];
      });
    }
  }
}