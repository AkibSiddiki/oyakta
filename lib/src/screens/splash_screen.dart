import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oyakta/src/services/oyakta_provider.dart';
import 'package:provider/provider.dart';

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
    final oyaktaProviders =
        Provider.of<OyaktaProviders>(context, listen: false);
    await oyaktaProviders.initOyakta();
    // ignore: use_build_context_synchronously
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
      backgroundColor: const Color.fromARGB(255, 2, 16, 30),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
