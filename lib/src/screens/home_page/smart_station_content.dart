import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/src/cubit/station/station_data_cubit.dart';
import 'package:test1/src/screens/scanner/saved_qr_screen.dart';
import 'package:test1/src/widgets/reusable/reusable_button.dart';

class SmartStationContent extends StatelessWidget {
  const SmartStationContent({super.key});

  Widget _buildSensorData(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
          ),
          Text(value, style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accentPurple = Color(0xFF8A2BE2);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accentPurple.withOpacity(0.4), Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: const Center(
            child: Text(
              'Чіпідізєль',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: BlocBuilder<StationDataCubit, StationDataState>(
              builder: (context, state) {
                if (state is StationDataUpdated) {
                  final fahrenheit = ((state.temperature * 9) / 5 + 32).round();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSensorData(
                          'Температура',
                          '${state.temperature}°C / $fahrenheit°F',),
                      _buildSensorData('Вологість', '${state.humidity}%'),
                      _buildSensorData('Тиск', '${state.pressure} hPa'),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (_) => const SavedQrScreen(),
                              ),
                            );
                          },
                          child:
                          const Text('Переглянути збережене повідомлення'),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: Center(
            child: ReusableButton(
              text: 'Головна',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}
