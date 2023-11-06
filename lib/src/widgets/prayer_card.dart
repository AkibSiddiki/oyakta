import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

Widget prayerCard(
    DateTime s, DateTime e, String prayerName, String currentPrayer) {
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
                  prayerName,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 250, 250, 250),
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
                const Gap(4),
                if (prayerName.toLowerCase() == currentPrayer &&
                    (s.day == DateTime.now().day &&
                        s.month == DateTime.now().month &&
                        s.year == DateTime.now().year))
                  const Icon(
                    Icons.lens,
                    color: Color.fromARGB(255, 22, 165, 72),
                    size: 9,
                  )
              ],
            ),
            const Text(
              'Start Time',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              DateFormat.jm().format(s),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'End time',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              DateFormat.jm().format(e),
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
