import '/routes/route_name.dart';
import 'package:get/get.dart';
import '../screens/coolie/check_in/check_in.dart';
import '../screens/coolie/home/home_screen.dart';
import '../screens/coolie/transation history/transation_history.dart';
import '../screens/auth/otp verify/otp_verify_screen.dart';
import '../screens/auth/sign_in.dart';
import '../screens/splash/splash_screen.dart';

class RoutePages {
  static final List<GetPage> pages = [
    GetPage(name: RouteName.splash, page: () => SplashScreen()),
    GetPage(name: RouteName.home, page: () => HomeScreen()),
    GetPage(name: RouteName.signIn, page: () => SignIn()),
    GetPage(name: RouteName.checkIn, page: () => CheckIn()),
    GetPage(name: RouteName.transactionHistory, page: () => TransactionHistory()),
    GetPage(name: RouteName.otpVerification, page: () => OtpVerification()),
  ];
}
