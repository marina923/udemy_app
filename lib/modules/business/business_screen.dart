import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_app/layout/news_app/cubit/cubit.dart';
import 'package:udemy_app/layout/news_app/cubit/states.dart';
import 'package:udemy_app/shared/components/components.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
        builder: (context, state) {
          var list = NewsCubit.get(context).Business;
          return articleBuilder(list, context);
        },
        listener: (state, context) {});
  }
}
