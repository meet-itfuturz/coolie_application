import 'package:coolie_application/repositories/authentication_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/history_model.dart';

class BookingHistoryController extends GetxController {
  final AuthenticationRepo authenticationRepo = AuthenticationRepo();
  final bookings = <GetAllBookings>[].obs;
  final isLoading = false.obs;
  final hasMore = true.obs;
  final page = 1.obs;
  final limit = 10;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getHistory();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (hasMore.value && !isLoading.value) {
          getHistory();
        }
      }
    });
  }

  Future<void> getHistory() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final res = await authenticationRepo.getHistory(page: page.value, limit: limit);

      debugPrint("res Data: $res");

      if (res != null) {
        debugPrint("res Data not null: $res");

        final Map<String, dynamic> bookingsData = res['bookings'];
        final List<dynamic> docs = bookingsData['docs'];
        final bool hasNextPage = bookingsData['hasNextPage'] ?? false;

        final newBookings = docs.map((e) => GetAllBookings.fromJson(e)).toList();
        bookings.addAll(newBookings);

        hasMore.value = hasNextPage;
        if (hasNextPage) {
          page.value++;
        }

        debugPrint("Total bookings loaded: ${bookings.length}");
        debugPrint("Has more pages: $hasNextPage");
      }
    } catch (e) {
      debugPrint("ERROR in HISTORY: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> refreshHistory() async {
    bookings.clear();
    page.value = 1;
    hasMore.value = true;
    await getHistory();
  }

  String formatDate(String date) {
    try {
      return DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.parse(date));
    } catch (e) {
      return "N/A";
    }
  }

  String calculateTotalSpent() {
    if (bookings.isEmpty) return "0";

    try {
      double total = 0;
      for (var booking in bookings) {
        if (booking.fare?.baseFare != null) {
          total += double.tryParse(booking.fare!.baseFare.toString()) ?? 0;
        }
      }
      return total.toStringAsFixed(0);
    } catch (e) {
      return "0";
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
