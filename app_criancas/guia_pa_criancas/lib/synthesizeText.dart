import 'dart:convert';
import 'package:audioplayer/audioplayer.dart';
import 'package:path_provider/path_provider.dart';
import 'TextToSpeechAPI.dart';
import 'dart:io';



class Synth {
  AudioPlayer audioPlugin = AudioPlayer();

  void synthesizeText(String text) async {
    if (audioPlugin.state == AudioPlayerState.PLAYING) {
      await audioPlugin.stop();
    }
    // Hard coding the voice related settings
    final String audioContent = await TextToSpeechAPI().synthesizeText(text, 'pt-PT-Wavenet-B', 'pt-PT');
    if (audioContent == null) return;
    final bytes = Base64Decoder().convert(audioContent, 0, audioContent.length);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/wavenet.mp3');
    await file.writeAsBytes(bytes);
    await audioPlugin.play(file.path, isLocal: true);
  }
}