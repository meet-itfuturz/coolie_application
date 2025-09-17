
import 'package:coolie_application/routes/route_name.dart';
import 'package:coolie_application/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../booking history/booking_history.dart';
import '../my profile/profile_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<bool> _onWillPop() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Do you want to close the application?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              "Yes",
              style: GoogleFonts.poppins(
                color: Constants.instance.instagramRed,
              ),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context, ) {
    final HomeController controller = Get.put(HomeController());

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F4),
        appBar: AppBar(
          backgroundColor: Constants.instance.primary,
          elevation: 0,
          title: Text(
            "Coolie Dashboard",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                controller.fetchUserProfile();
                controller.getPassengerData();
              },
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                foregroundColor: WidgetStatePropertyAll(Constants.instance.white),
                backgroundColor: WidgetStatePropertyAll(Constants.instance.white),
              ),
              icon: Icon(Icons.refresh, color: Constants.instance.primary),
              tooltip: 'Logout',
            ),
            SizedBox(width: 10,),
          ],

        ),
        drawer: Obx(() {
          final profile = controller.userProfile.value;
          return Drawer(
            child: Column(
              children: [
            GestureDetector(
              onTap: ()=>Get.to(()=>UserProfileScreen()),
              child: UserAccountsDrawerHeader(
              accountName: Text(
              profile?.name ?? "Loading...",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                profile?.emailId.isNotEmpty == true
                    ? profile!.emailId
                    : profile?.mobileNo ?? "",
                style: GoogleFonts.poppins(),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: profile!.image!.url.isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    profile.image!.url,
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                  ),
                ) : const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              decoration: BoxDecoration(color: Constants.instance.primary),
                        ),
            ),

                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.dashboard_outlined),
                        title: Text('Dashboard', style: GoogleFonts.poppins()),
                        onTap: () => Get.back(),
                      ),
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: Text("Transaction History",
                            style: GoogleFonts.poppins()),
                        onTap: () {
                          Get.back();
                          Get.toNamed(RouteName.transactionHistory);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: Text("Booking History",
                            style: GoogleFonts.poppins()),
                        onTap: () {
                          Get.back();
                          Get.to(()=> BookingHistory());
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: Text('Logout', style: GoogleFonts.poppins()),
                        onTap: () => controller.showLogoutDialog(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckInOutCard(context, controller ),
              // const SizedBox(height: 20),
              // Row(
              //   children: [
              //     Expanded(
              //       child: _buildStatCard(
              //         title: "Today's Booking",
              //         count: "42",
              //         color2: Constants.instance.primary,
              //         icon: Icons.event_available,
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: _buildStatCard(
              //         title: "Cancelled Booking",
              //         count: "7",
              //         color2: Constants.instance.error,
              //         icon: Icons.cancel_outlined,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              Text(
                "Today's Booking List",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Constants.instance.black,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  final booking = controller.passengerDetails.value.booking;
                  if (booking == null) {
                    return const Center(child: Text("No passenger data found"));
                  }
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _showBookingDetailsBottomSheet(
                            context,
                             booking.passengerId?.name ?? "Unknown",
                             booking.passengerId?.mobileNo ?? "N/A",
                             controller.formatBookingTime(booking.timestamp?.bookedAt.toString()),
                             booking.fare!.baseFare.toString(),
                             booking.status ?? "Pending",
                             controller,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.blue[50],
                              child: const Icon(Icons.person, color: Colors.blue, size: 28),
                            ),
                            title: Text(
                              booking.passengerId?.name ?? "Unknown",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            subtitle: Text(
                              booking.passengerId?.mobileNo ?? "N/A",
                              style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.orange.shade200, width: 1.5),
                              ),
                              child: Text(
                                booking.status ?? "Pending",
                                style: GoogleFonts.poppins(
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              )

            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildCheckInOutCard(BuildContext context , HomeController controller) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildHeader(context,controller ),
          const SizedBox(height: 24),
          _buildPunchButton(context),
        ],
      ),
    ),
  );
}

Widget _buildHeader(BuildContext context, HomeController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.place, size: 22, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "Surat Station",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            // controller.passengerDetails.value.booking.,
            "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "Monday,\nSeptember 11:00 AM",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      const Icon(Icons.access_time, color: Colors.blueGrey, size: 26),
    ],
  );
}

Widget _buildPunchButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () => Get.toNamed(RouteName.checkIn),
    style: ElevatedButton.styleFrom(
      backgroundColor: Constants.instance.apple,
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      minimumSize: const Size(double.infinity, 55),
    ),
    child: Text(
      "Check In",
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
        fontSize: 16,
        color: Colors.white,
      ),
    ),
  );
}

Widget _buildStatCard({
  required String title,
  required String count,
  required Color color2,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
    decoration: BoxDecoration(
      color: color2,
      // gradient: LinearGradient(colors: [color1, ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: color2.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 4)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Icon(icon, color: Colors.white, size: 25),
          const SizedBox(height: 5),
          Text(count, style: GoogleFonts.poppins(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
        ],),
        const SizedBox(height: 4),
        Text(title, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
      ],
    ),
  );
}


void _showBookingDetailsBottomSheet(BuildContext context,
     String name,
       String mobile,
       String bookingTime,
       String payment,
       String status,
       HomeController controllerH
    ) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.45,
        maxChildSize: 0.6,
        minChildSize: 0.3,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              children: [
                Icon(Icons.arrow_drop_up,size: 25,),
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.blue[50],
                      child:  Icon(Icons.person, size: 38, color: Constants.instance.grey400),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controllerH.passengerDetails.value.booking!.passengerId!.name.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            )),
                        const SizedBox(height: 4),
                        Text(controllerH.passengerDetails.value.booking!.passengerId!.mobileNo.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            )),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailRow(Icons.access_time, "Booking Time", controllerH.formatBookingTime(controllerH.passengerDetails.value.booking!.timestamp?.bookedAt.toString())),
                const Divider(height: 20),
                _buildDetailRow(Icons.payment, "Payment", controllerH.passengerDetails.value.booking!.fare!.baseFare.toString()),
                const Divider(height: 20),
                _buildDetailRow(Icons.phone, "Mobile Number", controllerH.passengerDetails.value.booking!.passengerId!.mobileNo.toString()),
                const Divider(height: 20),
                _buildDetailRow(
                  Icons.check_circle,
                  "Status",
                  status,
                  valueColor: status == "Pending" ? Colors.orange : Colors.green,
                ),
                const SizedBox(height: 40),
                Obx(() {
                  debugPrint("UI Rebuilding with status => ${controllerH.checkStatuss.value}");

                  if (controllerH.checkStatuss.value.isEmpty) {
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.instance.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              controllerH.bookPassenger(
                                controllerH.passengerDetails.value.booking!.id.toString(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.instance.apple,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text("Book", style: GoogleFonts.poppins(color: Colors.white)),
                          ),
                        ),
                      ],
                    );
                  } else if (controllerH.checkStatuss.value == 'accepted') {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controllerH.completeService(
                            controllerH.passengerDetails.value.booking!.id.toString(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text("Complete Service", style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    );
                  } else {
                    return Container();
                  }
                })




              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildDetailRow(IconData icon, String label, String value,
    {Color valueColor = Colors.black87}) {
  return Row(
    children: [
      Icon(icon, color: Colors.blueGrey, size: 22),
      const SizedBox(width: 12),
      Expanded(
        child: Text(label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            )),
      ),
      Text(value,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: valueColor,
          )),
    ],
  );
}

