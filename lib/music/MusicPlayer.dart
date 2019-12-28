import 'package:assets_audio_player/assets_audio_player.dart';

class MusicPlayer {
  final String folderPath = 'assets/';
  AssetsAudioPlayer player;
  List<AssetsAudio> songs = [];
  int current = -1;

  MusicPlayer() {
    this.player = new AssetsAudioPlayer();
    this._initializeSongs();
  }

  _initializeSongs() {
    for (var i = 1; i < 4; i++) {
      songs.add(AssetsAudio(
        asset: 'song$i.mp3',
        folder: folderPath
      ));
    }
  }

  playOrPause() {
    if (current == -1) {
      this.player.open(songs[0]);
    }
    this.player.playOrPause();
  }

  next() {
    int nextSong = (this.current + 1) % this.songs.length;
      this.player.pause();
    this.player.open(this.songs[nextSong]);
    this.player.play();
  }

  previous() {
    int previousSong =
        (this.current + this.songs.length - 1) % this.songs.length;
    this.player.pause();
    this.player.open(this.songs[previousSong]);
    this.player.play();
  }
}