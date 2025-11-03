import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'storage_service.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();

  factory SoundService() => _instance;

  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _initialized = false;

  // Sound file paths
  static const String _flipCardSound = 'sounds/flipcard-91468.mp3';
  static const String _winnerSound = 'sounds/winner-game-sound-404167.mp3';
  static const String _gameOverSound = 'sounds/game-over-417465.mp3';

  Future<void> init() async {
    if (_initialized) return;

    // Set audio context for better performance
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);

    // Load saved settings from storage
    final storage = StorageService();
    await storage.init();
    _soundEnabled = storage.getSoundEnabled();
    _vibrationEnabled = storage.getVibrationEnabled();

    _initialized = true;
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  Future<void> playAsset(String assetPath) async {
    if (!_initialized) {
      await init();
    }
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (_) {}
  }
}