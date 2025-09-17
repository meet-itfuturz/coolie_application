

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller){
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated logo
                      AnimatedBuilder(
                        animation: controller.animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: controller.scaleAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, -20 * (1 - controller.fadeAnimation.value)),
                              child: Opacity(
                                opacity: controller.fadeAnimation.value,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.luggage,
                                    size: 80,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // App name with animation
                      AnimatedBuilder(
                        animation: controller.animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: controller.fadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - controller.fadeAnimation.value)),
                              child: Text(
                                'Coolie',
                                style: GoogleFonts.poppins(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Tagline with animation
                      AnimatedBuilder(
                        animation: controller.animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: controller.fadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - controller.fadeAnimation.value)),
                              child: Text(
                                'Track Your Video Creator',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColorDark,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Animated progress indicator
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: controller.animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: controller.fadeAnimation.value,
                          child: SizedBox(
                            width: 150,
                            child: LinearProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColorLight,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
