import 'package:flutter/material.dart';
import 'package:oyakta/src/screens/home.dart';
import 'package:oyakta/src/screens/splash_screen.dart';
import 'package:oyakta/src/services/background_task.dart';
import 'package:oyakta/src/services/oyakta_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    backgroundTask();
    // print('>>>>>>>>>>>>>>>>>>>>$task');
    return Future.value(true);
  });
}

// int hourtoDelay() {
//   DateTime now = DateTime.now();
//   DateTime targetTime = DateTime(now.year, now.month, now.day, 1, 0);

//   if (targetTime.isBefore(now)) {
//     targetTime = targetTime.add(const Duration(days: 1));
//   }

//   int hoursLeft = targetTime.difference(now).inHours;
//   return hoursLeft;
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Workmanager().registerPeriodicTask(
    "task_id",
    "backgroundTask",
    frequency: const Duration(hours: 1),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OyaktaProviders())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const Home(),
        },
      ),
    );
  }
}
