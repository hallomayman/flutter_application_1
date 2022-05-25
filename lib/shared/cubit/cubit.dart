import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../network/local/cash_helper.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  //late Database dataBase;

  List<Widget> screens = [
    //   NewTaskScreen(),
    //   DoneTaskScreen(),
    //   ArchivedTaskScreen()
  ];
  late List<Map> newTasks = [];
  late List<Map> doneTasks = [];
  late List<Map> archiveTasks = [];

  List<String> title = ["New Tasks", "Done Tasks", "Archived Tasks"];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  /* void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('created');
        }).catchError((error) {
          print('Error is ${error.toString()}');
        });
      },
      onOpen: (database) {
        print("opened");
        getDataFromDataBase(database);
      },
    ).then((value) {
      dataBase = value;
      emit(AppCreateDataBaseState());
    });
  }*/

  /*insertDataBase({@required title, @required time, @required date}) async {
    await dataBase.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted to data base');
        emit(AppInsertDataBaseState());

        getDataFromDataBase(dataBase);
      }).catchError((error) {
        print("Error When Inserted new record  ${error.toString()}");
      });
    });
  }*/

  /*getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDataBaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDataBaseState());
    });
  }*/

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData iconData,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = iconData;
    emit(AppChangeBottomSheetState());
  }

  /*void updateData({required String status, required int id}) async {
    dataBase.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDataBase(dataBase);
      emit(AppUpdateDataBaseState());
    });
  }*/

  /*void deleteData({required int id}) async {
    dataBase.rawUpdate(
      'DELETE FROM tasks  WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDataBase(dataBase);
      emit(AppDeleteDataBaseState());
    });
  }*/

  bool isDark = false;

  void changeAppMode({boolShared}) {
    if (boolShared != null) {
      isDark = boolShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CashHelper.putData(key: 'isDark', isDark: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }
}
