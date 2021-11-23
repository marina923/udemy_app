import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_app/layout/news_app/cubit/states.dart';
import 'package:udemy_app/modules/business/business_screen.dart';
import 'package:udemy_app/modules/science/science_screen.dart';
import 'package:udemy_app/modules/settings/settings_screen.dart';
import 'package:udemy_app/modules/sports/sports_screen.dart';
import 'package:udemy_app/shared/network/local/cashe_helper.dart';
import 'package:udemy_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsIntialState());
  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(
    //     Icons.settings,
    //   ),
    //   label: 'Settings',
    // ),
  ];
  List<dynamic> Business = [];
  List<dynamic> Science = [];
  List<dynamic> Sports = [];

  List<Widget> Screens = [
    BusinessScreen(),
    ScienceScreen(),
    SportsScreen(),
  ];
  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1) getScienceNews();
    if (index == 2) getSportsNews();

    emit(NewsBottomNavState());
  }

  void getBusinessNews() {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'us',
      'category': 'business',
      'apiKey': '9d0b532b025447de9784bc5a61901499',
    }).then((value) {
      Business = value.data['articles'];
      emit(NewsGetBusinessSuccessState());
      print(
        Business[2]['title'],
      );
    }).catchError((error) {
      emit(NewsGetBusinessErrorState(error));
      print(error.toString());
    });
  }

  void getScienceNews() {
    emit(NewsGetScienceLoadingState());
    if (Science.length == 0) {
      DioHelper.getData(url: 'v2/top-headlines', query: {
        'country': 'us',
        'category': 'science',
        'apiKey': '9d0b532b025447de9784bc5a61901499',
      }).then((value) {
        Science = value.data['articles'];
        emit(NewsGetScienceSuccessState());
        print(
          Science[2]['title'],
        );
      }).catchError((error) {
        emit(NewsGetScienceErrorState(error));
        print(error.toString());
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  void getSportsNews() {
    emit(NewsGetSportsLoadingState());
    if (Sports.length == 0) {
      DioHelper.getData(url: 'v2/top-headlines', query: {
        'country': 'us',
        'category': 'sports',
        'apiKey': '9d0b532b025447de9784bc5a61901499',
      }).then((value) {
        Sports = value.data['articles'];
        emit(NewsGetSportsSuccessState());
        print(
          Sports[2]['title'],
        );
      }).catchError((error) {
        emit(NewsGetSportsErrorState(error));
        print(error.toString());
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  bool isDark = false;
  void changeAppMode({bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(
        NewsChangeModeState(),
      );
    } else {
      isDark = !isDark;
      CasheHelper.putBoolean(key: 'isDark', value: isDark).then(
        (value) => emit(
          NewsChangeModeState(),
        ),
      );
    }
  }
}
