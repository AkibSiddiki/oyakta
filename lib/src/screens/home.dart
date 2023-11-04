import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oyakta/src/services/oyakta_provider.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OyaktaProviders>(
        builder: ((context, oyaktaProviders, chile) => SafeArea(
              child: Scaffold(
                  backgroundColor: const Color.fromARGB(221, 15, 15, 15),
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    title: const Text(
                      'Oyakta',
                      style: TextStyle(color: Colors.white),
                    ),
                    centerTitle: true,
                    actions: [
                      IconButton(
                          onPressed: () {
                            oyaktaProviders.getOyakta();
                          },
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.amber,
                            size: 28,
                          )),
                      const SizedBox(
                        width: 12,
                      )
                    ],
                  ),
                  body: !oyaktaProviders.reqComplete
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //location Card start
                                Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/card_bg_big.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat.jm()
                                                  .format(DateTime.now()),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 42,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.wb_sunny_sharp,
                                                  size: 16,
                                                  color: Colors.black87,
                                                ),
                                                const Gap(8),
                                                Text(
                                                  DateFormat.jm().format(
                                                      oyaktaProviders
                                                          .prayerTimesOfCurrentLocation
                                                          .sunrise),
                                                  style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.wb_twilight_sharp,
                                                  size: 16,
                                                  color: Colors.black87,
                                                ),
                                                const Gap(8),
                                                Text(
                                                  DateFormat.jm().format(
                                                      oyaktaProviders
                                                          .prayerTimesOfCurrentLocation
                                                          .maghrib
                                                          .subtract(
                                                              const Duration(
                                                                  minutes: 1))),
                                                  style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Gap(7),
                                            Text(
                                              '${oyaktaProviders.currentPlacemark.locality}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${oyaktaProviders.currentPlacemark.country}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                //location Card end
                                const Gap(12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        const Color.fromARGB(255, 19, 19, 19),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Fajr at',
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                      Text(
                                        DateFormat.jm().format(oyaktaProviders
                                            .prayerTimesOfCurrentLocation.fajr),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 237, 237, 237),
                                            fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        const Color.fromARGB(255, 19, 19, 19),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Dhuhr at',
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                      Text(
                                        DateFormat.jm().format(oyaktaProviders
                                            .prayerTimesOfCurrentLocation
                                            .dhuhr),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 237, 237, 237),
                                            fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        const Color.fromARGB(255, 19, 19, 19),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Asr at',
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                      Text(
                                        DateFormat.jm().format(oyaktaProviders
                                            .prayerTimesOfCurrentLocation.asr),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 237, 237, 237),
                                            fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        const Color.fromARGB(255, 19, 19, 19),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Maghrib at',
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                      Text(
                                        DateFormat.jm().format(oyaktaProviders
                                            .prayerTimesOfCurrentLocation
                                            .maghrib),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 237, 237, 237),
                                            fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        const Color.fromARGB(255, 19, 19, 19),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Isha at',
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                      Text(
                                        DateFormat.jm().format(oyaktaProviders
                                            .prayerTimesOfCurrentLocation.isha),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 237, 237, 237),
                                            fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
            )));
  }
}
