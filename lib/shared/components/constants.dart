import 'dart:ui';

import '../../module/login/log_in.dart';
import '../../network/local/cash_helper.dart';
import 'components.dart';

Color darkMod = Color.fromRGBO(51, 55, 57, 1);
var uId;

void signOut(context) {
  CashHelper.removeData(
    key: 'uId',
  ).then((value) {
    if (value) {
      navigateAndFinsh(
        context,
        SocialLoginScreen(),
      );
    }
  });
}
