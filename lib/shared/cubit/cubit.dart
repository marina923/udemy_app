import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_app/modules/archived_tasks/archivedTasksScreen.dart';
import 'package:udemy_app/modules/done_tasks/doneTasksScreen.dart';
import 'package:udemy_app/modules/new_tasks/newTasksScreen.dart';
import 'package:udemy_app/shared/cubit/states.dart';

class appCubit extends Cubit<appStates> {
  appCubit() : super(appInitialState());
  static appCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    newTasksScreen(),
    doneTasksScreen(),
    archivedTasksScreen(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  bool isBottomShowing = false;
  IconData iconFla = Icons.edit;

  void changeIndex(int index) {
    currentIndex = index;
    emit(appChangeBottomNavBar());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error in creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDB(database);
      },
    ).then((value) {
      database = value;
      emit(appcreateDatabase());
    });
    // openDatabase('ToDo.db', //اسم database
    //     version: 1, //بعمل كام table
    //     onCreate: (database, version) async {
    //   print("DataBase created"); //create database
    //   await database
    //       .execute(
    //           'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
    //       //ببعت اسم table و ببعت اسماء entitys و datatype بتاعتها
    //       .then((value) {
    //     print("table created"); //create table
    //   }).catchError((error) {
    //     print("error when creating table ${error.toString()}");
    //   });
    // }, onOpen: (database) {
    //   getDataFromDB(database);
    //   //open database
    //   print("database opened");
    // }).then((value) {
    //   database = value;
    //   emit(appcreateDatabase());
    // });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    return database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, time, date, status) VALUES("$title","$time","$date","New")')
          .then((value) {
        print('$value inserted successfully');
        emit(appinsertDatabase());
        getDataFromDB(database);
      }).catchError((error) {
        print('Error in creating table ${error.toString()}');
      });
    });
    //{
    //   @required String title,
    //   @required String date,
    //   @required String time,
    // }) async {
    //   return database.transaction((txn) async {
    //     txn
    //         .rawInsert(
    //             'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new") ')
    //         .then((value) {
    //       print("$value inserted successfully");
    //       emit(appinsertDatabase());
    //       getDataFromDB(database);
    //     }).catchError((error) {
    //       print('error on creating new record ${error.toString()}');
    //     });
    //   });
  }

  void getDataFromDB(database) async {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(appgetDatabaseLoading());
    database.rawQuery('SELECT * FROM tasks').then(
      (value) {
        value.forEach((element) {
          if (element['status'] == 'New')
            newTasks.add(element);
          else if (element['status'] == 'done')
            doneTasks.add(element);
          else
            archiveTasks.add(element);
        });
        emit(appgetDatabase());
      },
    );
    // emit(appchangetaskstatusstate());
    // newtasks = [];
    // donetasks = [];
    // archivedtasks = [];
    // emit(appgetDatabaseLoading());
    // database.rawQuery('SELECT * FROM tasks').then((value) {
    //   value.forEach((element) {
    //     if (element['status'] == 'new')
    //       newtasks.add(element);
    //     else if (element['status'] == 'done')
    //       donetasks.add(element);
    //     else
    //       archivedtasks.add(element);
    //   });
    //   emit(appgetDatabase());
    // });
  }

  void updateDatabase({@required String status, @required int id}) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDB(database);
      emit(appupdateDatabase());
    });
  }

  void deleteDatabase({
    @required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDB(database);
      emit(appdeleteDatabase());
    });
  }
  //   {@required int id}) {
  // database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
  //   print(newTasks);
  //   getDataFromDB(database);
  //   emit(appdeleteDatabase());
  // });

  void bottomSheetChangeState(
      {@required bool isShow, @required IconData icon}) {
    isBottomShowing = isShow;
    iconFla = icon;
    emit(appchangeBottomSheet());
  }
}
