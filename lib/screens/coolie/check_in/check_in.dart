import 'dart:ui';
import 'package:coolie_application/screens/coolie/check_in/check_in_controller.dart';
import 'package:coolie_application/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/text_box_widegt.dart';

class CheckIn extends StatelessWidget {
  CheckIn({super.key});

  final CheckInController controller = Get.put(CheckInController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xffF5F5F4),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            centerTitle: true,
            title: Text(
              "Check In",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Constants.instance.primary, Constants.instance.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => controller.pickCoolieImage(),
                        child: Obx(
                          () => Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: const Offset(0, 6))],
                              gradient: LinearGradient(
                                colors: [Colors.white.withOpacity(0.4), Colors.white.withOpacity(0.1)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: controller.coolieImage.value == null
                                  ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(controller.coolieImage.value!, width: 140, height: 140, fit: BoxFit.cover),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('Tap to capture / re-take photo', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
                      SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: TextBoxWidget(
                              enabled: controller.isEnable.value,
                              controller: controller.mobileNumberController,
                              hintText: 'Enter Mobile Number',
                              labelText: 'Mobile Number',
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                // Update button state when text changes
                                controller.update();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Mobile Number';
                                } else if (value.length < 10) {
                                  return 'Please Enter Valid Number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Obx(() {
                          final isEnabled = controller.isButtonEnabled && !controller.isLoading.value;

                          return GestureDetector(
                            onTap: isEnabled
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      controller.validateFace(_formKey);
                                    }
                                  }
                                : null,
                            child: Container(
                              width: double.infinity,
                              height: 58,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isEnabled ? [Constants.instance.primary, Constants.instance.primary] : [Colors.grey, Colors.grey],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: isEnabled ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))] : [],
                              ),
                              child: Center(
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                      )
                                    : Text(
                                        "Check In",
                                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),
                                      ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
