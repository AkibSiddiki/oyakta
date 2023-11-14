import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:oyakta/src/services/oyakta_provider.dart';
import 'package:provider/provider.dart';

class Qibla extends StatefulWidget {
  const Qibla({super.key});

  @override
  State<Qibla> createState() => _QiblaState();
}

class _QiblaState extends State<Qibla> {
  Stream<DateTime> clockStream =
      Stream.periodic(const Duration(seconds: 1), (count) {
    return DateTime.now();
  });

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      final oyaktaProviders =
          Provider.of<OyaktaProviders>(context, listen: false);
      oyaktaProviders.getCompassDirection();
    }

    return Consumer<OyaktaProviders>(
        builder: ((context, oyaktaProviders, chile) => SafeArea(
              child: Scaffold(
                  backgroundColor: const Color.fromARGB(255, 1, 17, 33),
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(56.0),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      title: const SizedBox(
                        child: Text(
                          'Qibla Direction',
                          style: TextStyle(color: Colors.orange, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: const Color.fromARGB(255, 1, 26, 52),
                    selectedItemColor: Colors.orange,
                    unselectedItemColor: Colors.white,
                    currentIndex: 1,
                    onTap: (value) {
                      if (value == 0) {
                        Navigator.popAndPushNamed(context, '/home');
                      }
                    },
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_rounded),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.compass_calibration_rounded),
                        label: 'Qibla',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings_rounded),
                        label: 'Settings',
                      ),
                    ],
                  ),
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.navigation_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                          const Gap(12),
                          AnimatedRotation(
                            turns: (oyaktaProviders.compassDir / 360),
                            duration: const Duration(milliseconds: 200),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/compassLayer.png',
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(31.0),
                                  child: RotationTransition(
                                      turns: AlwaysStoppedAnimation(
                                          oyaktaProviders.qiblaDir / 360),
                                      child:
                                          Image.asset('assets/kabaLayer.png')),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            )));
  }
}
