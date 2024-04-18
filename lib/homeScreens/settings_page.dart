import 'package:spatial/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  String percentageModifier(double value) {
    final roundedValue = value.ceil().toInt().toString();
    return '$roundedValue KM';
  }

  // Distanced dist = Distanced();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Settings"),
      ),
      body: Center(
        child: SleekCircularSlider(
          initialValue: dist[0].toDouble(),
          appearance: CircularSliderAppearance(
            size: 350,
            startAngle: 180,
            angleRange: 360,
            animDurationMultiplier: 0.5,
            customColors: CustomSliderColors(
              hideShadow: true,
              progressBarColors: [
                const Color.fromARGB(255, 50, 50, 50),
                const Color.fromARGB(255, 27, 27, 27),
                const Color.fromARGB(255, 27, 27, 27),
              ],
              dynamicGradient: true,
            ),
            customWidths: CustomSliderWidths(progressBarWidth: 10),
            infoProperties: InfoProperties(
              modifier: percentageModifier,
            ),
          ),
          min: 1,
          max: 300,
          onChangeEnd: (double value) {
            dist.clear();
            dist.add(value.toInt() + 1);
          },
        ),
      ),
    );
  }
}
