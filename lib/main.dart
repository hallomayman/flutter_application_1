import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/layout/layout.dart';
import 'package:flutter_application_1/module/login/log_in.dart';
import 'package:flutter_application_1/network/local/cash_helper.dart';
import 'package:flutter_application_1/shared/bloc_observe.dart';
import 'package:flutter_application_1/shared/components/components.dart';
import 'package:flutter_application_1/shared/components/constants.dart';
import 'package:flutter_application_1/shared/cubit/cubit.dart';
import 'package:flutter_application_1/shared/cubit/states.dart';
import 'package:flutter_application_1/shared/styles/Themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'admin/admin_dash.dart';
import 'admin/cubit/cubit.dart';
import 'layout/cubit/cubit.dart';
import 'network/remote/dio_helper.dart';

// Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
//   print(message.data.toString());
//   showToast(
//     message: 'BackGround',
//     states: ToastStates.SUCCESS,
//   );
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // var token = await FirebaseMessaging.instance.getToken();

  // print("token here ................");
  // print(token.toString());
  // print("token here ................");

  //foreground
  // FirebaseMessaging.onMessage.listen((event) {
  //   print(event.data.toString());
  //   showToast(
  //     message: 'onMessage',
  //     states: ToastStates.SUCCESS,
  //   );
  // }).onError((handleError) {
  //   print('error');
  // });

  // //when click notification open the app
  // FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //   print(event.data.toString());
  //   showToast(
  //     message: 'onMessageOpenedApp',
  //     states: ToastStates.SUCCESS,
  //   );
  // }).onError((handleError) {
  //   print('error');
  // });

  // //background
  // FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CashHelper.init();

  Widget widget;

  uId = CashHelper.getData(key: 'uId') ?? null;
  print(uId);

  if (uId != null && uId != 'Admin') {
    widget = SocialLayout();
  } else if (uId == 'Admin') {
    widget = DashScreen();
  } else {
    widget = SocialLoginScreen();
  }

  bool isDark = CashHelper.getData(key: 'isDark') ?? false;

  runApp(MyApp(
    startWidget: widget,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;
  MyApp({required this.startWidget, required this.isDark});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit()..changeAppMode(boolShared: isDark)),
        BlocProvider(
            create: (context) => SocialCubit()
              ..getUserData()
              ..getUsers()
              ..getPosts()),
        BlocProvider(create: (context) => AdminCubit()..getPosts()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, states) {
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('ar', ''), // English, no country code
            ],
            locale: Locale('ar', ''),
            debugShowCheckedModeBanner: false,
            title: 'Hema News',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
