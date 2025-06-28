// lib/sound_manager.dart

import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();

  static void playBubbleTapSound(bool isSoundOn) {
    if (!isSoundOn) return;
    _player.play(AssetSource('audio/popsound.mp3'));
  }

  static void playCorrectSound(bool isSoundOn) {
    if (!isSoundOn) return;
    _player.play(AssetSource('audio/correct.mp3'));
  }

  static void playIncorrectSound(bool isSoundOn) {
    if (!isSoundOn) return;
    _player.play(AssetSource('audio/incorrect.mp3'));
  }
}