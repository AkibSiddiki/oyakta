import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oyakta/src/services/oyakta_provider.dart';
import 'package:oyakta/src/widgets/prayer_card.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<DateTime> clockStream =
      Stream.periodic(const Duration(seconds: 1), (count) {
    return DateTime.now();
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OyaktaProviders>(
        builder: ((context, oyaktaProviders, chile) => SafeArea(
              child: Scaffold(
                  backgroundColor: const Color.fromARGB(255, 2, 16, 30),
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(56.0),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      title: Text(
                        DateTime.now().day == oyaktaProviders.today.day
                            ? 'Today'
                            : DateFormat('dd MMM')
                                .format(oyaktaProviders.today),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 250, 250, 250),
                            fontSize: 18),
                      ),
                      leading: IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          oyaktaProviders.prevDate();
                        },
                      ),
                      actions: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            oyaktaProviders.nextDate();
                          },
                        ),
                      ],
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //location Card start
                          Container(
                            width: double.infinity,
                            height: 125,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: Color.fromARGB(255, 1, 26, 52),
                              image: DecorationImage(
                                  image: AssetImage('assets/card_bg_big2.png'),
                                  fit: BoxFit.cover,
                                  opacity: 0.9),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StreamBuilder<DateTime>(
                                        stream: clockStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            DateTime currentTime =
                                                snapshot.data!;
                                            String formattedTime =
                                                DateFormat.jm()
                                                    .format(currentTime);

                                            return Text(
                                              formattedTime,
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 250, 250, 250),
                                                fontSize: 32,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            );
                                          } else {
                                            return const Text(
                                              '-:-',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 250, 250, 250),
                                                fontSize: 32,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.wb_sunny_sharp,
                                            size: 16,
                                            color: Color.fromARGB(
                                                255, 250, 250, 250),
                                          ),
                                          const Gap(12),
                                          Text(
                                            ' Sunrise ${DateFormat.jm().format(oyaktaProviders.prayerTimesOfSelectedLocation.sunrise!)}',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 250, 250, 250),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.wb_twilight_sharp,
                                            size: 16,
                                            color: Color.fromARGB(
                                                255, 250, 250, 250),
                                          ),
                                          const Gap(12),
                                          Text(
                                            ' Sunset ${DateFormat.jm().format(oyaktaProviders.prayerTimesOfSelectedLocation.maghribStartTime!.subtract(const Duration(minutes: 1)))}',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 250, 250, 250),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        oyaktaProviders.getCurrentLocation(),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Gap(7),
                                            Text(
                                              '${oyaktaProviders.selectedPlacemark.locality}',
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 250, 250, 250),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const Text(
                                              'Tap to update location',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 200, 200, 200),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                        const Gap(3),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: Icon(
                                            Icons.pin_drop,
                                            color: Colors.orange,
                                            size: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //location Card end

                          const Gap(12),
                          prayerCard(
                              oyaktaProviders
                                  .prayerTimesOfSelectedLocation.fajrStartTime!,
                              oyaktaProviders
                                  .prayerTimesOfSelectedLocation.fajrEndTime!,
                              'Fajar'),
                          const Gap(12),
                          prayerCard(
                              oyaktaProviders.prayerTimesOfSelectedLocation
                                  .dhuhrStartTime!,
                              oyaktaProviders
                                  .prayerTimesOfSelectedLocation.dhuhrEndTime!,
                              'Dhuhr'),
                          const Gap(12),
                          prayerCard(
                              oyaktaProviders
                                  .prayerTimesOfSelectedLocation.asrStartTime!,
                              oyaktaProviders
                                  .prayerTimesOfSelectedLocation.asrEndTime!,
                              'Asr'),
                          const Gap(12),
                          prayerCard(
                              oyaktaProviders.prayerTimesOfSelectedLocation
                                  .maghribStartTime!,
                              oyaktaProviders.prayerTimesOfSelectedLocation
                                  .maghribEndTime!,
                              'Maghrib'),
                          const Gap(12),
                          prayerCard(
                              oyaktaProviders
                                  .prayerTimesOfSelectedLocation.ishaStartTime!,
                              oyaktaProviders
                                  .prayerTimesOfSelectedLocation.ishaEndTime!,
                              'Isha'),
                        ],
                      ),
                    ),
                  )),
            )));
  }
}
