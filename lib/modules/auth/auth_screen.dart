import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:virtoustack_assignment/modules/auth/auth_controller.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.put(AuthController());

    return Scaffold(
        backgroundColor: const Color(0xffF3EDF7),
        body: SafeArea(
            top: true,
            bottom: true,
            child: Obx(
              () => controller.isLoading
                  ? SizedBox(height: size.height, width: size.width, child: const Center(child: CircularProgressIndicator()))
                  : Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(height: size.height * 0.17),
                        Obx(
                          () => controller.isOtpSent
                              ? const Text("Verify",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ))
                              : const Text("Continue with Phone",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                        SizedBox(height: size.height * 0.06),
                        Obx(
                          () => controller.isOtpSent
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Enter code", style: TextStyle(color: Colors.deepPurple)),
                                    const SizedBox(height: 10),
                                    Pinput(
                                      controller: controller.otpController,
                                      closeKeyboardWhenCompleted: true,
                                      enabled: true,
                                      length: 6,
                                      cursor: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 9),
                                            width: 22,
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                      defaultPinTheme: PinTheme(
                                        width: size.width * 0.14,
                                        height: size.height * 0.065,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Form(
                                  key: controller.authFormKey,
                                  child: TextFormField(
                                    controller: controller.mobileNumberController,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      hintText: "Enter your mobile number",
                                      prefixIcon: Icon(Icons.phone),
                                      labelText: "Mobile Number",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your mobile number";
                                      }
                                      if (!value.isPhoneNumber) {
                                        return "Please enter a valid mobile number";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                        ),
                        SizedBox(height: size.height * 0.09),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (controller.isOtpSent) {
                                  if (controller.otpController.text.length != 6) {
                                    Get.snackbar("Error", "Please enter a valid OTP");
                                    return;
                                  }
                                  await controller.signInWithPhoneNumber(
                                    controller.otpController.text,
                                  );
                                } else {
                                  await controller.verifyPhoneNumber(controller.mobileNumberController.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6750A4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Obx(
                                () => Text(
                                  controller.isOtpSent ? "VERIFY" : "CONTINUE",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
            )));
  }
}
