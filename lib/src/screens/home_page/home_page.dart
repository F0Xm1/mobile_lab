import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/src/bloc/connection/connection_bloc.dart';
import 'package:test1/src/bloc/connection/connection_state.dart' as connection;
import 'package:test1/src/widgets/chipi_dizel_connector/chipi_dizel_connector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isOnline = false;
  bool _stationConnected = false;

  @override
  void initState() {
    super.initState();

    // Відновлюємо стан інету
    final currentState = context.read<ConnectionBloc>().state;
    _isOnline = currentState is connection.ConnectionConnected;

    // Відновлюємо стан підключення до станції
    _stationConnected = ChipiDizelConnectorState.connected;
  }

  void _handleStationConnectionChanged(bool connected) {
    setState(() {
      _stationConnected = connected;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBackground = Color(0xFF1A1B2D);
    const Color accentPurple = Color(0xFF8A2BE2);
    const Color lightPurple = Color(0xFFB19CD9);

    return BlocListener<ConnectionBloc, connection.ConnectionState>(
      listener: (context, state) {
        if (state is connection.ConnectionDisconnected) {
          setState(() {
            _isOnline = false;
            _stationConnected = false; // автоматично відключаємо
          });

          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text('Відсутнє підключення'),
              content: const Text(
                'Інтернет зник! Деякі функції можуть бути недоступні.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state is connection.ConnectionConnected) {
          setState(() {
            _isOnline = true;
          });
        }
      },
      child: Scaffold(
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
            Positioned(
              top: -80,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: lightPurple.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: accentPurple.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.power_settings_new,
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Чіпідізєль Smart Station',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  accentPurple.withOpacity(0.3),
                                  accentPurple.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: ChipiDizelConnector(
                                isOnline: _isOnline,
                                onConnectionChanged:
                                _handleStationConnectionChanged,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_isOnline && _stationConnected)
                          ? () => Navigator.pushNamed(context, '/station')
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        (_isOnline && _stationConnected) ?
                        accentPurple : Colors.white10,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Перейти до станції',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Ласкаво просимо до розумного дому!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
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
