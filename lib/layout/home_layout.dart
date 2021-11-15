import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:udemy_app/shared/components/components.dart';
import 'package:udemy_app/shared/cubit/cubit.dart';
import 'package:udemy_app/shared/cubit/states.dart';

class homeLayout extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();

  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  //var formkey = GlobalKey<FormFieldState>();
  // المفروض تبقي <FormState> مش >FormFieldState> زي م انتي عامله فوق
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => appCubit()..createDatabase(),
      child: BlocConsumer<appCubit, appStates>(
        listener: (BuildContext context, appStates state) {
          if (state is appinsertDatabase) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, appStates state) {
          appCubit cubit = appCubit.get(context);

          return Scaffold(
            key: scaffoldkey,
            body: ConditionalBuilder(
              condition: state is! appchangetaskstatusstate,
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
              builder: (context) => cubit.screens[cubit.currentIndex],
            ),
// ConditionalBuilder(
//   condition: tasks.length > 0,
//   builder: (context) => Center(
//     child: CircularProgressIndicator(),
//   ),
//   fallback: (context) => screens[currentIndex],
// ),
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomShowing) {
                  if (formkey.currentState.validate()) {
                    cubit.insertToDatabase(
                      title: titlecontroller.text,
                      date: datecontroller.text,
                      time: timecontroller.text,
                    );
//                     insertToDatabase(
// // مكنتيش ضايفه ال title و time و date
//                       title: titlecontroller.text,
//                       time: timecontroller.text,
//                       date: datecontroller.text,
//                     ).then((value) {
//                       getDataFromDB(dataBase).then((value) {
// // setState(() {
// //   isBottomShowing = false;
// //   //شيلت السطر اللي تحت ده
// //   //iconFla = Icons.edit;
// //   tasks = value;
// //   print(tasks);
// // });
//                       });
                  }
                  //);
                  //  Navigator.pop(context);
                } else {
// setState(() {
//   iconFla = Icons.add;
// });
                  cubit.iconFla = Icons.add;
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
                                  },
                                ),
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
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timecontroller.text =
                                          value.format(context).toString();
                                    });
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                ),
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
                                        lastDate:
                                            DateTime(DateTime.now().year + 40),
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
                    cubit.bottomSheetChangeState(
                      isShow: false,
                      icon: Icons.edit,
                    );
// setState(() {
//   iconFla = Icons.add;
// });
                  });
                  cubit.bottomSheetChangeState(isShow: true, icon: Icons.add);
                }
// getName().then((value) {
//   print(value);
//   print("madonna");
//   throw ("انا عملت ايرور");
// }).catchError((error) {
//   print(error.toString());
// });
              },
              child: Icon(cubit.iconFla),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                appCubit.get(context).changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
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
        },
      ),
    );
  }
}
