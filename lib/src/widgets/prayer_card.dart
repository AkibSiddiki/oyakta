import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:oyakta/src/services/oyakta_provider.dart';
import 'package:provider/provider.dart';

class PrayerCard extends StatefulWidget {
  final DateTime s;
  final DateTime e;
  final String prayerName;
  final String currentPrayer;
  const PrayerCard(
      {super.key,
      required this.s,
      required this.e,
      required this.prayerName,
      required this.currentPrayer});

  @override
  State<PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<PrayerCard> {
  @override
  Widget build(BuildContext context) {
    final oyaktaProviders =
        Provider.of<OyaktaProviders>(context, listen: false);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 1, 26, 52),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.prayerName,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 250, 250, 250),
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                  const Gap(4),
                  if (widget.prayerName.toLowerCase() == widget.currentPrayer &&
                      (widget.s.day == DateTime.now().day &&
                          widget.s.month == DateTime.now().month &&
                          widget.s.year == DateTime.now().year))
                    const Icon(
                      Icons.lens,
                      color: Color.fromARGB(255, 22, 165, 72),
                      size: 9,
                    )
                ],
              ),
              const Gap(5),
              const Text(
                'Start Time',
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                DateFormat.jm().format(widget.s),
                style: const TextStyle(
                    color: Color.fromARGB(255, 250, 250, 250),
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 1,
              width: 30,
              color: Colors.white12,
            ),
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: () => oyaktaProviders
                      .toggleAlert(widget.prayerName.toLowerCase()),
                  child:
                      oyaktaProviders.alerts[widget.prayerName.toLowerCase()] ==
                              true
                          ? const Icon(
                              Icons.alarm,
                              color: Colors.orange,
                              size: 20,
                            )
                          : const Icon(
                              Icons.alarm,
                              color: Colors.white24,
                              size: 20,
                            )),
              const Gap(5),
              const Text(
                'End time',
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                DateFormat.jm().format(widget.e),
                style: const TextStyle(
                    color: Color.fromARGB(255, 250, 250, 250),
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget PrayerCard(
//     context, DateTime s, DateTime e, String prayerName, String currentPrayer) {
  
// }
