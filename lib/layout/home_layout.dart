import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:udemy_app/modules/archived_tasks/archivedTasksScreen.dart';
import 'package:udemy_app/modules/done_tasks/doneTasksScreen.dart';
import 'package:udemy_app/modules/new_tasks/newTasksScreen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_app/shared/components/components.dart';
import 'package:udemy_app/shared/components/constants.dart';

class homeLayout extends StatefulWidget {
  const homeLayout({Key key}) : super(key: key);

  @override
  State<homeLayout> createState() => _homeLayoutState();
}

class _homeLayoutState extends State<homeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [
    newTasksScreen(),
    archivedTasksScreen(),
    doneTasksScreen(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  var scaffoldkey = GlobalKey<ScaffoldState>();
  Database dataBase;
  bool isBottomShowing = false;
  IconData iconFla = Icons.edit;
  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  //var formkey = GlobalKey<FormFieldState>();
  // المفروض تبقي <FormState> مش >FormFieldState> زي م انتي عامله فوق
  var formkey = GlobalKey<FormState>();

  @override
  void initState() {
    createDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      body: ConditionalBuilder(
        condition: tasks.length > 0,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
        fallback: (context) => screens[currentIndex],
      ),
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // شيلت الجزء اللي تحت اللي عامل عليه الكومنت
          // insertToDatabase(
          //   date: datecontroller.text,
          //   time: timecontroller.text,
          //   title: titlecontroller.text,
          // );
          if (isBottomShowing) {
            if (formkey.currentState.validate()) {
              insertToDatabase(
                // مكنتيش ضايفه ال title و time و date
                title: titlecontroller.text,
                time: timecontroller.text,
                date: datecontroller.text,
              ).then((value) {
                getDataFromDB(dataBase).then((value) {
                  setState(() {
                    isBottomShowing = false;
                    //شيلت السطر اللي تحت ده
                    //iconFla = Icons.edit;
                    tasks = value;
                    print(tasks);
                  });
                });
              });
              Navigator.pop(context);
            }
          } else {
            setState(() {
              iconFla = Icons.add;
            });
            scaffoldkey.currentState
                .showBottomSheet(
                  (context) => Container(
                    padding: const EdgeInsets.all(20.0),
                    color: Colors.grey[200],
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultTextFormField(
                              controller: titlecontroller,
                              label: 'title task',
                              prefix: Icons.title,
                              type: TextInputType.text,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'title must not be empty';
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultTextFormField(
                              controller: timecontroller,
                              label: 'time task',
                              prefix: Icons.watch_later_outlined,
                              type: TextInputType.datetime,
                              // isClickable: false,
                              tap: () {
                                showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timecontroller.text =
                                      value.format(context).toString();
                                });
                              },
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'title must not be empty';
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultTextFormField(
                              controller: datecontroller,
                              label: 'date task',
                              prefix: Icons.calendar_today_sharp,
                              type: TextInputType.datetime,
                              //isClickable: false,
                              tap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2021-11-11'),
                                ).then((value) {
                                  datecontroller.text =
                                      DateFormat.yMMMd().format(value);
                                }).catchError((error) {
                                  print("error$error");
                                });
                              },
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'title must not be empty';
                                }
                                return null;
                              }),
                        ],
                      ),
                    ),
                  ),
                  elevation: 20.0,
                )
                .closed
                .then((value) {
              isBottomShowing = false;
              setState(() {
                iconFla = Icons.add;
              });
            });
            isBottomShowing = true;
          }
          // getName().then((value) {
          //   print(value);
          //   print("madonna");
          //   throw ("انا عملت ايرور");
          // }).catchError((error) {
          //   print(error.toString());
          // });
        },
        child: Icon(iconFla),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Taks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_outlined),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived',
          ),
        ],
      ),
    );
  }

  void createDatabase() async {
    dataBase = await openDatabase('ToDo.db', //اسم database
        version: 1, //بعمل كام table
        onCreate: (dataBase, version) {
      print("DataBase created"); //create database
      dataBase
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          //ببعت اسم table و ببعت اسماء entitys و datatype بتاعتها
          .then((value) {
        print("table created"); //create table
      }).catchError((error) {
        print("error when creating table ${error.toString()}");
      });
    }, onOpen: (dataBase) {
      getDataFromDB(dataBase).then((value) {
        setState(() {
          tasks = value;
          print(tasks);
        });
      });
      //open database
      print("database opened");
    });
  }

  Future insertToDatabase(
      {@required String title,
      @required String date,
      @required String time}) async {
    return await dataBase.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new") ')
          .then((value) {
        print("$value inserted succesfully");
      }).catchError((error) {
        print('error on creating new record ${error.toString()}');
      });
      return null;
    });
  }

  Future<List<Map>> getDataFromDB(dataBase) async {
    return await dataBase.rawQuery('SELECT * FROM tasks');
  }

  Future<String> getName() async {
    return "marina salah";
  }
}
