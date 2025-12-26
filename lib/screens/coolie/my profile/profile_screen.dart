import 'package:coolie_application/services/app_toasting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api constants/network_constants.dart';
import '../../../utils/app_constants.dart';
import '../home/home_controller.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            // title: Image.asset(
            //   "assets/logo/app_bar_logo.png",
            //   width: 120,
            //   height: 70,
            // ),
            backgroundColor: Constants.instance.primary,
            leading: BackButton(color: Colors.white),
            // actions: [
            //   IconButton(
            //     onPressed: () {
            //       // Get.toNamed(ROute.editProfileScreen);
            //     },
            //     icon: Icon(Icons.edit_outlined),
            //   ),
            // ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                Center(
                  child: Obx(() {
                    final profile = controller.userProfile.value;
                    return CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: profile != null &&
                          profile.image!.url.isNotEmpty
                          ? NetworkImage(
                        "${NetworkConstants.imageURL}${profile.image!.url}",
                      )
                          : null,
                      child: profile == null || profile.image!.url.isEmpty
                          ? Icon(
                        Icons.person,
                        size: 40,
                        color: Constants.instance.grey100,
                      )
                          : null,
                    );
                  }),
                ),
                SizedBox(height: 20),

                // ===== CARD WITH ALL DETAILS =====
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Constants.instance.grey100,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Obx(() {
                        final profile = controller.userProfile.value;
                        final summary = "controller.transactionSummary.value";
                        final transactions = "controller.transactions";
                        debugPrint("TRANSACTION DATA : $transactions");

                        if (profile == null) {
                          return Center(child: CircularProgressIndicator());
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailTile(
                              Icons.person,
                              "Name",
                              toTitleCase(profile.name),
                            ),
                            _divider(),
                            _buildDetailTile(
                              Icons.alternate_email,
                              "Email",
                              profile.emailId,
                            ),
                            _divider(),
                            _buildDetailTile(
                              Icons.call,
                              "Mobile No.",
                              profile.mobileNo,
                            ),
                            _divider(),
                            _buildDetailTile(
                              Icons.date_range,
                              "Age",
                                profile.age
                               // profile.dateOfBirth != null
                               //     "profile.dateOfBirth!.day}/profile.dateOfBirth!.month}/profile.dateOfBirth!.year} -",
                            ),
                            _divider(),
                            _buildDetailTile(
                              Icons.star,
                              "Buckle No.",
                             profile.buckleNumber,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // ===== Logout/Delete Button =====
                _buildLogoutButton(context, controller),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ===== DETAIL TILE =====
Widget _buildDetailTile(IconData icon, String title, String value) {
  return Row(
    children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: Constants.instance.primary.withOpacity(0.1),
        child: Icon(icon, color: Constants.instance.primary),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ],
  );
}

// ===== TRANSACTION TILE =====
Widget _buildTransactionTile(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

// ===== HELPERS =====
String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text
      .toLowerCase()
      .split(' ')
      .map(
        (word) =>
    word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word,
  )
      .join(' ');
}

Widget _divider() => Divider(color: Colors.grey.shade300, height: 24);

// ===== LOGOUT / DELETE BUTTON =====
Widget _buildLogoutButton(BuildContext context, HomeController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        deleteAccount(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.error.withOpacity(0.1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              'Delete Account',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> deleteAccount(BuildContext context) async {
      const url = 'https://docs.google.com/forms/d/e/1FAIpQLSe_6UsyVHh5hX02k2N-uaAz26Kl9iTim2fTskkyppcthKmlDQ/viewform?pli=1';
      // Show confirmation dialog
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Account'),
            content: const Text('Are you sure you want to delete your account? This action is permanent and cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Cancel
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirm
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
      // Proceed with deletion only if user confirms
      if (confirmDelete == true) {
        try {
          if (await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
            // Success
          } else {
            warningToast('Could not launch URL');
          }
        } catch (e) {
          warningToast('Error: $e');
        }
      }
    }
