import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/cubit/shop_states.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';

import 'layout/shop_layout/shop_layout.dart';
import 'modules/on_boarding/on_boarding_screen.dart';

void main() async {
  // wait while the async process finish then run the app
  WidgetsFlutterBinding.ensureInitialized();

  //init sharedPreferences from CashHelper
  await CashHelper.init();

  // isDark bool variable came from sharedPreferences
  bool? _isDark = CashHelper.getData(key: 'isDark');

  late Widget home;
  // onBoarding bool variable came from sharedPreferences
  // refer to the onBoarding screen have been seen or not
  bool? _onBoarding = CashHelper.getData(key: 'onBoarding');

  // if user login before go to home directly
  token = CashHelper.getData(key: 'token');

  if (_onBoarding != null) {
    if (token != null) {
      home = ShopLayout();
    } else {
      home = LoginScreen();
    }
  } else {
    home = const OnBoardingScreen();
  }

  // init DioHelper
  DioHelper.init();

  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        isDark: _isDark,
        home: home,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  // refer to the dark theme
  final bool? isDark;

  // refer to the home screen
  final Widget home;

  const MyApp({Key? key, required this.isDark, required this.home})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        // use MultiBlocProvider if we have more than one cubit in the same app
        // provide all Cubits here and consume them any where
        providers: [
          // Shop app cubit provided here
          BlocProvider(
            create: (BuildContext context) => ShopCubit()
              // here we call changeAppMode when the app starts
              // isDark will be null in first time open
              ..changeAppMode(fromShared: isDark)
              // get data when the app run
              // make sure to call these methods in login & register methods
              // because if user logged out the token = null
              // and these method will not get any data here
              ..getHomeData()
              ..getCategoriesData()
              ..getFavoritesData()
              ..getUserData(),
          ),
        ],
        child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: ShopCubit.get(context).isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: home,
            );
          },
        ));
  }
}
