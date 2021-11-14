import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart'; //2-بعمل install لل package دى كمان
import 'package:udemy_app/modules/counter/cubit/cubit.dart';
import 'package:udemy_app/modules/counter/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; //1-بعمل install للpackage دى

class counterScreen extends StatelessWidget {
  int counter = 1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      //wrap scaffold بحاجه اسمها bloc provider جواه فانكشن اسمها create
      create: (BuildContext context) =>
          counterCubit(), //create بتاخد حاجه وهى اسم class cubit يتاعى
      child: BlocConsumer<counterCubit, counterStates>(
          //و بعدين عندى child جواه bloc consumer بياخد حاجتين و هما cubit و states
          listener: (context, state) {
        if (state is counterminusState) print("minus state${state.counter}");
        if (state is counterplusState) print("plus state${state.counter}");
      },
          //فى اتنين فانكشن فى bloc consumer و هما listener و builder

          builder: (context, state) {
        //builder بيرجع design
        return Scaffold(
          appBar: AppBar(
            title: Text('counter'),
          ),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    counterCubit.get(context).minus();
                  },
                  child: Text('Minus'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '${counterCubit.get(context).counter}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    counterCubit.get(context).plus();
                  },
                  child: Text('PLUS'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
