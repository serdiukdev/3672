import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/sound_service.dart';
import 'state.dart';

class SettingsBloc extends Cubit<SettingsState> {
  static const _kAvatar = 'avatar_path';
  static const _kSound = 'sound_enabled';
  static const _kNotifications = 'notifications_enabled';

  final ImagePicker _picker = ImagePicker();

  SettingsBloc() : super(SettingsState.initial);

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final prefs = await SharedPreferences.getInstance();
    final avatar = prefs.getString(_kAvatar);
    final sound = prefs.getBool(_kSound) ?? true;
    final notifs = prefs.getBool(_kNotifications) ?? false;
    emit(
      SettingsState(
        loading: false,
        avatarPath: avatar,
        soundEnabled: sound,
        notificationsEnabled: notifs,
      ),
    );
  }

  Future<void> setSound(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSound, enabled);
    // Update in-memory sound service flag so changes apply immediately
    SoundService().setSoundEnabled(enabled);
    emit(state.copyWith(soundEnabled: enabled));
  }

  Future<bool> setNotifications(bool enable) async {
    if (!enable) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kNotifications, false);
      emit(state.copyWith(notificationsEnabled: false));
      return false;
    }
    final status = await Permission.notification.request();
    final granted = status.isGranted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifications, granted);
    emit(state.copyWith(notificationsEnabled: granted));
    return granted;
  }

  Future<void> pickAvatar(ImageSource source) async {
    final x = await _picker.pickImage(source: source, imageQuality: 85);
    if (x == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAvatar, x.path);
    emit(state.copyWith(avatarPath: x.path));
  }
}
