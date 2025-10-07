import 'package:coolie_application/api%20constants/network_constants.dart';
import 'package:coolie_application/routes/route_name.dart';
import 'package:coolie_application/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../my profile/profile_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<bool> _onWillPop() async {
    return await Get.dialog<bool>(
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text("Exit App", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            content: Text("Do you want to close the application?", style: GoogleFonts.poppins()),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey[700])),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.instance.instagramRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Exit", style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Constants.instance.primary,
          elevation: 0,
          title: Text("Coolie Dashboard", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
          foregroundColor: Colors.white,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                onPressed: () {
                  controller.fetchUserProfile();
                  controller.getPassengerData();
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                tooltip: 'Refresh',
              ),
            ),
          ],
        ),
        drawer: _buildModernDrawer(controller),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchUserProfile();
            await controller.getPassengerData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(controller),
                _buildCheckInOutCard(context, controller),
                const SizedBox(height: 24),
                _buildBookingListSection(context, controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(HomeController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Constants.instance.primary,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Obx(() {
          final profile = controller.userProfile.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome back,", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                profile?.name ?? "Coolie",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStatusBadge(controller),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatusBadge(HomeController controller) {
    return Obx(() {
      final status = controller.checkStatuss.value;
      final isActive = status.isNotEmpty;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.green : Colors.orange, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: isActive ? Colors.green : Colors.orange, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              isActive ? "Active Service" : "Available",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBookingListSection(BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list_alt_rounded, size: 24, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                "Today's Bookings",
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            final booking = controller.passengerDetails.value.booking;

            if (controller.isLoading.value) {
              return const Center(
                child: Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator()),
              );
            }

            if (booking == null) {
              return _buildEmptyState();
            }

            return _buildBookingCard(context, controller, booking);
          }),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No Bookings Available",
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text("New bookings will appear here", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, HomeController controller, booking) {
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Constants.instance.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue[50],
                    child: const Icon(Icons.person_rounded, color: Colors.blue, size: 32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.passengerId?.name ?? "Unknown",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Text(booking.passengerId?.mobileNo ?? "N/A", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: _getStatusColor(booking.status ?? "Pending"), borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    booking.status ?? "Pending",
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoChip(Icons.access_time, "Time", controller.formatBookingTime(booking.timestamp?.bookedAt.toString())),
                  Container(width: 1, height: 40, color: Colors.white30),
                  _buildInfoChip(Icons.currency_rupee, "Fare", "₹${booking.fare!.baseFare}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'accepted':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildCheckInOutCard(BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(children: [_buildHeader(context, controller), const SizedBox(height: 24), _buildPunchButton(context)]),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeController controller) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Constants.instance.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.location_on, size: 28, color: Constants.instance.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Current Location", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(
                "Surat Station",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 4),
              Text("Monday, September 11:00 AM", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPunchButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Constants.instance.apple, Constants.instance.apple.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Constants.instance.apple.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: () => Get.toNamed(RouteName.checkIn),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          minimumSize: const Size(double.infinity, 55),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.login_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              "Check In",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, letterSpacing: 0.5, fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDrawer(HomeController controller) {
    return Obx(() {
      final profile = controller.userProfile.value;
      return Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.to(() => UserProfileScreen()),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey[200],
                        child: profile?.image?.url.isNotEmpty == true
                            ? ClipOval(child: Image.network("${NetworkConstants.imageURL}${profile!.image!.url}", fit: BoxFit.cover, width: 72, height: 72))
                            : const Icon(Icons.person, size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile?.name ?? "Loading...",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.emailId.isNotEmpty == true ? profile!.emailId : profile?.mobileNo ?? "",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: Icon(Icons.person_outline, color: Constants.instance.primary),
                    title: Text('My Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      Get.back();
                      Get.to(() => UserProfileScreen());
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.dashboard_outlined, color: Constants.instance.primary),
                  //   title: Text('Dashboard', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  //   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  //   onTap: () {
                  //     Get.back();
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.history, color: Constants.instance.primary),
                  //   title: Text('Service History', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  //   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  //   onTap: () {
                  //     Get.back();
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.support_agent_outlined, color: Constants.instance.primary),
                  //   title: Text('Help & Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  //   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  //   onTap: () {
                  //     Get.back();
                  //   },
                  // ),
                  const Divider(height: 32),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.red),
                    ),
                    onTap: () => controller.showLogoutDialog(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showBookingDetailsBottomSheet(
    BuildContext context,
    String name,
    String mobile,
    String bookingTime,
    String payment,
    String status,
    HomeController controllerH,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.85,
          minChildSize: 0.4,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, -4))],
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(0),
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Constants.instance.primary.withOpacity(0.1), Constants.instance.primary.withOpacity(0.05)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))],
                                ),
                                child: CircleAvatar(
                                  radius: 32,
                                  backgroundColor: Colors.blue[50],
                                  child: Icon(Icons.person_rounded, size: 36, color: Constants.instance.primary),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controllerH.passengerDetails.value.booking!.passengerId!.name.toString(),
                                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          controllerH.passengerDetails.value.booking!.passengerId!.mobileNo.toString(),
                                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                Icons.access_time_rounded,
                                "Booking Time",
                                controllerH.formatBookingTime(controllerH.passengerDetails.value.booking!.timestamp?.bookedAt.toString()),
                              ),
                              const Divider(height: 32),
                              _buildDetailRow(Icons.currency_rupee, "Payment", "₹${controllerH.passengerDetails.value.booking!.fare!.baseFare}"),
                              const Divider(height: 32),
                              _buildDetailRow(Icons.check_circle_outline, "Status", status, valueColor: _getStatusColorForDetail(status)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Obx(() {
                          debugPrint("UI Rebuilding with status => ${controllerH.checkStatuss.value}");

                          if (controllerH.checkStatuss.value.isEmpty) {
                            return Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Constants.instance.primary),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: GoogleFonts.poppins(color: Constants.instance.primary, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [Constants.instance.apple, Constants.instance.apple.withOpacity(0.8)]),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [BoxShadow(color: Constants.instance.apple.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        controllerH.bookPassenger(controllerH.passengerDetails.value.booking!.id.toString());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: Text(
                                        "Accept Booking",
                                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (controllerH.checkStatuss.value == 'accepted') {
                            return SizedBox(
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Colors.green, Color(0xFF43A047)]),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    controllerH.completeService(controllerH.passengerDetails.value.booking!.id.toString());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Complete Service",
                                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color valueColor = Colors.black87}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Constants.instance.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: valueColor),
        ),
      ],
    );
  }

  Color _getStatusColorForDetail(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'accepted':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
