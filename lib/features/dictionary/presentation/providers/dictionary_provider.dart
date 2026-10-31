import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents a Custom Sign Language gesture with training metadata
class CustomSign {
  final String id;
  final String label;
  final String? meaning;
  final String? imageAsset;
  final int samplesCount;
  final double accuracy;
  final String category;
  final bool isTrained;
  final DateTime createdAt;

  const CustomSign({
    required this.id,
    required this.label,
    this.meaning,
    this.imageAsset,
    this.samplesCount = 10,
    this.accuracy = 0.97,
    this.category = 'General',
    this.isTrained = true,
    required this.createdAt,
  });

  CustomSign copyWith({
    String? id,
    String? label,
    String? meaning,
    String? imageAsset,
    int? samplesCount,
    double? accuracy,
    String? category,
    bool? isTrained,
    DateTime? createdAt,
  }) {
    return CustomSign(
      id: id ?? this.id,
      label: label ?? this.label,
      meaning: meaning ?? this.meaning,
      imageAsset: imageAsset ?? this.imageAsset,
      samplesCount: samplesCount ?? this.samplesCount,
      accuracy: accuracy ?? this.accuracy,
      category: category ?? this.category,
      isTrained: isTrained ?? this.isTrained,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DictionaryState {
  final List<CustomSign> signs;
  final bool isTraining;
  final double trainingProgress; // 0.0 to 1.0

  const DictionaryState({
    this.signs = const [],
    this.isTraining = false,
    this.trainingProgress = 0.0,
  });

  DictionaryState copyWith({
    List<CustomSign>? signs,
    bool? isTraining,
    double? trainingProgress,
  }) {
    return DictionaryState(
      signs: signs ?? this.signs,
      isTraining: isTraining ?? this.isTraining,
      trainingProgress: trainingProgress ?? this.trainingProgress,
    );
  }
}

class DictionaryNotifier extends StateNotifier<DictionaryState> {
  DictionaryNotifier()
      : super(
          DictionaryState(
            signs: [
              CustomSign(
                id: 's1',
                label: 'HELP',
                meaning: 'Request urgent assistance',
                category: 'Emergency',
                accuracy: 0.99,
                createdAt: DateTime.now().subtract(const Duration(days: 10)),
              ),
              CustomSign(
                id: 's2',
                label: 'FRIEND',
                meaning: 'Companionship / Ally',
                category: 'Social',
                accuracy: 0.98,
                createdAt: DateTime.now().subtract(const Duration(days: 8)),
              ),
              CustomSign(
                id: 's3',
                label: 'YES',
                meaning: 'Affirmative / Agree',
                category: 'Basic',
                accuracy: 0.99,
                createdAt: DateTime.now().subtract(const Duration(days: 6)),
              ),
              CustomSign(
                id: 's4',
                label: 'NO',
                meaning: 'Negative / Disagree',
                category: 'Basic',
                accuracy: 0.97,
                createdAt: DateTime.now().subtract(const Duration(days: 5)),
              ),
              CustomSign(
                id: 's5',
                label: 'TIME',
                meaning: 'Current hour / Timing',
                category: 'Daily',
                accuracy: 0.96,
                createdAt: DateTime.now().subtract(const Duration(days: 3)),
              ),
              CustomSign(
                id: 's6',
                label: 'STOP',
                meaning: 'Halt / Discontinue',
                category: 'Emergency',
                accuracy: 0.98,
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
            ],
          ),
        );

  /// Quick add sign
  void addSign(String label, {String? meaning, String? category}) {
    final cleanLabel = label.trim().toUpperCase();
    if (cleanLabel.isEmpty) return;

    final newSign = CustomSign(
      id: 'sign_${DateTime.now().millisecondsSinceEpoch}',
      label: cleanLabel,
      meaning: meaning?.trim() ?? 'Custom trained sign',
      category: category ?? 'Custom',
      samplesCount: 12,
      accuracy: 0.98,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(signs: [...state.signs, newSign]);
  }

  /// Add custom trained sign with full training session metrics
  void addTrainedSign({
    required String label,
    required String meaning,
    required String category,
    required int samplesCount,
    required double accuracy,
  }) {
    final newSign = CustomSign(
      id: 'sign_${DateTime.now().millisecondsSinceEpoch}',
      label: label.trim().toUpperCase(),
      meaning: meaning.trim(),
      category: category,
      samplesCount: samplesCount,
      accuracy: accuracy,
      isTrained: true,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(signs: [...state.signs, newSign]);
  }

  /// Remove a sign from the dictionary
  void deleteSign(String id) {
    state = state.copyWith(
      signs: state.signs.where((s) => s.id != id).toList(),
    );
  }

  /// Update training progress
  void setTrainingProgress(double progress, {bool isTraining = true}) {
    state = state.copyWith(
      isTraining: isTraining,
      trainingProgress: progress,
    );
  }
}

final dictionaryProvider =
    StateNotifierProvider<DictionaryNotifier, DictionaryState>((ref) {
  return DictionaryNotifier();
});
