import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_app/shared/components/components.dart';
import 'package:udemy_app/shared/components/constants.dart';
import 'package:udemy_app/shared/cubit/cubit.dart';
import 'package:udemy_app/shared/cubit/states.dart';

class archivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tasks = appCubit.get(context).archivedtasks;
    return BlocConsumer<appCubit, appStates>(
        builder: (context, state) {
          return buildCondition(tasks: tasks);
        },
        listener: (context, state) {});
  }
}
