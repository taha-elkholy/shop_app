import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/shop_cubit.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';

// app token can be null in first time use the app
//and if  user logged out
String? token;

// signOut from the app
void signOut(context) {
  CashHelper.removeData(key: 'token').then((value) {
    if (value) {
      // if value == true
      // make sure that current index
      // of bottom nav bar = 0
      ShopCubit.get(context).currentIndex = 0;

      navigateAndFinish(context, LoginScreen());
    }
  });
}

// print Full Text from json
void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((element) {
    print(element.group(0));
  });
}
