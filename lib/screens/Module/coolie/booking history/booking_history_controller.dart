import 'dart:convert';
import 'package:coolie_application/repositories/authentication_repo.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../models/history_model.dart';
import 'package:flutter/foundation.dart';


class BookingHistoryController extends GetxController {
  final AuthenticationRepo authenticationRepo =AuthenticationRepo();
  final bookings = <GetAllBookings>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getHistory();
  }

  Future<void>getHistory()async{
    try{
      final res= await authenticationRepo.getHistory();
      debugPrint("res Data$res");
      if(res !=null){
        debugPrint("res Data null $res");
        final List<dynamic> docs = res['bookings']['docs'];
        bookings.assignAll(docs.map((e) => GetAllBookings.fromJson(e)).toList());
        debugPrint("bookings== $bookings");
      }
    }catch(e){
      debugPrint("ERROR in HISTORY $e");
    }
  }
  String formatDate(String date) {
    return DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.parse(date));
  }
}