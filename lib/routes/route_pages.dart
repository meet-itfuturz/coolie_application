import 'package:coolie_application/routes/route_name.dart';
import 'package:get/get.dart';

import '../screens/Module/coolie/check_in/check_in.dart';
import '../screens/Module/coolie/home/home_screen.dart';
import '../screens/Module/coolie/transation history/transation_history.dart';
import '../screens/Module/traveller/home/travel_home_screen.dart';
import '../screens/auth/otp verify/otp_verify_screen.dart';
import '../screens/auth/register/register_screen.dart';
import '../screens/auth/sign_in.dart';
import '../screens/splash/splash_screen.dart';

class RoutePages {

static final List<GetPage> pages=[
  GetPage(name: RouteName.splash, page: () => SplashScreen()),
  GetPage(name: RouteName.home, page: () => HomeScreen()),
  GetPage(name: RouteName.signIn, page: () => SignIn()),
  GetPage(name: RouteName.checkIn, page: () => CheckIn()),
  GetPage(name: RouteName.travelHomeScreen, page: () => TravelHomeScreen()),
  GetPage(name: RouteName.transactionHistory, page: () => TransactionHistory()),
  GetPage(name: RouteName.otpVerification, page: () => OtpVerification()),
  GetPage(name: RouteName.register, page: () => Register()),
];

}