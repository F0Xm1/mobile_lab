part of 'station_data_cubit.dart';

abstract class StationDataState {
  const StationDataState(); // ✅ Додали const конструктор
}

class StationDataUpdated extends StationDataState {
  final int temperature;
  final int humidity;
  final int pressure;

  const StationDataUpdated({
    required this.temperature,
    required this.humidity,
    required this.pressure,
  }) : super(); // ✅ Вже не буде помилки
}
