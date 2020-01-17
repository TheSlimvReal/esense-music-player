import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:event_bus/event_bus.dart';

class MusicPlayer {
  final String folderPath = 'assets/';
  AssetsAudioPlayer player;
  List<AssetsAudio> songs = [];
  List<String> songNames = [];
  int current = -1;
  Stream<bool> isPlayingStream;
  EventBus songChangedBus;

  MusicPlayer({this.songChangedBus}) {
    this.player = new AssetsAudioPlayer();
    this.songNames = this._getSongNames();
    this.songs = this._initializeSongs();
    this.isPlayingStream = this.player.isPlaying;
  }

  List<String> _getSongNames() {
    return [
      '00. Kygo - Piano Jam.mp3',
      '01. Lost Frequencie - Reality.mp3',
      '02. Cro - Bye Bye (MTV Unplugged).mp3',
      '03. Robin Schulz - Sugar (feat. Francesco Yates).mp3',
      '04. Anna Naklab - Supergirl (feat. Alle Farben & Younotus).mp3',
      '05. Felix Jaehn - Ain\'t Nobody (Loves Me Better) (feat. Jasmine '
          'Thompson).mp3',
      '06. Kygo - Stole The Show (feat. Parson James).mp3',
      '07. Gestört Aber GeiL & Koby Funk - Unter meiner Haut.mp3',
      '08. Ed Sheeran - Photograph.mp3',
      '09. Major Lazer & DJ Snake - Lean On (feat. MØ).mp3',
      '10. Avicii - Waiting For Love.mp3',
      '11. Sarah Connor - Wie Schön Du Bist.mp3',
      '12. Feder - Goodbye (feat. Lyse) [Radio Edit].mp3',
      '13. Jason Derulo - Want To Want Me.mp3',
      '14. Martin Solveig & GTA - Intoxicated.mp3',
      '15. David Guetta - Hey Mama (feat. Nicki Minaj & Afrojack).mp3',
      '16. MoTrip - So wie du bist.mp3',
      '17. Joris - Herz ber Kopf.mp3',
      '18. Lost Frequencies - Are You With Me.mp3',
      '19. Walk The Moon - Shut Up and Dance.mp3',
      '20. DJ Antoine - Holiday (feat. Akon).mp3'
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
    if (this.current == -1) {
      this.selectSong(0);
    }
    this.player.playOrPause();
  }

  void next() {
    int nextSong = (this.current + 1) % this.songs.length;
    this.pauseIfPlaying();
    this.selectSong(nextSong);
    this.player.play();
  }

  void previous() {
    int previousSong =
        (this.current + this.songs.length - 1) % this.songs.length;
    this.pauseIfPlaying();
    this.selectSong(previousSong);
    this.player.play();
  }

  void playSong(int songNumber) {
    if (this.current != songNumber) {
      this.pauseIfPlaying();
      this.selectSong(songNumber);
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

  void selectSong(int number) {
    this.current = number;
    this.player.open(this.songs[number]);
    this.songChangedBus.fire(number);
  }
}