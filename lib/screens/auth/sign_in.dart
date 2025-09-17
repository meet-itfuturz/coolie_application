import 'package:coolie_application/screens/auth/sign_controller.dart';
import 'package:coolie_application/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/route_name.dart';
import '../../services/customs/custom_rich_text.dart';
import '../../widgets/text_box_widegt.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignController());
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffF5F5F4),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Logo + Heading
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(Icons.luggage,
                            size: 65, color: Constants.instance.primary),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Coolie",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Sign in to continue",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),


                // Obx(
                //       () => Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(12),
                //       border: Border.all(color: Colors.grey.shade300, width: 1.2),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black12,
                //           blurRadius: 6,
                //           offset: Offset(0, 3),
                //         ),
                //       ],
                //     ),
                //     child: Row(
                //       children: [
                //         _buildToggleBtn(
                //           context: context,
                //           title: "Traveller",
                //           isSelected: controller.userType.value == "Traveller",
                //           onTap: () => controller.onChangeView("Traveller"),
                //         ),
                //         _buildToggleBtn(
                //           context: context,
                //           title: "Coolie",
                //           isSelected: controller.userType.value == "Coolie",
                //           onTap: () => controller.onChangeView("Coolie"),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                // const SizedBox(height: 30),

                /// Mobile Input
                Text(
                  "Mobile No.",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextBoxWidget(
                  controller: controller.mobileController,
                  maxLength: 10,
                  hintText: 'Enter Mobile Number',
                  prefixIcon: Icon(Icons.phone, color: Constants.instance.primary),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Mobile Number';
                    }
                    if (!value.isPhoneNumber) {
                      return 'Invalid Number';
                    }
                    return null;
                  },
                ),

                // const Spacer(),
                SizedBox(height: 30,),

                /// Sign In Button
                Obx(
                      () => AnimatedScale(
                    scale: controller.isLoading.value ? 0.96 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                        await controller.signIn();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.instance.primary,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                        height: 26,
                        width: 26,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : Text(
                        "Sign In",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Center(
                  child: CustomRichText(
                    textAlign: TextAlign.center,
                    text1: "Don't you have an account  ",
                    text2: 'Sign Up Here',
                    onTap2: (){
                      Get.toNamed(RouteName.register);
                    },
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Toggle Button Widget
  Widget _buildToggleBtn({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Constants.instance.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
