import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:routine_app/Collections/category.dart';
import 'package:routine_app/Collections/routine.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({super.key, required this.isar});

  final Isar isar;

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  List<Category> categories = [];
   Category? selectedCategory;

  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  String dropdownDay = 'Sunday';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _newCatController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  void initState() {
   _readCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
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
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: DropdownButton(
                      isExpanded: true,
                      // focusColor: Colors.cyan,
                      // dropdownColor: Colors.cyan,
                      value: selectedCategory,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: categories
                          .map<DropdownMenuItem<Category>>((Category nValue){
                        return DropdownMenuItem<Category>(
                          value: nValue,
                          child: Text(nValue.name),
                        );
                      }).toList(),
                      onChanged: (Category? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        }else{
                         print("Hello aalu ");
                        }

                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text("New Category"),
                            content: TextFormField(
                              controller: _newCatController,
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_newCatController.text.isNotEmpty) {
                                    _addCategory(widget.isar);
                                  }
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.add))
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
                width: MediaQuery.of(context).size.width * 0.7,
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
                    addRoutine();
                  },
                  child: const Text(
                    'Add',
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
        initialEntryMode: TimePickerEntryMode.dial);

    if (timeOfDay != null && timeOfDay != selectedTime) {
      selectedTime = timeOfDay;
      setState(() {
        _timeController.text =
            "${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.name}";
      });
    }
  }
// create Category Record
  void _addCategory(Isar isar) async {
    final categories = isar.categorys;
    final Category newCategory = Category()
      ..name = _newCatController.text;
    await isar.writeTxn(() async {
      await  categories.put(newCategory);
    });
    _newCatController.clear();
    _readCategory();
  }

  // Read Category
  void  _readCategory() async{
    final categoryCollections = widget.isar.categorys;
    final getCategories = await categoryCollections.where().findAll();
    setState(() {
      categories = getCategories;
    });
  }


  void addRoutine() async {
    final routine = widget.isar.routines;
    // Validate input fields
    String title = _titleController.text.trim();
    String startTime = _timeController.text;
    if (title.isEmpty || startTime.isEmpty || dropdownDay == null) {
      print("There is an Empty Or Null Value");
      return;
    } else if (selectedCategory == null) {
      print("Please select a category");
      return;
    } else {
      print('>>>>>>>>>>>>>>>> $selectedCategory');
      print('>>>>>>>>>>>>>>>> ${selectedCategory?.categoryId}');
      print('>>>>>>>>>>>>>>>> ${selectedCategory?.name}');
      final newRoutine = Routine()
        ..title = title
        ..startTime = startTime
        ..day = dropdownDay
        ..category.value = selectedCategory;

      await widget.isar.writeTxn(() async {
        await routine.put(newRoutine);
        await newRoutine.category.save();
      });
      print("Routine Add Successfully");
      _titleController.clear();
      _timeController.clear();
    }
  }


}
