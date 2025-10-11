import 'package:coolie_application/api%20constants/network_constants.dart';
import 'package:coolie_application/models/get_passenger_coolie_model.dart';
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
                  controller.update();
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
            await controller.checkStatus();
            controller.update();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(controller),
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
              const SizedBox(height: 20),
              // Check In / Check Out Buttons
              _buildCheckInOutButtons(controller),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCheckInOutButtons(HomeController controller) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: controller.isCheckedIn.value
                      ? [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.2)]
                      : [Constants.instance.apple, Constants.instance.apple.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: controller.isCheckedIn.value
                    ? null
                    : () {
                        Get.toNamed(RouteName.checkIn, arguments: controller.isCheckedIn);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login_rounded, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "Check In",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: !controller.isCheckedIn.value
                      ? [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.2)]
                      : [Constants.instance.instagramRed, Constants.instance.instagramRed.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: !controller.isCheckedIn.value
                    ? null
                    : () {
                        controller.checkOut();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "Check Out",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

  Widget _buildBookingCard(BuildContext context, HomeController controller, Booking booking) {
    return Container(
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
          const SizedBox(height: 20),
          // Action Buttons
          Obx(() {
            debugPrint("UI Rebuilding with status => ${controller.checkStatuss.value}");

            if (controller.checkStatuss.value == 'pending') {
              return Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        "Decline",
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Constants.instance.apple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.bookPassenger(controller.passengerDetails.value.booking!.id.toString());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          "Accept",
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (controller.checkStatuss.value == 'accepted') {
              return SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _showOTPDialog(context, controller);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.dialpad, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "Enter OTP",
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (controller.checkStatuss.value == 'in-progress') {
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
                      controller.completeService(controller.passengerDetails.value.booking!.id.toString());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
        ],
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

  void _showOTPDialog(BuildContext context, HomeController controller) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Enter OTP", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: controller.verificationCodeController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
                decoration: InputDecoration(
                  hintText: "----",
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Constants.instance.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Constants.instance.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Constants.instance.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.bookingOPTVerify(controller.passengerDetails.value.booking?.id);
                        controller.verificationCodeController.text = "";
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.instance.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Verify", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                  ListTile(
                    leading: Icon(Icons.history, color: Constants.instance.primary),
                    title: Text('Booking History', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      Get.back();
                      Get.toNamed(RouteName.bookingHistory);
                    },
                  ),
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
}