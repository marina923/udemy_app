import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:udemy_app/layout/home_layout.dart';
import 'package:udemy_app/modules/bmi_result/bmi_result_screen.dart';
import 'package:udemy_app/modules/login/login_screen.dart';
import 'package:udemy_app/modules/users/users_screen.dart';
import 'package:udemy_app/shared/blocobserver.dart';

import 'modules/bmi/bmi_screen.dart';
import 'modules/counter/counter.dart';
import 'modules/messanger/messanger_screen.dart';
import 'modules/new_tasks/newTasksScreen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeLayout(),
    );
  }
}
