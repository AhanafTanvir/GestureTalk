import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallRecord {
  final String id;
  final String name;
  final String time;
  final bool isIncoming;
  final String duration;

  const CallRecord({
    required this.id,
    required this.name,
    required this.time,
    required this.isIncoming,
    required this.duration,
  });
}

class CallsState {
  final List<CallRecord> todayCalls;
  final List<String> contacts;

  const CallsState({
    this.todayCalls = const [
      CallRecord(id: 'c1', name: 'Mr. X', time: '10:30 AM', isIncoming: true, duration: '04:12'),
      CallRecord(id: 'c2', name: 'Mr. Y', time: '02:15 PM', isIncoming: false, duration: '01:45'),
      CallRecord(id: 'c3', name: 'Dr. Abhijit', time: '04:00 PM', isIncoming: true, duration: '12:30'),
    ],
    this.contacts = const [
      'Mr. X',
      'Mr. Y',
      'Dr. Abhijit',
      'Shammi Akter',
      'Salman Ahmed',
      'Tuhin Hossain',
    ],
  });
}

final callsProvider = StateProvider<CallsState>((ref) {
  return const CallsState();
});

