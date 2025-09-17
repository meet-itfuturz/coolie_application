

class NetworkConstants {
  // local Urls
    static const String baseUrl = 'https://0cv89p3x-5000.inc1.devtunnels.ms/';
  static const String imageURL = 'https://0cv89p3x-5000.inc1.devtunnels.ms/';

  //Production Urls

  //Endpoints

  //   Authentications
    static const String signIn = 'api/users/signInCollie';
    static const String otpVerification = 'api/users/isVerifiedCollie';
    static const String sendOtp = 'api/users/signIn';
    static const String getCoolieProfile = 'api/users/collieProfile';
    static const String faceDetect = 'api/users/faceLogin';
    static const String getNextBooking = 'api/users/getNextBooking';
    static const String bookingAction = 'api/users/bookingAction';
    static const String startService = 'api/users/startService';
    static const String completeService = 'api/users/completeService';
    static const String logout = 'api/users/logout';
    static const String currentBookingStatus = 'api/users/currentBookingStatus';
    static const String allcompletedBookings = 'api/users/AllcompletedBookings';
    static const String registerCollie = 'api/admin/collie/registerCollie';


  // Timeouts
  static const int sendTimeout = 30000; // 30 seconds
}