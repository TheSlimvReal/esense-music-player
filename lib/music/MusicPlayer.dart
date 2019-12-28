import 'package:assets_audio_player/assets_audio_player.dart';

class MusicPlayer {
  final String folderPath = 'assets/';
  AssetsAudioPlayer player;
  List<AssetsAudio> songs = [];
  List<String> songNames = [];
  int current = -1;
  Stream<bool> isPlayingStream;

  MusicPlayer() {
    this.player = new AssetsAudioPlayer();
    this.songNames = this._getSongNames();
    this.songs = this._initializeSongs();
    this.isPlayingStream = this.player.isPlaying;
  }

  List<String> _getSongNames() {
    return [
      'song1.mp3',
      'song2.mp3',
      'song3.mp3'
    ];
  }

  List<AssetsAudio> _initializeSongs() {
    var res = this.songNames.map<AssetsAudio>(
            (name) =>
                AssetsAudio(
                    asset: name,
                    folder: folderPath
                )).toList();
    print('res $res');
    return res;
  }

  void playOrPause() {
    if (current == -1) {
      this.player.open(songs[0]);
      this.current = 0;
    }
    this.player.playOrPause();
  }

  void next() {
    int nextSong = (this.current + 1) % this.songs.length;
    if (this.isPlaying()) {
      this.player.pause();
    }
    this.player.open(this.songs[nextSong]);
    this.player.play();
    this.current = nextSong;
  }

  void previous() {
    int previousSong =
        (this.current + this.songs.length - 1) % this.songs.length;
    if (this.isPlaying()) {
      this.player.pause();
    }
    this.player.open(this.songs[previousSong]);
    this.player.play();
    this.current = previousSong;
  }

  bool isPlaying() {
    return !this.player.isPlaying.value;
  }

  String getSongTitle() {
    if (current == -1) {
      return '';
    } else {
      return this.songNames[current];
    }
  }
}