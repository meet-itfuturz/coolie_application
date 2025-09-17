import 'package:coolie_application/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'booking_history_controller.dart';

class BookingHistory extends StatelessWidget {
  const BookingHistory({super.key});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingHistoryController>(
      init: BookingHistoryController(),
        builder: (controller){
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text("Completed Bookings", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Constants.instance.primary,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.bookings.isEmpty) {
            return Center(child: Text("No Completed Bookings Found"));
          }
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: controller.bookings.length,
            itemBuilder: (context, index) {
              final booking = controller.bookings[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking ID + Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            booking.pickupDetails!.station.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                          Chip(
                            label: Text(
                              booking.status.toString().toString().toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          )
                        ],
                      ),
                      SizedBox(height: 12),

                      // Pickup -> Destination
                      Row(
                        children: [
                          Icon(Icons.my_location, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              booking.pickupDetails!.station.toString(),
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                              child: VerticalDivider(
                                color: Colors.grey.shade400,
                                thickness: 2,
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              booking.destination.toString(),
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      // Fare + Dates
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Fare: ₹${booking.fare!.baseFare}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87)),
                          Text(
                            "Completed: ${controller.formatDate(booking.timestamp!.bookedAt.toString())}",
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }),
      );
    });
  }
}
