import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model/categories_model.dart';
import 'package:shop_app/models/change_favorites_model/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model/favorites_model.dart';
import 'package:shop_app/models/home_model/home_model.dart';
import 'package:shop_app/models/login_model/login_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/shop_states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  // constructor match super with initial state of app
  ShopCubit() : super(ShopInitialState());

  // create a static object from the ShopCubit
  static ShopCubit get(BuildContext context) => BlocProvider.of(context);

  // light & dark mode
  // true because the first time run
  // the fromShared optional value = null
  // and the changeAppMode enter to the else statement
  // and reverse the value of isDark
  bool isDark = true;

  void changeAppMode({bool? fromShared}) {
    if (fromShared == null) {
      // first time open app the isDark from shared = null
      // her we just toggle between the 2 possibles
      isDark = !isDark;
      // save isDark value in shared preferences after edit the new value
      CashHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(ShopChangeModeState());
      });
    } else {
      // her we get saved data from shared preferences
      isDark = fromShared;
      emit(ShopChangeModeState());
    }
  }

  // bottom nav bar index
  int currentIndex = 0;

  // list of Widgets of bottom nav bar
  List<Widget> bottomsScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];

  // control bottom bar nave index here
  void changeBottomNav(index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  // get home data
  HomeModel? homeModel;

  // map <int, bool> for favorites
  // int => id ,
  // bool => exist in favorites or not true/false
  Map<int, bool> inFavorites = {};

  void getHomeData() {
    // use this null check for token
    // to prevent app from getting data in first time use
    // before login as token = null and app will crash
    // we must get data in login also and register success states
    if (token != null) {
      if (kDebugMode) {
        print(token);
      }
      emit(ShopLoadingHomeDataState());
      DioHelper.getData(
        url: HOME,
        // take token for detect that the user login or out
        // there are some data depends on this token
        token: token!,
      ).then((value) {
        // add products data to the home model object
        homeModel = HomeModel.fromJson(value.data);
        // add the Favorites products in the map
        for (var element in homeModel!.data.products) {
          inFavorites.addAll({element.id: element.inFavorites});
        }
        // for (var element in homeModel!.data.products) {
        //   inFavorites.addAll({element.id: element.inFavorites});
        // }

        emit(ShopSuccessHomeDataState());
      }).catchError((error) {
        emit(ShopErrorHomeDataState(error.toString()));
        if (kDebugMode) {
          print(error.toString());
        }
      });
    }
  }

  ChangeFavoritesModel? changeFavoritesModel;

  // this POST method for change state of
  // the in_favorites in the api
  void changeFavorites(int productId) {
    if (token != null) {
      // this for make change of color of favorites
      // in the same time before load again
      inFavorites[productId] = !inFavorites[productId]!;
      // for initial listen for favorites
      emit(ShopChangeFavoritesState());

      DioHelper.postData(
        url: FAVORITES,
        data: {'product_id': productId},
        token: token!,
      ).then((value) {
        changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
        if (kDebugMode) {
          print(value.data);
        }
        // if user click on favorite button it will change it's color
        // then do the task in background
        // so if the process came with false
        // we must revers the inFavorites value again
        // also revers in error stat
        if (!changeFavoritesModel!.status) {
          inFavorites[productId] = !inFavorites[productId]!;
        } else {
          // get favorites again to update screen
          getFavoritesData();
        }
        emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
      }).catchError((error) {
        inFavorites[productId] = !inFavorites[productId]!;
        emit(ShopErrorChangeFavoritesState(error.toString()));
        if (kDebugMode) {
          print(error.toString());
        }
      });
    }
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    if (token != null) {
      emit(ShopLoadingCategoriesState());

      DioHelper.getData(url: GET_CATEGORIES, token: token!).then((value) {
        categoriesModel = CategoriesModel.fromJson(value.data);
        emit(ShopSuccessCategoriesState());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ShopErrorCategoriesState(error.toString()));
      });
    }
  }

  // Get Favorites
  FavoritesModel? getFavoritesModel;

  void getFavoritesData() {
    if (token != null) {
      emit(ShopLoadingGetFavoritesState());

      DioHelper.getData(url: FAVORITES, token: token!).then((value) {
        getFavoritesModel = FavoritesModel.fromJson(value.data);
        emit(ShopSuccessGetFavoritesState());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ShopErrorGetFavoritesState(error.toString()));
      });
    }
  }

  // Get user data
  // use the same model of login
  LoginModel? userDataModel;

  void getUserData() {
    if (token != null) {
      emit(ShopLoadingGetUserDataState());

      DioHelper.getData(url: GET_PROFILE, token: token!).then((value) {
        userDataModel = LoginModel.fromJson(value.data);
        emit(ShopSuccessGetUserDataState(userDataModel!));
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ShopErrorGetUserDataState(error.toString()));
      });
    }
  }

// Update user data
// use the same model of login and get user data
  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    if (token != null) {
      emit(ShopLoadingUpdateUserDataState());

      DioHelper.putData(
              url: UPDATE_PROFILE,
              data: {
                'name': name,
                'email': email,
                'phone': phone,
              },
              token: token!)
          .then((value) {
        userDataModel = LoginModel.fromJson(value.data);
        emit(ShopSuccessUpdateUserDataState(userDataModel!));
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ShopErrorUpdateUserDataState(error.toString()));
      });
    }
  }
}
