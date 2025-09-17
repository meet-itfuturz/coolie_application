
import 'package:coolie_application/screens/auth/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/route_name.dart';
import '../../../services/customs/custom_bottom_sheet.dart';
import '../../../services/customs/custom_edit_image.dart';
import '../../../services/customs/custom_form_field.dart';
import '../../../services/customs/custom_rich_text.dart';
import '../../../services/customs/updated_image_bottomshit.dart';
import '../../../utils/app_constants.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final RegisterController controller = Get.put(RegisterController());
  final formKey = GlobalKey<FormState>();

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location permissions are permanently denied."),
        ),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    String fullAddress =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";

    // controller.setLocation(
    //   fullAddress: fullAddress,
    //   lat: position.latitude.toString(),
    //   long: position.longitude.toString(),
    //   pincode: place.postalCode ?? "",
    //   city: place.locality ?? "",
    //   state: place.administrativeArea ?? "",
    // );
  }

  Future _openImageOptions() async {
    await openBottomShit(
      readySetup: true,
      title: "Profile Photo",
      child: UpdateImagesBottomShit(
        onView: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),

                // Profile Image
                Center(
                  child: CustomEditableImageView(
                    label: "Profile Image (Optional)",
                    width: 90,
                    height: 90,
                    radius: 90,
                    fit: BoxFit.cover,
                    onEdit: _openImageOptions,
                  ),
                ),
                const SizedBox(height: 20),

                // Name Field
                CustomFormField(
                  controller: controller.nameController,
                  hintText: "Name",
                  borderEnabled: true,
                  style: const TextStyle(fontSize: 15),
                  borderRadius: 12,
                  hintFontSize: 14,
                  isRequiredMark: true,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 10),

                // Mobile Field
                CustomFormField(
                  controller: controller.mobileController,
                  hintText: "Mobile No.",
                  borderEnabled: true,
                  style: const TextStyle(fontSize: 15),
                  borderRadius: 12,
                  hintFontSize: 14,
                  isRequiredMark: true,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
                const SizedBox(height: 10),

                // Email Field
                CustomFormField(
                  controller: controller.emailController,
                  hintText: "Email",
                  borderEnabled: true,
                  style: const TextStyle(fontSize: 15),
                  borderRadius: 12,
                  hintFontSize: 14,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  controller: controller.ageController,
                  hintText: "Age",
                  borderEnabled: true,
                  style: const TextStyle(fontSize: 15),
                  borderRadius: 12,
                  hintFontSize: 14,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),

                // Address Field
                CustomFormField(
                  controller: controller.buckleController,
                  hintText: "buckleNumber",
                  borderEnabled: true,
                  style: const TextStyle(fontSize: 15),
                  borderRadius: 12,
                  hintFontSize: 14,
                  isRequiredMark: true,
                  // readOnly: true,
                  // suffix: IconButton(
                  //   onPressed: _getCurrentLocation,
                  //   icon: const Icon(Icons.location_pin),
                  // ),
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  controller: controller.addressController,
                  hintText: "Address",
                  borderEnabled: true,
                  style: const TextStyle(fontSize: 15),
                  borderRadius: 12,
                  hintFontSize: 14,
                  isRequiredMark: true,
                  // readOnly: true,
                  // suffix: IconButton(
                  //   onPressed: _getCurrentLocation,
                  //   icon: const Icon(Icons.location_pin),
                  // ),
                ),
                // Gender Selection
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Gender",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // const SizedBox(height: 8),
                Obx(() => Container(
                  width: 320,
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          value: "Male",
                          groupValue: controller.selectedGender.value,
                          onChanged: (val) {
                            controller.selectedGender.value = val!;
                          },
                          title: const Text("Male"),
                        ),
                      ),
                      Expanded(

                        child: RadioListTile<String>(
                          value: "Female",
                          groupValue: controller.selectedGender.value,
                          onChanged: (val) {
                            controller.selectedGender.value = val!;
                          },
                          title: const Text("Female"),
                        ),
                      ),

                    ],
                  ),
                )),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Device Type",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Obx(() => Container(
                  width: 320,
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          value: "SmartPhone",
                          groupValue: controller.selectedDevice.value,
                          onChanged: (val) {
                            controller.selectedDevice.value = val!;
                          },
                          title: const Text("Smart Phone"),
                        ),
                      ),
                      Expanded(

                        child: RadioListTile<String>(
                          value: "Others",
                          groupValue: controller.selectedDevice.value,
                          onChanged: (val) {
                            controller.selectedDevice.value = val!;
                          },
                          title: const Text("other"),
                        ),
                      ),

                    ],
                  ),
                )),
                const SizedBox(height: 0),

                // SignUp Button
                Obx(
                      () => MaterialButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      controller.registerUser();
                    },
                    minWidth: double.infinity,
                    height: 55,
                    color: Constants.instance.primary,
                    disabledColor: Colors.grey,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide:
                      BorderSide(color: Constants.instance.primary),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "SignUp",
                      style: GoogleFonts.poppins(
                        color: Constants.instance.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sign In Link
                Center(
                  child: CustomRichText(
                    textAlign: TextAlign.center,
                    text1: 'Do you have an account?  ',
                    text2: 'Sign In Here',
                    onTap2: () {
                      Get.toNamed(RouteName.signIn);
                    },
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
