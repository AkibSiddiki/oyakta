// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:oyakta/src/services/oyakta_provider.dart';
import 'package:provider/provider.dart';
// import 'package:location/location.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () {
      initProvider();
    });
  }

  void initProvider() async {
    // Location location = Location();

    // bool serviceEnabled;
    // PermissionStatus permissionGranted;

    // serviceEnabled = await location.serviceEnabled();
    // if (!serviceEnabled) {
    //   serviceEnabled = await location.requestService();
    //   if (!serviceEnabled) {
    //     SystemNavigator.pop();
    //   }
    // }

    // permissionGranted = await location.hasPermission();
    // if (permissionGranted == PermissionStatus.denied) {
    //   permissionGranted = await location.requestPermission();
    //   if (permissionGranted != PermissionStatus.granted) {
    //     SystemNavigator.pop();
    //   }
    // }

    final oyaktaProviders =
        Provider.of<OyaktaProviders>(context, listen: false);
    await oyaktaProviders.initOyakta();
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 17, 33),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 100,
              height: 100,
            ),
            const Gap(50),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
