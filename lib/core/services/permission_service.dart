import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// Hardware permission states for GestuTalk AI engine
class HardwarePermissionsState {
  final bool hasCamera;
  final bool hasMicrophone;
  final bool isChecking;
  final String? errorMessage;

  const HardwarePermissionsState({
    this.hasCamera = false,
    this.hasMicrophone = false,
    this.isChecking = false,
    this.errorMessage,
  });

  bool get hasAllPermissions => hasCamera && hasMicrophone;

  HardwarePermissionsState copyWith({
    bool? hasCamera,
    bool? hasMicrophone,
    bool? isChecking,
    String? errorMessage,
  }) {
    return HardwarePermissionsState(
      hasCamera: hasCamera ?? this.hasCamera,
      hasMicrophone: hasMicrophone ?? this.hasMicrophone,
      isChecking: isChecking ?? this.isChecking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Service managing hardware permission checks for real-time AI computer vision & audio
class PermissionService extends StateNotifier<HardwarePermissionsState> {
  PermissionService() : super(const HardwarePermissionsState()) {
    checkPermissions();
  }

  /// Check current hardware permissions
  Future<void> checkPermissions() async {
    state = state.copyWith(isChecking: true);
    try {
      final cameraStatus = await Permission.camera.status;
      final micStatus = await Permission.microphone.status;

      state = state.copyWith(
        hasCamera: cameraStatus.isGranted,
        hasMicrophone: micStatus.isGranted,
        isChecking: false,
      );
    } catch (e) {
      state = state.copyWith(
        isChecking: false,
        errorMessage: 'Failed to verify permissions: $e',
      );
    }
  }

  /// Request both Camera & Microphone permissions for AI processing
  Future<bool> requestAllHardwarePermissions() async {
    state = state.copyWith(isChecking: true);
    try {
      final statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();

      final cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
      final micGranted = statuses[Permission.microphone]?.isGranted ?? false;

      state = state.copyWith(
        hasCamera: cameraGranted,
        hasMicrophone: micGranted,
        isChecking: false,
      );

      return cameraGranted && micGranted;
    } catch (e) {
      state = state.copyWith(
        isChecking: false,
        errorMessage: 'Error requesting permissions: $e',
      );
      return false;
    }
  }

  /// Request Camera specifically for sign recognition
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    final granted = status.isGranted;
    state = state.copyWith(hasCamera: granted);
    return granted;
  }

  /// Request Microphone specifically for speech translation
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    final granted = status.isGranted;
    state = state.copyWith(hasMicrophone: granted);
    return granted;
  }

  /// Open device app settings if permissions permanently denied
  Future<void> openSettings() async {
    await openAppSettings();
  }
}

/// Riverpod provider for hardware permissions
final permissionServiceProvider =
    StateNotifierProvider<PermissionService, HardwarePermissionsState>((ref) {
  return PermissionService();
});

