import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:udemy_app/layout/home_layout.dart';
import 'package:udemy_app/shared/blocobserver.dart';

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
