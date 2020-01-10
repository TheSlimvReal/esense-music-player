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
      '01 - 25.mp3',
      '02 - Heute.mp3',
      '03 - Und Los.mp3',
      '04 - Lass Sehen.mp3',
      '05 - Gegen Jede Vernunft.mp3',
      '06 - Typisch Ich.mp3',
      '07 - Wie Geliebt.mp3',
      '08 - Single.mp3',
      '09 - Disco.mp3',
      '10 - Der Mann Den Nichts Bewegt.mp3',
      '11 - Frieden Wie Denn.mp3',
      '12 - Gott Ist Mein Zeuge.mp3',
      '13 - Das Spiel Ist Aus.mp3'
    ];
  }

  List<AssetsAudio> _initializeSongs() {
    var res = this.songNames.map<AssetsAudio>(
            (name) =>
                AssetsAudio(
                    asset: name,
                    folder: folderPath
                )).toList();
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
    this.pauseIfPlaying();
    this.player.open(this.songs[nextSong]);
    this.player.play();
    this.current = nextSong;
  }

  void previous() {
    int previousSong =
        (this.current + this.songs.length - 1) % this.songs.length;
    this.pauseIfPlaying();
    this.player.open(this.songs[previousSong]);
    this.player.play();
    this.current = previousSong;
  }

  void playSong(int songNumber) {
    if (this.current != songNumber) {
      this.pauseIfPlaying();
      this.current = songNumber;
      this.player.open(this.songs[songNumber]);
      this.player.play();
    }
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

  void pauseIfPlaying() {
    if (this.isPlaying()) {
      this.player.pause();
    }
  }
}