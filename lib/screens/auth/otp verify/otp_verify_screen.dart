import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/customs/custom_rich_text.dart';
import '../../../services/customs/otp_verification.dart';
import '../../../utils/app_constants.dart';
import 'otp_verify_controller.dart';

class OtpVerification extends StatelessWidget {
  const OtpVerification({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<OtpVerifyController>(
      init: OtpVerifyController(),
        builder: (controller){

      return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                'OTP Verification',
                style: GoogleFonts.lora(
                    fontSize: 24,
                    color: Constants.instance.primary
                ),
              ),
              SizedBox(height: 10),
              CustomRichText(
                text1: 'Enter the 4-digit OTP sent to your Mobile Number',
                style: GoogleFonts.lora(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              PinCodeTextField(
                highlight: true,
                maxLength: 4,
                pinBoxWidth: 45,
                pinBoxHeight: 45,
                pinBoxRadius: 6,
                pinBoxBorderWidth: 0.75,
                wrapAlignment: WrapAlignment.center,
                highlightPinBoxColor: Colors.white,
                highlightColor: Constants.instance.primary,
                defaultBorderColor: Colors.grey.shade500,
                keyboardType: TextInputType.number,
                pinTextStyle: TextStyle(fontSize: 14),
                pinBoxOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
                pinBoxColor: Colors.transparent,
                errorBorderColor: Colors.redAccent,
                hasTextBorderColor: Colors.black,
                controller: controller.verificationCodeController,
              ),
              const SizedBox(height: 40),
              MaterialButton(onPressed: (){
                controller.verifyOtp();
              },
                minWidth: double.infinity,
                height: 55,
                color: Constants.instance.primary,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text("Verify",style: GoogleFonts.lora(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),),
              ),
              const SizedBox(height: 30),
              CustomRichText(
                text1: 'Didn’t receive the OTP?  ',
                text2: 'Resend OTP',
                style1: GoogleFonts.lora(
                  fontSize: 13,
                  color: Colors.grey.shade900,
                ),
                style2: GoogleFonts.lora(
                  fontSize: 13,
                  // color: controller.isResendEnabled.value ? Constants.instance.secondary : Constants.instance.grey400,
                ),
                // onTap2: controller.isResendEnabled.value ? controller.resendOtp : null,
              ),
              Spacer(),
            ],
          ),
        ),
      );
    });
    // return Obx(
    //       () {
    //     return
    //   },
    // );
  }
}
