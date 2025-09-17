import 'package:coolie_application/routes/route_name.dart';
import 'package:coolie_application/screens/Module/traveller/home/travel_home_controller.dart';
import 'package:coolie_application/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelHomeScreen extends StatelessWidget {
  const TravelHomeScreen({super.key});

  Future<bool> _onWillPop() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text("Exit App"),
        content: Text("Do you want to close the application?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              "Yes",
              style: GoogleFonts.poppins(color: Constants.instance.instagramRed),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TravelHomeController>(
      init: TravelHomeController(),
        builder: (controller){
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor:  Color(0xffF5F5F4),
          appBar: AppBar(
            title: Text("Traveller Dashboard", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            backgroundColor: Constants.instance.appBarColor,
            elevation: 4,
          ),
          drawer: _buildDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: const [
                CoolieCard(
                  name: "Ramesh Kumar",
                  bukleNo: "BKL-1203",
                  mobileNo: "+91 9876543210",
                  experience: "5 Years",
                  station: "Surat Station",
                  rate: 300,
                  age: 32,
                  rating: 4.5,
                ),
                CoolieCard(
                  name: "Suresh Singh",
                  bukleNo: "BKL-4521",
                  mobileNo: "+91 9988776655",
                  experience: "3 Years",
                  station: "Ahemdabad ",
                  age: 28,
                  rate: 459,
                  rating: 4.2,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CoolieCard extends StatelessWidget {
  final String name;
  final String bukleNo;
  final String mobileNo;
  final String experience;
  final String station;
  final int age;
  final int rate;
  final double rating;

  const CoolieCard({
    super.key,
    required this.name,
    required this.bukleNo,
    required this.mobileNo,
    required this.experience,
    required this.station,
    required this.age,
    required this.rate,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TravelHomeController>(
      init: TravelHomeController(),
        builder: (controller){
      return GestureDetector(
        onTap: ()=>_showDetailsBottomSheet(context),
        child:Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Pic
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Constants.instance.primary,
                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    // Name + Bukle + Rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Constants.instance.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Bukle No: $bukleNo",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Constants.instance.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [

                              // const Icon(Icons.attach_money, color: Colors.amber, size: 18),
                              Text("₹"),
                              const SizedBox(width: 4),
                              Text(
                                "$rate",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(width: 30,),
                              const Icon(Icons.star_border_purple500_outlined, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "$rating",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 28, thickness: 1, color: Colors.black12),

                // Details Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _detailItem(Icons.phone, mobileNo, Colors.green),
                    // _detailItem(Icons.work, experience, Colors.orange),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _detailItem(Icons.location_on, station, Constants.instance.error),
                    // _detailItem(Icons.cake, "$age yrs", Colors.purple),
                  ],
                ),

                const SizedBox(height: 16),

                // Book Button full width
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.instance.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 3,
                    ),
                    onPressed: () {

                      controller.openCheckout(rate.toDouble());
                    },
                    child: Text(
                      "Book Coolie",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _detailItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
  void _showDetailsBottomSheet(BuildContext context) {
    final controller = Get.put(TravelHomeController());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          minChildSize: 0.4,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // drag handle
                  Icon(Icons.arrow_drop_up,size: 25,),
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Profile Info
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Constants.instance.primary,
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text("Bukle No: $bukleNo",
                      style: GoogleFonts.poppins(color: Colors.black54)),
                  const SizedBox(height: 10),

                  // Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("₹"),
                      // const Icon(Icons.attach_money, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "$rate",
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 20,),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "$rating",
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  // Details Section
                  _detailRow(Icons.phone, "Mobile", mobileNo, Colors.green),
                  _detailRow(Icons.location_on, "Station", station, Constants.instance.error),
                  _detailRow(Icons.work, "Experience", experience, Colors.orange),
                  _detailRow(Icons.cake, "Age", "$age yrs", Colors.purple),
                  _detailRow(Icons.language, "Languages", "Hindi, English", Colors.blue),
                  _detailRow(Icons.check_circle, "Completed Orders", "248", Colors.teal),

                  const SizedBox(height: 25),

                  // Book Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.instance.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        controller.openCheckout(rate.toDouble());
                      },
                      child: Text(
                        "Book Coolie",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
Widget _detailRow(IconData icon, String title, String value, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Text(
          "$title: ",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}


Widget _buildDrawer() {
  return Drawer(
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text("Chandan Polai", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          accountEmail: Text("987654321", style: GoogleFonts.poppins()),
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.grey),
          ),
          decoration: BoxDecoration(color: Constants.instance.primary),
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
                title: Text("Transaction History", style: GoogleFonts.poppins()),
                onTap: () {
                  Get.back();
                  Get.toNamed(RouteName.transactionHistory);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text('Logout', style: GoogleFonts.poppins()),
                onTap: () => Get.offAllNamed(RouteName.signIn),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
