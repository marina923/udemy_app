import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:udemy_app/layout/news_app/cubit/cubit.dart';
import 'package:udemy_app/layout/news_app/cubit/states.dart';
import 'package:udemy_app/layout/news_app/news_layout.dart';
import 'package:udemy_app/layout/todo_app/todo_layout.dart';
import 'package:udemy_app/shared/blocobserver.dart';
import 'package:udemy_app/shared/network/local/cashe_helper.dart';
import 'package:udemy_app/shared/network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CasheHelper.init();

  bool isDark = CasheHelper.getBoolean(key: 'isDark');

  runApp(MyApp(isDark));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp(this.isDark);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NewsCubit()
        ..changeAppMode(
          fromShared: isDark,
        )
        ..getBusinessNews()
        ..getScienceNews()
        ..getSportsNews(),
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              scaffoldBackgroundColor: Colors.white,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.deepOrange,
              ),
              appBarTheme: AppBarTheme(
                actionsIconTheme: IconThemeData(
                  color: Colors.black,
                ),
                elevation: 0.0,
                //backwardsCompatibility: false,
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.deepOrange,
                backgroundColor: Colors.white,
                unselectedItemColor: Colors.black45,
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: HexColor('333739'),
              primarySwatch: Colors.deepOrange,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.deepOrange,
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              appBarTheme: AppBarTheme(
                actionsIconTheme: IconThemeData(
                  color: Colors.white,
                ),
                elevation: 0.0,
                //backwardsCompatibility: false,
                backgroundColor: HexColor('333739'),
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: HexColor('333739'),
                  statusBarIconBrightness: Brightness.light,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.deepOrange,
                backgroundColor: HexColor('333739'),
                unselectedItemColor: Colors.white,
              ),
            ),
            themeMode: NewsCubit.get(context).isDark
                ? ThemeMode.light
                : ThemeMode.dark,
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: NewsLayout(),
            ),
          );
        },
      ),
    );
  }
}
