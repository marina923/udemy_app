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
    archivedTasksScreen(),
    doneTasksScreen(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  void changeIndex(int index) {
    currentIndex = index;
    emit(appChangeBottomNavBar());
  }

  Database dataBase;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];

  bool isBottomShowing = false;
  IconData iconFla = Icons.edit;
  void createDatabase() {
    openDatabase('ToDo.db', //اسم database
        version: 1, //بعمل كام table
        onCreate: (dataBase, version) async {
      print("DataBase created"); //create database
      await dataBase
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          //ببعت اسم table و ببعت اسماء entitys و datatype بتاعتها
          .then((value) {
        print("table created"); //create table
      }).catchError((error) {
        print("error when creating table ${error.toString()}");
      });
    }, onOpen: (dataBase) {
      getDataFromDB(dataBase);
      //open database
      print("database opened");
    });
  }

  insertToDatabase({
    @required String title,
    @required String date,
    @required String time,
  }) async {
    return dataBase.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new") ')
          .then((value) {
        emit(appinsertDatabase());
        getDataFromDB(dataBase);

        print("$value inserted succesfully");
      }).catchError((error) {
        print('error on creating new record ${error.toString()}');
      });
    });
  }

  void getDataFromDB(dataBase) {
    emit(appchangetaskstatusstate());
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    emit(appgetDatabaseLoading());
    dataBase.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        emit(appgetDatabase());
        if (element['status'] == 'New Tasks')
          newtasks.add(element);
        else if (element['status'] == 'Done Tasks')
          donetasks.add(element);
        else
          archivedtasks.add(element);
      });
    });
  }

  void updateDatabase({@required String status, @required int id}) async {
    await dataBase.rawUpdate('UPDATE tasks SET status = ?, WHERE id = ?',
        ['updated status', id]).then((value) {
      getDataFromDB(dataBase);
      emit(appupdateDatabase());
    });
  }

  void deleteDatabase({@required int id}) async {
    await dataBase
        .rawDelete('DELETE FROM tasks WHERE id = ?', ['id']).then((value) {
      getDataFromDB(dataBase);
      emit(appdeleteDatabase());
    });
  }

  void bottomSheetChangeState(
      {@required bool isShow, @required IconData icon}) {
    isBottomShowing = isShow;
    iconFla = icon;
    emit(appchangeBottomSheet());
  }
}
