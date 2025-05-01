import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/src/bloc/connection/connection_bloc.dart';
import 'package:test1/src/bloc/connection/connection_state.dart' as conn;
import 'package:test1/src/screens/scanner/qr_scanner_screen.dart';
import 'package:test1/src/screens/scanner/saved_qr_screen.dart';
import 'package:test1/src/services/mqtt_service.dart';
import 'package:test1/src/widgets/dialogs/logout_confirmation_dialog.dart';
import 'package:test1/src/widgets/reusable/reusable_button.dart';

class SmartStationPage extends StatefulWidget {
  const SmartStationPage({super.key});

  @override
  State<SmartStationPage> createState() => _SmartStationPageState();
}

class _SmartStationPageState extends State<SmartStationPage> {
  late MQTTClientWrapper _mqttClient;

  int temperature = 0;
  int humidity = 0;
  int pressure = 0;

  @override
  void initState() {
    super.initState();

    _mqttClient = MQTTClientWrapper(
      host: '29ca9aa3e9614580b2b384d9a0290e8c.s1.eu.hivemq.cloud',
      clientIdentifier: 'flutter_client_${
          DateTime.now().millisecondsSinceEpoch}',
      username: 'dotem',
      password: 'Qwerty123',
      onData: ({int? temperature, int? humidity, int? pressure}) {
        setState(() {
          if (temperature != null) this.temperature = temperature;
          if (humidity != null) this.humidity = humidity;
          if (pressure != null) this.pressure = pressure;
        });
      },
    );

    final current = context.read<ConnectionBloc>().state;
    if (current is conn.ConnectionConnected) {
      _mqttClient.prepareMqttClient();
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (_mqttClient.connectionState != MqttCurrentConnectionState.connected) {
        _mqttClient.prepareMqttClient();
      }
    });
  }

  @override
  void dispose() {
    _mqttClient.disconnect();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    if (context.mounted) Navigator.pushReplacementNamed(context, '/');
  }

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
              fontSize: 18, color: Colors.white70,),),
          Text(value, style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold,
            color: Colors.white,),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkBackground = Color(0xFF1A1B2D);
    const accentPurple = Color(0xFF8A2BE2);
    final int fahrenheit = ((temperature * 9) / 5 + 32).round();

    return BlocListener<ConnectionBloc, conn.ConnectionState>(
      listener: (context, state) {
        if (state is conn.ConnectionConnected) {
          _mqttClient.prepareMqttClient();
        }
        if (state is conn.ConnectionDisconnected) {
          _mqttClient.disconnect();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: darkBackground,
          title: const Text('Станція Чіпідізєль'),
          actions: [
            IconButton(
              color: Colors.grey,
              icon: const Icon(Icons.settings),
              tooltip: 'Налаштувати пристрій',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => QRScannerScreen(), // ❗️ без onScanned
                  ),
                );
              },
            ),
            IconButton(
              color: Colors.grey,
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => LogoutConfirmationDialog(
                    onConfirm: () => _logout(context),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: darkBackground,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [darkBackground, Color(0xFF25274D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accentPurple.withOpacity(0.4),
                          Colors.transparent,],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSensorData('Температура', '$temperature°C / $fahrenheit°F'),
                          _buildSensorData('Вологість', '$humidity%'),
                          _buildSensorData('Тиск', '$pressure hPa'),
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
                              child: const Text(
                                  'Переглянути збережене повідомлення',),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: ReusableButton(
                        text: 'Головна',
                        onPressed: () => Navigator.pushNamed(context, '/home'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
