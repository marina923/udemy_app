import 'package:flutter/material.dart';

abstract class counterStates {
} //3-هنا بعمل package جواها اتنين dart file ده الاول اللى بجط فيه states ولازم يكون abstract

class counterIntialState extends counterStates {} //دى اول state عندى

class counterminusState extends counterStates {
  //دى تانى واحده و هكذا على حسب عدد states اللى عندى
  final int counter;

  counterminusState(this.counter);
}

class counterplusState extends counterStates {
  final int counter;

  counterplusState(this.counter);
}
