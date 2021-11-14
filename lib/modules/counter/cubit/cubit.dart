import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'states.dart';

class counterCubit extends Cubit<counterStates> {
  //هنا انا عامله class بيورث من cubit بحط فيه class اللى فيه كل states
  counterCubit()
      : super(
            counterIntialState()); // هنا بحط constractour فيه اول state بستخدمها
  static counterCubit get(context) => BlocProvider.of(context);
  int counter = 1;
  void minus() {
    counter--;
    emit(counterminusState(this.counter));
  }

  void plus() {
    counter++;
    emit(counterplusState(this.counter));
  }
}
