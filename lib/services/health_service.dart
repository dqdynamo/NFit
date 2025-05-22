import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class HealthService {
  final Health _health = Health();


Future<bool> requestPermissions() async {
    final permissions = [
      Permission.activityRecognition,
      Permission.location,
      Permission.sensors,
    ];

    bool allGranted = true;

    for (final perm in permissions) {
      if (!await perm.isGranted) {
        final result = await perm.request();
        if (!result.isGranted) {
          allGranted = false;
        }
      }
    }

    return allGranted;
  }

  Future<bool> requestAuthorization() async {
    final types = <HealthDataType>[
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_LIGHT,
      HealthDataType.SLEEP_DEEP,
    ];

    final perms = types.map((_) => HealthDataAccess.READ).toList();

    final granted = await requestPermissions();
    if (!granted) return false;

    final authorized = await _health.requestAuthorization(types, permissions: perms);
    print('Authorization granted: $authorized');
    return authorized;
  }

  Future<int> fetchTodaySteps() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    try {
      final steps = await _health.getTotalStepsInInterval(start, now);
      print('Fetched steps from $start to $now: $steps');
      return steps ?? 0;
    } catch (e) {
      print('Error fetching steps: $e');
      return 0;
    }
  }

  Future<double> fetchAverageHeartRate() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    try {
      final hrData = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: now,
        types: [HealthDataType.HEART_RATE],
      );

      if (hrData.isEmpty) return 0;

      final avg = hrData.map((e) => e.value as double).reduce((a, b) => a + b) / hrData.length;
      return avg;
    } catch (e) {
      print('Error fetching heart rate: $e');
      return 0;
    }
  }

  Future<int> fetchTodaySleepMinutes() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(hours: 24));

    try {
      final sleepData = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: now,
        types: [
          HealthDataType.SLEEP_ASLEEP,
          HealthDataType.SLEEP_LIGHT,
          HealthDataType.SLEEP_DEEP,
        ],
      );

      return sleepData.fold<int>(0, (sum, e) {
        final duration = e.dateTo.difference(e.dateFrom).inMinutes;
        return sum + duration;
      });
    } catch (e) {
      print('Error fetching sleep: $e');
      return 0;
    }
  }

  Future<SleepData> fetchSleepData() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(hours: 24));

    try {
      final data = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: now,
        types: [
          HealthDataType.SLEEP_DEEP,
          HealthDataType.SLEEP_LIGHT,
          HealthDataType.SLEEP_AWAKE,
        ],
      );

      int deep = data
          .where((e) => e.type == HealthDataType.SLEEP_DEEP)
          .fold(0, (sum, e) => sum + e.dateTo.difference(e.dateFrom).inMinutes);
      int light = data
          .where((e) => e.type == HealthDataType.SLEEP_LIGHT)
          .fold(0, (sum, e) => sum + e.dateTo.difference(e.dateFrom).inMinutes);
      int wake = data
          .where((e) => e.type == HealthDataType.SLEEP_AWAKE)
          .fold(0, (sum, e) => sum + e.dateTo.difference(e.dateFrom).inMinutes);

      data.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
      final startStr = data.isNotEmpty ? DateFormat('HH:mm').format(data.first.dateFrom) : '00:00';
      final endStr = data.isNotEmpty ? DateFormat('HH:mm').format(data.last.dateTo) : '00:00';

      return SleepData(
        deep: deep,
        light: light,
        wake: wake,
        start: startStr,
        end: endStr,
      );
    } catch (e) {
      print('Error fetching sleep data: $e');
      return SleepData(deep: 0, light: 0, wake: 0, start: '00:00', end: '00:00');
    }
  }
}

class SleepData {
  final int deep;
  final int light;
  final int wake;
  final String start;
  final String end;

  SleepData({
    required this.deep,
    required this.light,
    required this.wake,
    required this.start,
    required this.end,
  });
}
